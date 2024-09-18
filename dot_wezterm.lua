-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night Storm'
config.enable_wayland = true
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.font = wezterm.font "Inconsolata Nerd Font"
config.font_size = 9
config.window_background_opacity = 0.85
config.default_cursor_style = "SteadyBar"
-- and finally, return the configuration to wezterm
return config
