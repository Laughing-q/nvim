local g = vim.g

g.dashboard_disable_at_vimenter = 0
g.dashboard_disable_statusline = 1
g.dashboard_default_executive = "telescope"
g.dashboard_custom_header = {
"  .                                                                  *                   .                                         .            *",
"       .           .          . .                        .                              .                                           . .             ..",
"    .                               .               .                 .              .    . ",
"              .                 .                    .                         .  .          .                                                        *",
"                      .                          _                     . _     _           .                                   .",
"                                                | |               .     | |   (_)                                              .",
"          .           .         .               | |     __ _ _   _  __ _| |__  _ _ __*  __ _ ______ __ _                   . .           .",
"          .         .                           | |    / _` | | | |/ _` | '_ \\| | '_ \\ / _` |______/ _` |       .                                .",
"                             .                  | |___| (_| | |_| | (_| | | | | | | | | (_| |     | (_| |                        .",
"                   .                            |______\\__,_|\\__,_|\\__, |_| |_|_|_| |_|\\__, |      \\__,.|               .   +",
"                                                                    __/ |               __/ |         | |. .",
"                                                                   |___/.              |___/          |_|               .                               .",
"      .           .    .               x             .              .                     .  .        *",
"                                        .     .                                                           .                         .",
"   .           .      .                       .    .              .            +           .                            x                               .",
"       +   .         .    .                  *            ..                      *            .                 x          .",
"  .                       .                    .  .       .                     .         .                                                        .",
"               .       x     .                   .                                                    . .         .          .    ",
}

g.dashboard_custom_section = {
   a = { description = { "  Find File                 SPC f f" }, command = "Telescope find_files" },
   b = { description = { "  Recents                   SPC f h" }, command = "Telescope oldfiles" },
   c = { description = { "  Find Word                 SPC f w" }, command = "Telescope live_grep" },
}

g.dashboard_custom_footer = {
   "   ",
}
