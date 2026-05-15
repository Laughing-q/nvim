return {
  -- more settings see https://github.com/microsoft/pyright/blob/main/packages/vscode-pyright/package.json
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        autoImportCompletions = false,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = false,
        typeCheckingMode = "off",
        logLevel = "Warning",
        diagnosticSeverityOverrides = {
          reportUnusedImport = "off",
        },
        exclude = { "**/node_modules", "**/__pycache__", "**/.git", "**/.venv", "**/venv" },
      },
    },
  }
}
