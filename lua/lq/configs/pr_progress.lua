-- A compact reading view of saved facts, not a dump of the state schema.
local M = {}
local ns = vim.api.nvim_create_namespace("pr_progress")

local function list(value)
	return type(value) == "table" and value or {}
end

local function text(value, fallback)
	return type(value) == "string" and value ~= "" and value:gsub("[\r\n]+", " ") or fallback or "Not recorded"
end

local function short(value, width)
	return vim.fn.strcharpart(text(value), 0, width or 100)
end

function M.render(entry, expanded)
	local state, lines, highlights = entry.state, {}, {}
	local function add(value, hl)
		table.insert(lines, value or "")
		if hl then
			table.insert(highlights, { #lines - 1, hl })
		end
	end
	local function section(title)
		add()
		add(title, "Title")
	end
	local function evidence(value, depth)
		depth = depth or 0
		if type(value) ~= "table" then
			add(string.rep("  ", depth) .. tostring(value))
			return
		end
		for key, item in pairs(value) do
			local label = type(key) == "number" and "• " or tostring(key):gsub("_", " ") .. ": "
			if type(item) == "table" then
				add(string.rep("  ", depth) .. label, "Comment")
				evidence(item, depth + 1)
			else
				add(string.rep("  ", depth) .. label .. tostring(item))
			end
		end
	end
	add(entry.label, "Title")
	add(text(state.status):gsub("%-", " "):upper(), state.status == "ready" and "DiagnosticOk" or "DiagnosticWarn")
	add("Saved " .. text(state.updated_at) .. "  ·  Round " .. tostring(state.round or "?"), "Comment")
	add("Agent-reported checkpoint; check the evidence before approving.", "Comment")
	section("NEXT ACTION")
	add(text(state.next_action))
	local blockers = list(state.blockers)
	if #blockers > 0 then
		section("NEEDS ATTENTION")
		for _, blocker in ipairs(blockers) do
			add("• " .. text(blocker), "DiagnosticWarn")
		end
	end
	section("RECENT WORK")
	local activity = list(state.activity)
	if #activity == 0 then
		add("No activity timeline recorded. Fixes and reviews are summarized below.", "Comment")
	end
	for index = math.max(1, #activity - 4), #activity do
		local item = activity[index]
		if type(item) == "table" then
			add("• " .. text(item.summary))
			add(
				"  "
					.. text(item.at, "Time not recorded")
					.. "  ·  "
					.. text(item.actor)
					.. " / "
					.. text(item.provider),
				"Comment"
			)
		end
	end
	section("SKILLS")
	local usage = list(state.skill_usage)
	if #usage > 0 then
		for _, skill in ipairs(usage) do
			if type(skill) == "table" then
				add("• " .. text(skill.name) .. "  ·  " .. text(skill.role))
				add("  " .. text(skill.application, "Application evidence not recorded"))
			end
		end
	else
		local names = {}
		for _, path in ipairs(list(state.instructions)) do
			if type(path) == "string" then
				local name = path:match("/skills/([^/]+)/SKILL%.md$")
				if name then
					names[name] = true
				end
			end
		end
		local sorted = vim.tbl_keys(names)
		table.sort(sorted)
		add(#sorted > 0 and table.concat(sorted, "  ·  ") or "No skills recorded")
		add("Instruction paths recorded; application evidence is missing.", "Comment")
	end
	section("FINDINGS")
	local fixed, dismissed, open = {}, 0, {}
	for _, finding in ipairs(list(state.findings)) do
		if type(finding) == "table" then
			if finding.disposition == "rejected" then
				dismissed = dismissed + 1
			elseif type(list(finding.resolution).commit) == "string" and list(finding.resolution).commit ~= "" then
				table.insert(fixed, finding)
			else
				table.insert(open, finding)
			end
		end
	end
	add(string.format("%d fixes recorded  ·  %d dismissed  ·  %d unresolved", #fixed, dismissed, #open))
	for _, finding in ipairs(open) do
		add(
			"• " .. text(finding.id) .. "  " .. short(finding.summary or finding.recommendation or finding.location),
			"DiagnosticWarn"
		)
	end
	for index = math.max(1, #fixed - 4), #fixed do
		local finding = fixed[index]
		add(
			"✓ " .. text(finding.id) .. "  " .. short(finding.summary or finding.rationale or finding.recommendation),
			"DiagnosticOk"
		)
	end
	section("CHECKS ON SAVED HEAD")
	local head = list(state.revisions).head
	local older, current = 0, 0
	for _, check in ipairs(list(state.checks)) do
		if type(check) == "table" then
			if type(head) == "string" and head ~= "" and check.checked_sha == head then
				current = current + 1
				local result = text(check.result, "unknown")
				add(
					string.format("%-11s %s", result:upper(), short(check.name or check.command)),
					result == "passed" and "DiagnosticOk" or "DiagnosticWarn"
				)
			else
				older = older + 1
			end
		end
	end
	if current == 0 then
		add("No check results recorded for this head.", "Comment")
	end
	if older > 0 then
		add(older .. " checks on older or unspecified revisions hidden; press d for evidence.", "Comment")
	end
	section("LATEST RECORDED REVIEW")
	local reviews = list(state.reviews)
	local review = list(reviews[#reviews])
	if next(review) then
		add(text(review.outcome) .. "  ·  " .. text(review.review_provider or review.reviewer))
		local reviewed = review.head_sha or review.head
		add("Reviewed " .. short(reviewed, 10) .. (reviewed ~= head and "  (not the saved head)" or ""), "Comment")
	else
		add("No review recorded.", "Comment")
	end
	if expanded then
		for _, field in ipairs({ "skill_usage", "activity", "findings", "checks", "reviews", "instructions" }) do
			section(field:gsub("_", " "):upper() .. " — EVIDENCE")
			evidence(list(state[field]))
		end
	end
	add()
	add("r refresh  ·  d " .. (expanded and "hide" or "show") .. " evidence  ·  q/Q return", "Comment")
	return lines, highlights
end

function M.draw(buf, entry, expanded)
	local lines, highlights = M.render(entry, expanded)
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	for _, mark in ipairs(highlights) do
		vim.api.nvim_buf_set_extmark(buf, ns, mark[1], 0, {
			end_col = #lines[mark[1] + 1],
			hl_group = mark[2],
		})
	end
	vim.bo[buf].modifiable = false
end

return M
