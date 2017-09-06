-- {{{ Main
local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local theme_path = gfs.get_themes_dir() .. "mysty"
local theme = {}

theme.wibox_height = dpi(16)
theme.widget_width = dpi(48)
theme.font = "DejaVu Sans 8"
theme.wallpaper_path = theme_path .. "/wallpapers"
theme.active_opacity = 0.95
theme.inactive_opacity = 0.93

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil
-- }}}

-- {{{ Random wallpaper
theme.wallpaper = function()
  -- have to initialize a seed first, else the "random" wallpapers are rather dull
  math.randomseed(os.time())

  -- Get the list of files from a directory. Must be all images or folders and non-empty.
  local wallpapers = {}
  for filename in io.popen([[find "]] .. theme.wallpaper_path .. [[" -type f]]):lines() do
    table.insert(wallpapers, filename)
  end

  -- select one of the wallpapers
  return wallpapers[math.random(#wallpapers)]
end
-- }}}

-- {{{ Colors
-- color palette
theme.colors = {}
theme.colors.white   = "#ffffff"
theme.colors.grey    = "#aaaaaa"
theme.colors.light  = "#D1E9F6"
-- theme.colors.light4  = "#D1E9F6"
-- theme.colors.light3  = "#A2D4ED"
-- theme.colors.light2  = "#74BEE3"
-- theme.colors.light1  = "#45A9DA"
theme.colors.arch    = "#1793d1"
-- theme.colors.dark1   = "#1276A7"
-- theme.colors.dark2   = "#0E587D"
-- theme.colors.dark3   = "#093B54"
-- theme.colors.dark4   = "#051D2A"
theme.colors.dark   = "#051D2A"
theme.colors.black   = "#000000"
theme.colors.pink    = "#ff0022"

-- basics
theme.fg_normal  = theme.colors.grey
theme.bg_normal  = theme.colors.black
theme.fg_focus   = theme.colors.black
theme.bg_focus   = theme.colors.arch
theme.fg_urgent  = theme.colors.dark
theme.bg_urgent  = theme.colors.light
theme.bg_systray = theme.bg_normal
theme.bg_minimize= theme.colors.pink --
theme.fg_minimize= theme.colors.pink --

-- others
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
theme.mouse_finder_color = theme.colors.pink
-- mouse_finder_[timeout|animate_timeout|radius|factor]

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

-- widgets
theme.widget_bg   = theme.colors.black
theme.widget_border = gears.color.transparent
theme.widget_graph_low  = theme.colors.grey
theme.widget_graph_high = theme.colors.arch
-- }}}

-- {{{ Borders
theme.useless_gap  = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_urgent
-- }}}

-- {{{ Taglist
local taglist_square_size = 4
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
-- }}}

-- {{{ Menu
theme.menu_height = dpi(20)
theme.menu_width  = dpi(200)

theme.menu_bg_normal = theme.bg_normal
theme.menu_fg_normal = theme.fg_normal
theme.menu_bg_focus = theme.bg_focus
theme.menu_fg_focus = theme.fg_focus

theme.menu_border_color = theme.fg_urgent
theme.menu_border_width = dpi(2)

-- icons for the menu
-- theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)
theme.awesome_icon       = theme_path .. "/menu/awesome.png"
theme.menu_submenu_icon  = theme_path .. "/menu/submenu.png"
theme.menu_config_icon   = theme_path .. "/menu/config.png"
theme.menu_explorer_icon = theme_path .. "/menu/explorer.png"
theme.menu_terminal_icon = theme_path .. "/menu/terminal.png"
-- }}}

-- {{{ Widget icons
theme.widget_arr0           = theme_path .. "/widget/arr0.png"
theme.widget_arr1           = theme_path .. "/widget/arr1.png"
theme.widget_arr2           = theme_path .. "/widget/arr2.png"
theme.widget_arr3           = theme_path .. "/widget/arr3.png"
theme.widget_battery1       = theme_path .. "/widget/battery1.png"
theme.widget_battery2       = theme_path .. "/widget/battery2.png"
theme.widget_battery3       = theme_path .. "/widget/battery3.png"
theme.widget_battery4       = theme_path .. "/widget/battery4.png"
theme.widget_battery5       = theme_path .. "/widget/battery5.png"
theme.widget_battery6       = theme_path .. "/widget/battery6.png"
theme.widget_battery7       = theme_path .. "/widget/battery7.png"
theme.widget_battery8       = theme_path .. "/widget/battery8.png"
theme.widget_battery9       = theme_path .. "/widget/battery9.png"
theme.widget_battery10      = theme_path .. "/widget/battery10.png"
theme.widget_battery11      = theme_path .. "/widget/battery11.png"
theme.widget_caps           = theme_path .. "/widget/caps.png"
theme.widget_layout_ch      = theme_path .. "/widget/ch.png"
theme.widget_layout_us      = theme_path .. "/widget/us.png"
theme.widget_mem            = theme_path .. "/widget/mem.png"
theme.widget_cpu            = theme_path .. "/widget/cpu.png"
theme.widget_net            = theme_path .. "/widget/net.png"
theme.widget_hdd            = theme_path .. "/widget/hdd.png"
theme.widget_sound_1_25     = theme_path .. "/widget/sound_1-25.png"
theme.widget_sound_26_50    = theme_path .. "/widget/sound_26-50.png"
theme.widget_sound_51_75    = theme_path .. "/widget/sound_51-75.png"
theme.widget_sound_76_100   = theme_path .. "/widget/sound_76-100.png"
theme.widget_sound_mute     = theme_path .. "/widget/sound_mute.png"
theme.widget_wifinone       = theme_path .. "/widget/nowifi.png"
theme.widget_wifi1          = theme_path .. "/widget/wifi1.png"
theme.widget_wifi2          = theme_path .. "/widget/wifi2.png"
theme.widget_wifi3          = theme_path .. "/widget/wifi3.png"
theme.widget_wifi4          = theme_path .. "/widget/wifi4.png"
theme.widget_wifi5          = theme_path .. "/widget/wifi5.png"
theme.widget_ethernet       = theme_path .. "/widget/ethernet.png"
-- }}}

-- {{{ Layout icons
theme.layout_fairv      = theme_path .. "/layouts/fairvw.png"
theme.layout_fairh      = theme_path .. "/layouts/fairhw.png"
theme.layout_spiral     = theme_path .. "/layouts/spiralw.png"
theme.layout_dwindle    = theme_path .. "/layouts/dwindlew.png"
theme.layout_max        = theme_path .. "/layouts/maxw.png"
theme.layout_fullscreen = theme_path .. "/layouts/fullscreenw.png"
theme.layout_magnifier  = theme_path .. "/layouts/magnifierw.png"
theme.layout_floating   = theme_path .. "/layouts/floatingw.png"
theme.layout_tile       = theme_path .. "/layouts/tilew.png"
theme.layout_tileleft   = theme_path .. "/layouts/tileleftw.png"
theme.layout_tilebottom = theme_path .. "/layouts/tilebottomw.png"
theme.layout_tiletop    = theme_path .. "/layouts/tiletopw.png"
theme.layout_cornernw   = theme_path .. "/layouts/cornernww.png"
theme.layout_cornerne   = theme_path .. "/layouts/cornernew.png"
theme.layout_cornersw   = theme_path .. "/layouts/cornersww.png"
theme.layout_cornerse   = theme_path .. "/layouts/cornersew.png"
-- }}}

-- {{{ Titlebar icons
theme.titlebar_close_button_focus               = theme_path .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme_path .. "/titlebar/close_normal.png"
theme.titlebar_floating_button_focus_active     = theme_path .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme_path .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme_path .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme_path .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme_path .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme_path .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme_path .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme_path .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_minimize_button_focus            = theme_path .. "/titlebar/minimize_focus.png"
theme.titlebar_minimize_button_normal           = theme_path .. "/titlebar/minimize_normal.png"
theme.titlebar_ontop_button_focus_active        = theme_path .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme_path .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme_path .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme_path .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme_path .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme_path .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme_path .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme_path .. "/titlebar/sticky_normal_inactive.png"
-- }}}

return theme

