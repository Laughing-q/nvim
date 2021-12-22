return {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "off",
        logLevel = "Warning",
        diagnosticSeverityOverrides = {
          reportUnusedImport = "off",
        },
      },
    },
  }
}
