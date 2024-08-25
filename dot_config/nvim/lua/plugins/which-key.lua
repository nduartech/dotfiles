return {
  {
    "mrjones2014/legendary.nvim",
    -- since legendary.nvim handles all your keymaps/commands,
    -- its recommended to load legendary.nvim before other plugins
    priority = 10000,
    lazy = false,
    -- sqlite is only needed if you want to use frecency sorting
    -- dependencies = { 'kkharji/sqlite.lua' }
  },
  {
    "folke/which-key.nvim",
    dependencies = {
      "mrjones2014/legendary.nvim",
      "ThePrimeagen/harpoon",
      "nvim-telescope/telescope.nvim",
    },
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    config = function()
      require("legendary").setup({
        extensions = {
          lazy_nvim = true,
          which_key = { auto_register = true },
        },
      })

      local harpoon = require("harpoon")
      harpoon:setup()
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
            .new({}, {
              prompt_title = "Harpoon",
              finder = require("telescope.finders").new_table({
                results = file_paths,
              }),
              previewer = conf.file_previewer({}),
              sorter = conf.generic_sorter({}),
            })
            :find()
      end

      local wk = require("which-key")
      wk.add({
        { "<leader>h",  vim.lsp.buf.hover,                               desc = "Hover" },
        {
          "<leader>ff",
          function()
            require("telescope.builtin").find_files({})
          end,
          desc = "Find Files",
        },
        {
          "<leader>fg",
          function()
            require("telescope.builtin").live_grep({})
          end,
          desc = "Live Grep",
        },
        {
          "<leader>fb",
          function()
            require("telescope.builtin").buffers({})
          end,
          desc = "Search Buffers",
        },
        {
          "<leader>fh",
          function()
            require("telescope.builtin").help_tags({})
          end,
          desc = "Search Help Tags",
        },
        { "<leader>fs", "<cmd>lua require'rip-substitute'.sub()<cr>",    desc = "Nvim Rip Substitute" },
        { "<leader>m",  "<cmd>Mason<CR>",                                desc = "Mason" },
        { "<leader>o",  "<cmd>Oil<CR>",                                  desc = "Oil" },
        { "<leader>lg", "<cmd>Legendary<cr>",                            desc = "Legend" },
        { "gl",         "<cmd>lua vim.diagnostic.open_float()<cr>",      desc = "Open Diagnostic Float" },
        { "[d",         "<cmd>lua vim.diagnostic.goto_prev()<cr>",       desc = "Prev Diagnostic" },
        { "]d",         "<cmd>lua vim.diagnostic.goto_next()<cr>",       desc = "Next Diagnostic" },
        { "<leader>tb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "DAP Toggle Breakpoint" },
        { "<leader>db", "<cmd>lua require'dap'.continue()<cr>",          desc = "DAP Continue" },
        { "<leader>so", "<cmd>lua require'dap'.step_over()<cr>",         desc = "DAP Step Over" },
        { "<leader>si", "<cmd>lua require'dap'.step_into()<cr>",         desc = "DAP Step Into" },
        { "<leader>di", "<cmd>lua require'dap'.repl.open()<cr>",         desc = "DAP Open REPL" },
        {"<leader>vs", "<cmd>vsplit<cr>", desc="Vertical Split"},
        {"<leader>ad","<cmd>lua AiderOpen('--no-auto-commits --model groq/llama-3.1-70b-versatile')<cr>", desc="Open Aider"},
        {
          "<leader>rn",
          function()
            return ":IncRename " .. vim.fn.expand("<cword>")
          end,
          desc = "Rename",
        },
        { "zR", "<cmd>lua require('ufo').openAllFolds()<cr>",  desc = "Open All Folds" },
        { "zM", "<cmd>lua require('ufo').closeAllFolds()<cr>", desc = "Close All Folds" },
        {
          "<leader>/",
          function()
            harpoon:list():add()
          end,
          desc = "Harpoon This",
        },
        {
          "<leader>*",
          function() toggle_telescope(harpoon:list()) end,
          desc = "Harpoon Menu",
        },
        {
          "<leader>1",
          function()
            harpoon:list():select(1)
          end,
          desc = "Harpoon 1",
        },
        {
          "<leader>2",
          function()
            harpoon:list():select(2)
          end,
          desc = "Harpoon 2",
        },
        {
          "<leader>3",
          function()
            harpoon:list():select(3)
          end,
          desc = "Harpoon 3",
        },
        {
          "<leader>4",
          function()
            harpoon:list():select(4)
          end,
          desc = "Harpoon 4",
        },
        {
          "<leader>8",
          function()
            harpoon:list():prev()
          end,
          desc = "Previous Harpoon",
        },
        {
          "<leader>9",
          function()
            harpoon:list():next()
          end,
          desc = "Next Harpoon",
        },
        {
          "<leader>-",
          function()
            harpoon:list():remove()
          end,
          desc = "Remove Harpoon",
        },
        { "<leader>{", "<cmd>Outline<CR>", desc = "Toggle Outline" }
      })
    end,
  },
}
