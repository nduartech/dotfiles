return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "java", "lua", "vim", "vimdoc", "sql", "astro", "bash","css","csv","gitignore","go","gomod","gowork","gosum","html","jsdoc","json","markdown_inline","python","regex","scss","svelte","templ","typescript","tsx", "javascript", "yaml" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
    end
  }
