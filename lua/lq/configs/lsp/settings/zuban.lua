return {
	-- Zuban LSP settings.
	-- Zuban also respects [tool.zuban] in pyproject.toml / mypy.ini.
	-- These settings aim to match the relaxed behaviour of pyright with
	-- typeCheckingMode = "off" and diagnosticMode = "openFilesOnly".
	settings = {
		strict = false,
		disallow_untyped_defs = false,
		warn_unreachable = false,
		check_untyped_defs = false,
		follow_untyped_imports = true,
		ignore_missing_imports = true,
		allow_untyped_globals = true,
		exclude_gitignore = true,
	},
}
