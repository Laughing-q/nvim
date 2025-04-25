return {
	-- more settings see https://github.com/microsoft/pyright/blob/main/packages/vscode-pyright/package.json
	settings = {
		basedpyright = {
			typeCheckingMode = "off",
			analysis = {
				autoSearchPaths = true,
				autoImportCompletions = false,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
				logLevel = "Warning",
				diagnosticSeverityOverrides = {
					-- reportUnusedImport = "none",
					-- reportMissingImports = "none",
					-- reportUnknownVariableType = "none",
					reportPrivateLocalImportUsage = "warning",
				},
			},
		},
	},
}
