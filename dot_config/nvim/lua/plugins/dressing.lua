return {
  "stevearc/dressing.nvim",
  config = function()
    require("dressing").setup({
      input = {
        border = "none",
      },
      select = {
        backend = { "telescope", "builtin", "nui" },
        telescope = require("telescope.themes").get_ivy({
          borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
          winblend = 0,
        }),
        nui = {
          win_options = {
            winblend = 0,
          },
        },
        builtin = {
          win_options = {
            winblend = 0,
          },
        },
      },
    })
  end,
}
