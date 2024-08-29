local servers = {
  "angularls","astro", "bashls", "cssls", "cssmodules_ls", "css_variables", "unocss",
  "dockerls", "docker_compose_language_service", "emmet_language_server",
  "html","htmx", "gopls", "jsonls", "biome", "lua_ls", "marksman",
  "mdx_analyzer", "basedpyright", "ruff", "sqlls", "svelte", "taplo",
  "tailwindcss", "templ", "gitlab_ci_ls", "yamlls", "vtsls",
  "prismals","typst_lsp","vacuum","zls",
  -- "snyk_ls"
}

local function config_cmp()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local lspkind = require("lspkind")

  cmp.setup({
    formatting = {
      format = lspkind.cmp_format({
        mode = "text_symbol",
        maxwidth = 50,
        ellipsis_char = "...",
        show_labelDetails = true,
        before = function(entry, vim_item) return vim_item end,
      }),
    },
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert({
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-Esc>"] = cmp.mapping.abort(),
    }),
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature_help" },
      { name = "treesitter" },
      { name = "buffer" },
      { name = "rg" },
    },
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
    enabled = function()
      local disabled = { IncRename = true }
      local cmd = vim.fn.getcmdline():match("%S+")
      return not disabled[cmd] or cmp.close()
    end,
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })
end

local function setup_lsp_keymaps(ev)
  local opts = { buffer = ev.buf }
  local keymap = vim.keymap.set
  keymap("n", "<leader>k", vim.lsp.buf.signature_help, opts)
  keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  keymap("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  keymap("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
  keymap("n", "<leader>q", vim.diagnostic.setloclist, opts)
  keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  keymap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
  keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  keymap({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
  keymap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
end

return {
  { "onsails/lspkind.nvim", event = "VeryLazy", lazy = true },
  {
    "folke/neoconf.nvim",
    lazy = false,
    cmd = "Neoconf",
    config = true,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    cmd = "DapUiToggle",
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end,
  },
  {
    "folke/lazydev.nvim",
    event = "VeryLazy",
    ft = "lua",
    opts = {
      library = { plugins = { "nvim-dap-ui" } },
      integrations = { lspconfig = true, cmp = true },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = true
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    config = function()
      require("mason-lspconfig").setup({ ensure_installed = servers })
    end,
  },
  {
    "zeioth/none-ls-autoload.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline", "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip", "ray-x/cmp-treesitter", "lukas-reineke/cmp-rg",
      { "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" } },
    },
    config = config_cmp,
  },
  {
    "smjonas/inc-rename.nvim",
    event = "VeryLazy",
    cmd = "IncRename",
    config = true
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",
    config = function()
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter" }
        end,
      })
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        setopt = true,
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { "%s" },             click = "v:lua.ScSa" },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
        },
      })
    end,
  },


  {
    "hedyhli/outline.nvim",
    event = "VeryLazy",
    cmd = "Outline",
    config = true
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<F13>",
          clear_suggestion = "<C-Esc>",
          accept_word = "<F25>"
        },
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = setup_lsp_keymaps,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local function setup_server(server, config)
        require("lspconfig")[server].setup(vim.tbl_deep_extend("force", { capabilities = capabilities }, config or {}))
      end

      for _, server in ipairs(servers) do
        setup_server(server)
      end

      -- Custom setups
           setup_server("unocss", {
        filetypes = { "html", "templ", "jsx", "tsx", "js", "ts", "astro", "svelte","javascriptreact", "rescript", "typescriptreact", "vue" },
        init_options = { userLanguages = { templ = "html" } },
      })

      setup_server("emmet_language_server", {
        filetypes = { "html", "templ", "jsx", "tsx", "js", "ts", "astro", "svelte", "templ", "css", "htmldjango", "javascriptreact", "less", "pug", "sass", "scss", "typescriptreact", "htmlangular" },
        init_options = { userLanguages = { templ = "html" } },
      })

      setup_server("gopls", {
        settings = {
          gopls = {
            ["ui.inlayhint.hints"] = {
              compositeLiteralFields = true,
              constantValues = true,
              parameterNames = true,
              assignVariableTypes = true,
              compositeLiteralTypes = true,
              functionTypeParameters = true,
              rangeVariableTypes = true,
            },
          },
        },
      })
 
      setup_server("vtsls", {
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "astro", "svelte" }
      })

      setup_server('jdtls', {
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "Java 22",
                  path = "/usr/lib/jvm/java-22-openjdk",
                  default = true,
                }
              }
            }
          }
        }
      })

      setup_server("lua_ls", {
        on_init = function(client)
          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          })
        end,
        settings = { Lua = { hint = { enable = true } } },
      }) 

      -- setup_server("snyk_ls", {
      --   init_options = {
      --     token = os.getenv("SNYK_TOKEN")
      --   }
      -- })

      setup_server("tailwindcss", {
        filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html", "htmlangular", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ" },
        init_options = { userLanguages = { templ = "html" } },
        cmd = { "tailwindcss-language-server", "--stdio" },
        on_new_config = function(new_config)
          new_config.settings = vim.tbl_deep_extend("force", new_config.settings or {}, {
            editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
            tailwindCSS = {
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning",
              },
              validate = true,
            },
          })
        end,
        root_dir = require("lspconfig").util.root_pattern(
          "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.mjs", "tailwind.config.ts",
          "postcss.config.js", "postcss.config.cjs", "postcss.config.mjs", "postcss.config.ts",
          "package.json", "node_modules", ".git"
        ),
      })
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    enabled = true,
    event = { "LspAttach" },
    opts = {
      priority = 10,
      hide_in_unfocused_buffer = true,
      link_highlights = true,
      validate_config = "auto",
      action_kinds = nil,
      sign = {
        enabled = true,
        text = "💡",
        hl = "LightBulbSign",
      },
      virtual_text = { enabled = false },
      float = { enabled = false },
      status_text = { enabled = false },
      number = { enabled = false },
      line = { enabled = false },
      autocmd = {
        enabled = true,
        updatetime = 200,
        events = { "CursorHold", "CursorHoldI" },
        pattern = { "*" },
      },
      ignore = {
        clients = {},
        ft = {},
        actions_without_kind = false,
      },
    },
  },
  {
    "aznhe21/actions-preview.nvim",
    enabled = true,
    opts = {
      diff = {
        ctxlen = 3,
      },
      backend = { "telescope", "nui" },
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.8,
          height = 0.9,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
    },
  },
  {
    "RRethy/vim-illuminate",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      providers = {
        "lsp",
        -- "treesitter",
        -- "regex",
      },
      large_file_overrides = {
        providers = {},
      },
      filetypes_denylist = {
        "TelescopePrompt",
        "aerial",
        "dirbuf",
        "dirvish",
        "fugitive",
        "neo-tree",
        "text",
        "toggleterm",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](true)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next reference" },
      { "[[", desc = "Prev reference" },
    },
  }, {
  "icholy/lsplinks.nvim",
  keys = {
    {
      "gx",
      function()
        require("lsplinks").gx()
      end,
      mode = { "n" },
      desc = "Open link",
    },
  },
  opts = {
    highlight = true,
    hl_group = "Underlined",
  },
},
 {
    'nvimdev/lspsaga.nvim',
    config = function()
        require('lspsaga').setup({})
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons',     -- optional
    }, event = 'LspAttach'
}
  }
