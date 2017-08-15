-- {{{ Main

local theme_assets = require("beautiful.theme_assets")
local gfs = require("gears.filesystem")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local themes_path = gfs.get_themes_dir()
local theme = {}

theme.font      = "DejaVu Sans 8"

-- TODO: Remove all the unnecessary/unused stuff
-- TODO: Make icons transparent
-- TODO: Look at (missing) default icons

-- base colors
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
-- }}}

-- {{{ Colors
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
theme.vol_bg      = theme.bg_urgent
theme.cpu_bg      = theme.fg_urgent
theme.cpu_fg_low  = theme.fg_normal
theme.cpu_fg_high = theme.bg_focus
theme.cpu_border  = theme.fg_urgent
theme.mem_bg      = theme._normal
theme.mem_fg_low  = theme.fg_normal
theme.mem_fg_high = theme.bg_focus
theme.mem_border  = theme.fg_urgent
theme.hdd_bg      = theme.bg_normal
theme.hdd_fg_low  = theme.fg_normal
theme.hdd_fg_high = theme.bg_focus
theme.hdd_border  = theme.fg_urgent
theme.hdd_bg      = theme.bg_normal
theme.batt_bg     = theme.bg_normal
theme.net_bg      = theme.bg_normal
-- }}}

-- {{{ Borders
theme.useless_gap  = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.bg_urgent
-- }}}

-- Generate taglist squares:
--[[
local taglist_square_size = 4
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
--]]


-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(20)
theme.menu_width  = dpi(200)

-- invert normal colors to stand out (since window behind menu is likely focused)
theme.menu_bg_normal = theme.bg_focus
theme.menu_fg_normal = theme.fg_focus
theme.menu_bg_focus = theme.bg_normal
theme.menu_fg_focus = theme.fg_normal

theme.menu_border_color = theme.colors.fg_urgent
theme.menu_border_width = dpi(2)
-- }}}

-- {{{ General icons
-- theme.awesome_icon                              = themes_path .. "/archdove/icons/awesome-icon.png"
theme.clear_icon                                = themes_path .. "/archdove/icons/clear.png"
-- theme.clear_icon                                = themes_path .. "/archdove/icons/llauncher.png"
theme.menu_submenu_icon                         = themes_path .. "/archdove/icons/submenu.png"
theme.tasklist_floating_icon                    = themes_path .. "/archdove/icons/floatingm.png"
theme.titlebar_close_button_focus               = themes_path .. "/archdove/icons/close_focus.png"
theme.titlebar_close_button_normal              = themes_path .. "/archdove/icons/close_normal.png"
theme.titlebar_ontop_button_focus_active        = themes_path .. "/archdove/icons/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = themes_path .. "/archdove/icons/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = themes_path .. "/archdove/icons/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = themes_path .. "/archdove/icons/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = themes_path .. "/archdove/icons/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = themes_path .. "/archdove/icons/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = themes_path .. "/archdove/icons/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = themes_path .. "/archdove/icons/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = themes_path .. "/archdove/icons/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = themes_path .. "/archdove/icons/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = themes_path .. "/archdove/icons/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = themes_path .. "/archdove/icons/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = themes_path .. "/archdove/icons/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = themes_path .. "/archdove/icons/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "/archdove/icons/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path .. "/archdove/icons/maximized_normal_inactive.png"
theme.taglist_squares_sel                       = themes_path .. "/archdove/icons/square_sel.png"
theme.taglist_squares_unsel                     = themes_path .. "/archdove/icons/square_unsel.png"
-- }}}

-- {{{ Widget icons
theme.widget_battery                            = themes_path .. "/archdove/icons/battery.png"
theme.widget_mem                                = themes_path .. "/archdove/icons/mem.png"
theme.widget_cpu                                = themes_path .. "/archdove/icons/cpu.png"
theme.widget_temp                               = themes_path .. "/archdove/icons/temp.png"
theme.widget_net                                = themes_path .. "/archdove/icons/net.png"
theme.widget_hdd                                = themes_path .. "/archdove/icons/hdd.png"
theme.widget_music                              = themes_path .. "/archdove/icons/music.png"
theme.widget_task                               = themes_path .. "/archdove/icons/task.png"
theme.widget_mail                               = themes_path .. "/archdove/icons/mail.png"
theme.widget_caps                               = themes_path .. "/archdove/icons/caps.png"
theme.arr1                                      = themes_path .. "/archdove/icons/arr1.png"
theme.arr2                                      = themes_path .. "/archdove/icons/arr2.png"
theme.arr3                                      = themes_path .. "/archdove/icons/arr3.png"
theme.arr4                                      = themes_path .. "/archdove/icons/arr4.png"
theme.arr5                                      = themes_path .. "/archdove/icons/arr5.png"
theme.arr6                                      = themes_path .. "/archdove/icons/arr6.png"
theme.arr7                                      = themes_path .. "/archdove/icons/arr7.png"
theme.arr8                                      = themes_path .. "/archdove/icons/arr8.png"
theme.arr9                                      = themes_path .. "/archdove/icons/arr9.png"
theme.arr0                                      = themes_path .. "/archdove/icons/arr0.png"
theme.sound_1_25        = themes_path .. "/archdove/icons/sound_1-25.png"
theme.sound_26_50       = themes_path .. "/archdove/icons/sound_26-50.png"
theme.sound_51_75       = themes_path .. "/archdove/icons/sound_51-75.png"
theme.sound_76_100        = themes_path .. "/archdove/icons/sound_76-100.png"
theme.sound_mute        = themes_path .. "/archdove/icons/sound_mute.png"
theme.battery1          = themes_path .. "/archdove/icons/battery1.png"
theme.battery2          = themes_path .. "/archdove/icons/battery2.png"
theme.battery3          = themes_path .. "/archdove/icons/battery3.png"
theme.battery4          = themes_path .. "/archdove/icons/battery4.png"
theme.battery5          = themes_path .. "/archdove/icons/battery5.png"
theme.battery6          = themes_path .. "/archdove/icons/battery6.png"
theme.battery7          = themes_path .. "/archdove/icons/battery7.png"
theme.battery8          = themes_path .. "/archdove/icons/battery8.png"
theme.battery9          = themes_path .. "/archdove/icons/battery9.png"
theme.battery10         = themes_path .. "/archdove/icons/battery10.png"
theme.battery11         = themes_path .. "/archdove/icons/battery11.png"
theme.wifinone          = themes_path .. "/archdove/icons/nowifi.png"
theme.wifi1         = themes_path .. "/archdove/icons/wifi1.png"
theme.wifi2         = themes_path .. "/archdove/icons/wifi2.png"
theme.wifi3         = themes_path .. "/archdove/icons/wifi3.png"
theme.wifi4         = themes_path .. "/archdove/icons/wifi4.png"
theme.wifi5         = themes_path .. "/archdove/icons/wifi5.png"
theme.ethernet              = themes_path .. "/archdove/icons/ethernet.png"
theme.config_icon       = themes_path .. "/archdove/icons/config.png"
theme.explorer_icon       = themes_path .. "/archdove/icons/explorer.png"
theme.terminal_icon       = themes_path .. "/archdove/icons/terminal.png"
theme.layout_ch       = themes_path .. "/archdove/icons/ch.png"
theme.layout_us       = themes_path .. "/archdove/icons/us.png"
-- }}}

-- {{{ Layout icons
theme.layout_fairv      = themes_path.."/archdove/layouts/fairvw.png"
theme.layout_fairh      = themes_path.."/archdove/layouts/fairhw.png"
theme.layout_spiral     = themes_path.."/archdove/layouts/spiralw.png"
theme.layout_dwindle    = themes_path.."/archdove/layouts/dwindlew.png"
theme.layout_max        = themes_path.."/archdove/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."/archdove/layouts/fullscreenw.png"
theme.layout_magnifier  = themes_path.."/archdove/layouts/magnifierw.png"
theme.layout_floating   = themes_path.."/archdove/layouts/floatingw.png"
theme.layout_tile       = themes_path.."/archdove/layouts/tilew.png"
theme.layout_tileleft   = themes_path.."/archdove/layouts/tileleftw.png"
theme.layout_tilebottom = themes_path.."/archdove/layouts/tilebottomw.png"
theme.layout_tiletop    = themes_path.."/archdove/layouts/tiletopw.png"
theme.layout_cornernw   = themes_path.."/archdove/layouts/cornernww.png"
theme.layout_cornerne   = themes_path.."/archdove/layouts/cornernew.png"
theme.layout_cornersw   = themes_path.."/archdove/layouts/cornersww.png"
theme.layout_cornerse   = themes_path.."/archdove/layouts/cornersew.png"
-- }}}

-- {{{ Titlebar icons
theme.titlebar_close_button_focus  = themes_path.."/archdove/titlebar/close_focus.png"
theme.titlebar_close_button_normal = themes_path.."/archdove/titlebar/close_normal.png"
-- theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
-- theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."/archdove/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = themes_path.."/archdove/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."/archdove/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = themes_path.."/archdove/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."/archdove/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = themes_path.."/archdove/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."/archdove/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = themes_path.."/archdove/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active  = themes_path.."/archdove/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = themes_path.."/archdove/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."/archdove/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = themes_path.."/archdove/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."/archdove/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = themes_path.."/archdove/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."/archdove/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = themes_path.."/archdove/titlebar/maximized_normal_inactive.png"
-- }}}

theme.wallpaper = themes_path.."default/background.png"
theme.wallpaper_path = themes_path.."archdove/wallpapers"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

