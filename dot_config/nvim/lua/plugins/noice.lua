return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
    presets = {
      inc_rename = true,
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini`<F3> as the fallback
    -- "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      presets = {
        command_palette = false,
        lsp_doc_border = false,
      },
      views = {
        cmdline_popup = {
          border = {
            style = "none",
            padding = { 2, 3 },
          },
          filter_options = {},
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        cmdline_popupmenu = {
          relative = "editor",
          position = {
            row = 8,
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "none",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        mini = {
          win_options = {
            winblend = 0,
          },
        },
        hover = {
          border = {
            style = "none",
          },
        },
        confirm = {
          border = {
            style = "none",
          },
        },
        popup = {
          border = {
            style = "none",
          },
        },
      },
    })
  end,
}
