-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/echasnovski/mini.animate
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
  "echasnovski/mini.animate",
  version = false,
  event = "VeryLazy",
  config = function()
    require("mini.animate").setup()
  end
}
