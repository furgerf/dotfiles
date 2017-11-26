-- {{{ Main
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")
local tyrannical = require("tyrannical")
local mywidgets = require("widgets")
local hints = require("hints")

--[[
-- TODO:
-- - improve promtbox
--]]
--}}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
  title = "Oops, there were errors during startup!",
  text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme_name = "mysty"
local wallpaper_timer
local wallpaper_timer_callback
beautiful.init(gears.filesystem.get_themes_dir() .. theme_name .. "/theme.lua")
hints.init()

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -x " .. editor

-- Default keys.
modkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  awful.layout.suit.corner.nw,
  awful.layout.suit.corner.ne,
  awful.layout.suit.corner.sw,
  awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myconfigmenu = {
    { "bash", editor_cmd .. " " .. os.getenv("HOME") .. "/.bashrc" },
    { "awesome", editor_cmd .. " " .. awesome.conffile },
    { "xinit", editor_cmd .. " " .. os.getenv("HOME") .. "/.xinitrc" },
    { "vim", editor_cmd .. " " .. os.getenv("HOME") .. "/.vimrc" },
    { "conky", editor_cmd .. " " .. os.getenv("HOME") .. "/git/dotfiles/arch/conkyrc" },
}
myplacemenu = {
    { "/data", "thunar /data" },
    { "-> audio", "thunar /data/audio" },
    { "-> torrents", "thunar /data/torrents" },
    { "-> video", "thunar /data/video" },
    { "Dropbox", "thunar /data/Dropbox" }
}
myplacestermmenu = {
    { "/data", terminal .. " --working-directory /data" },
    { "-> audio", terminal .. " --working-directory /data/audio" },
    { "-> torrents", terminal .. " --working-directory /data/torrents" },
    { "-> video", terminal .. " --working-directory /data/video" },
    { "Dropbox", terminal .. " --working-directory /data/Dropbox" }
}
myawesomemenu = {
  { "hotkeys", function() return false, hotkeys_popup.show_help end},
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart", awesome.restart },
  { "quit", function() awesome.quit() end}
}
mymainmenu = awful.menu({
  items = {
    { "config", myconfigmenu, beautiful.menu_config_icon },
    { "places terminal", myplacestermmenu, beautiful.menu_terminal_icon },
    { "places explorer", myplacemenu, beautiful.menu_explorer_icon },
    { "awesome", myawesomemenu, beautiful.awesome_icon },
  }
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Tags
tyrannical.tags = {
  {
    name        = "~",
    layout      = awful.layout.suit.fair,
    position = 1,
    screen = {1, 2},
    fallback = true,
    selected = true
  },
  {
    name        = "➋ ·web·🌏",
    layout      = awful.layout.suit.fair,
    position = 2,
    force_screen = true,
    init = false,
    no_focus_stealing_in = true,
    class = { "firefox" },
    -- exec_once = "firefox",
  },
  {
    name        = "➌ ·doc·✎",
    layout      = awful.layout.suit.fair,
    position = 3,
    init = false,
    volatile = true,
    class = {"Okular", "libreoffice.*"},
  },
  {
    name        = "➍ ·code·💡",
    layout      = awful.layout.suit.max.fullscreen,
    position    = 4,
    init = false,
    volatile = true,
  },
  {
    name        = "➎ ·media·♫",
    layout      = awful.layout.suit.floating,
    position    = 5,
    screen      = screen.count(),
    init = false,
    volatile = true,
    class = { "Vlc", "smplayer", "Clementine" },
    -- exec_once = terminal .. " --title video --working-directory /data/video", -- TODO: make it *really* spawn once
  },
  {
    name        = "➏ ·d/l·⇅",
    layout      = awful.layout.suit.tile.bottom,
    position    = 6,
    init = false,
    volatile = true,
    class = { "qBittorrent", "Vuze", "JDownloader", ".*DownThemAll!" },
  },
  {
    name        = "➐ ·foo",
    layout      = awful.layout.suit.tile.bottom,
    position    = 7,
    init = false,
    volatile = true,
    master_width_factor      = 0.7,
  },
  {
    name        = "➑ ·bar",
    layout      = awful.layout.suit.fair,
    position    = 8,
    init = false,
    volatile = true,
  },
  {
    name        = "➒ ·gimp",
    layout      = awful.layout.suit.floating,
    position    = 9,
    screen      = screen.count(),
    init = false,
    volatile = true,
    exclusive = true,
    class = { "Gimp" }
  },
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
  local instance = nil
  return function ()
    if instance and instance.wibox.visible then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ theme = { width = 250 } })
    end
  end
end

local function run_webprompt(title, url, history)
  awful.prompt.run({
    prompt = title,
    textbox = awful.screen.focused().mypromptbox.widget,
    exe_callback = function (word)
      if string.len(word) == 0 then return end
      word = string.gsub(word, " ", "%%20") -- "urlencode for the lazy"
      awful.spawn("firefox -new-tab " .. url .. word)
    end,
    history_path = awful.util.get_cache_dir() .. "/history_" .. history
  })
end
--}}}

-- {{{ Globalkeys - tag/client/layout
globalkeys = gears.table.join(
  -- tag navigation
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "h",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "l",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

  -- tag manipulation
  awful.key({ modkey, shiftkey  }, "d", function () awful.screen.focused().selected_tag:delete() end,
    {description = "delete tag", group = "tag"}),
    -- NOT added from shifty:
    -- - dynamic tag creation (by name)
    -- - tag rename

  -- client navigation
  awful.key({ modkey,           }, "j", function () awful.client.focus.byidx(1) end,
    {description = "focus next by index", group = "client"}),
  awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1) end,
    {description = "focus previous by index", group = "client"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent", group = "client"}),
  awful.key({ modkey,           }, "Tab",
  function ()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end,
    {description = "go back", group = "client"}),
  awful.key({ modkey,           }, "o", function () awful.screen.focus_relative(3) end,
    {description = "cycle focus through screens", group = "client"}),

  -- layout manipulation
  awful.key({ modkey, shiftkey  }, "j", function () awful.client.swap.byidx( 1) end,
    {description = "swap with next by index", group = "client"}),
  awful.key({ modkey, shiftkey  }, "k", function () awful.client.swap.byidx(-1) end,
    {description = "swap with previous by index", group = "client"}),
  -- TODO: check why these are commented out
  -- awful.key({ modkey, ctrlkey   }, "j", function () awful.screen.focus_relative( 1) end,
  --   {description = "focus the next screen", group = "screen"}),
  -- awful.key({ modkey, ctrlkey   }, "k", function () awful.screen.focus_relative(-1) end,
  --   {description = "focus the previous screen", group = "screen"}),
  --[[ TODO: figure out what this master client thing is
  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, shiftkey  }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, shiftkey  }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),
  --]]
  -- TODO: figure out why these don't seem to work
  awful.key({ modkey, ctrlkey   }, "h",     function () awful.tag.incncol( 1, nil, true) end,
    {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, ctrlkey   }, "l",     function () awful.tag.incncol(-1, nil, true) end,
    {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1) end,
    {description = "select next", group = "layout"}),
  awful.key({ modkey, shiftkey  }, "space", function () awful.layout.inc(-1) end,
    {description = "select previous", group = "layout"}),
  awful.key({ modkey, shiftkey  }, "u", function () while awful.client.urgent.get() ~= nil do awful.client.urgent.get().urgent = false end end,
    {description = "clear urgent flags", group = "client"}),
  awful.key({ modkey, shiftkey  }, "n",
  function ()
    local c = awful.client.restore()
    if c then
      client.focus = c
      c:raise()
    end
  end,
    {description = "restore minimized", group = "client"}),
-- }}}

-- {{{ Globalkeys - awesome/custom
  awful.key({ modkey, ctrlkey   }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
  --awful.key({ modkey, shiftkey  }, "q", awesome.quit,
    --{description = "quit awesome", group = "awesome"}),
  awful.key({ modkey,           }, "s", hotkeys_popup.show_help,
    {description="show help", group="awesome"}),
  awful.key({ modkey            }, "a", hints.focus,
    {description = "display client selection hints", group = "awesome"}),
  awful.key({ modkey, ctrlkey   }, "n", naughty.destroy_all_notifications,
    {description = "remove all notifications", group = "awesome"}),

  awful.key({                   }, "XF86MonBrightnessUp", function () awful.spawn("xbacklight -inc 15") end,
    {description = "increase backlight", group = "special keys"}),
  awful.key({                   }, "XF86MonBrightnessDown", function () awful.spawn("xbacklight -dec 15") end,
    {description = "decrease backlight", group = "special keys"}),
  awful.key({ modkey            }, "F3", function () awful.spawn(os.getenv("HOME") .. "/git/linux-scripts/backlight") end,
    {description = "toggle backlight", group = "special keys"}),
  awful.key({                   }, "XF86Launch1", function ()
      awful.spawn("sudo s2ram")
    end,
    {description = "suspend system", group = "special keys"}),
  awful.key({                   }, "XF86ScreenSaver", function ()
      awful.spawn("slock")
      awful.spawn("xset dpms force standby")
    end,
    {description = "lock system", group = "special keys"}),
  awful.key({                   }, "XF86AudioRaiseVolume", function ()
      awful.spawn("pulseaudio-ctl mute no")
      awful.spawn("pulseaudio-ctl up")
    end,
    {description = "increase volume by 5", group = "special keys"}),
  awful.key({ ctrlkey           }, "XF86AudioRaiseVolume", function ()
      awful.spawn("pulseaudio-ctl mute no")
      awful.spawn("pulseaudio-ctl up 20")
    end,
    {description = "increase volume by 20", group = "special keys"}),
  awful.key({ shiftkey          }, "XF86AudioRaiseVolume", function ()
      awful.spawn("pulseaudio-ctl mute no")
      awful.spawn("pulseaudio-ctl up 50")
    end,
    {description = "increase volume by 50", group = "special keys"}),
  awful.key({ ctrlkey, shiftkey }, "XF86AudioRaiseVolume", function ()
      awful.spawn("pulseaudio-ctl mute no")
      awful.spawn("pulseaudio-ctl up 100")
    end,
    {description = "increase volume by 100", group = "special keys"}),
  awful.key({                   }, "XF86AudioLowerVolume", function ()
      awful.spawn("pulseaudio-ctl mute no")
      awful.spawn("pulseaudio-ctl down")
    end,
    {description = "decrease volume by 5", group = "special keys"}),
  awful.key({ ctrlkey           }, "XF86AudioLowerVolume", function ()
      awful.spawn("pulseaudio-ctl mute no")
      awful.spawn("pulseaudio-ctl down 20")
    end,
    {description = "decrease volume by 20", group = "special keys"}),
  awful.key({ shiftkey          }, "XF86AudioLowerVolume", function ()
      awful.spawn("pulseaudio-ctl mute no")
      awful.spawn("pulseaudio-ctl down 50")
    end,
    {description = "decrease volume by 50", group = "special keys"}),
  awful.key({ ctrlkey, shiftkey }, "XF86AudioLowerVolume", function ()
      awful.spawn("pulseaudio-ctl mute no")
      awful.spawn("pulseaudio-ctl down 100")
    end,
    {description = "decrease volume by 100", group = "special keys"}),
  awful.key({                   }, "XF86AudioMicMute", function () awful.spawn("pulseaudio-ctl mute") end, -- use mic mute because normal mute doesn't work
    {description = "toggle audio mute", group = "special keys"}),

  awful.key({                   }, "XF86Display", function () awful.spawn(os.getenv("HOME") .. "/git/linux-scripts/monitor-2") end,
    {description = "toggle external display", group = "special keys"}),
  awful.key({ modkey            }, "F6", function () awful.spawn(os.getenv("HOME") .. "/git/linux-scripts/compton-toggle") end,
    {description = "toggle compton", group = "special keys"}),
  awful.key({                   }, "Print", function ()
    awful.spawn("scrot -e 'mv $f /data/image/screenshots/archlinux'") end,
    {description = "take screenshot", group = "special keys"}),
  awful.key({ modkey            }, "F4", function () awful.spawn("xset dpms force standby")  end,
    {description = "(try to) turn off screen", group = "special keys"}),
  -- awful.key({ modkey            }, "r",      function () awful.spawn("bashrun") end),
  awful.key({ modkey            }, "e",      function () awful.spawn("thunar -- " .. os.getenv("HOME") .. "/Desktop") end,
    {description = "open file explorer", group = "special keys"}),
  awful.key({ modkey, shiftkey  }, "f",      function () awful.spawn_with_shell("notify-send -t 20000 \"$(fortune)\"") end, -- TODO: fix
    {description = "show fortune", group = "special keys"}),
  -- awful.key({ modkey, ctrlkey   }, "t", function () -- TODO: fix translation script
  --   local clip = awful.util.pread("xclip -o")
  --   if clip then
  --     awful.spawn(os.getenv("HOME") .. "/git/linux-scripts/translate \'" .. clip .."\'", false)
  --   end
  -- end),
  awful.key({ modkey, ctrlkey   }, "w", function ()
      if (wallpaper_timer == nil) then return end
      -- execute callback of timer now and re-start timer
      wallpaper_timer_callback()
      wallpaper_timer:again()
    end,
    {description = "change wallpaper", group = "special keys"}),
-- }}}

-- {{{ Globalkeys - launchers
  awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
    {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey            }, "r", function () awful.screen.focused().mypromptbox:run() end,
    {description = "run prompt", group = "launcher"}),
  awful.key({ modkey            }, "x", function ()
      awful.prompt.run({
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      })
    end,
    {description = "run lua execute prompt", group = "launcher"}),
  awful.key({ modkey            }, "q", menubar.show,
    {description = "show the application launcher", group = "launcher"}),
  awful.key({ modkey,           }, "w", function () run_webprompt("Wiki: ", "https://en.wikipedia.org/wiki/", "wiki") end,
    {description = "run wiki prompt", group = "launcher"}),
  awful.key({ modkey, shiftkey  }, "w", function () run_webprompt("ArchWiki: ", "http://wiki.archlinux.org/index.php/", "archwiki") end,
    {description = "run arch wiki prompt", group = "launcher"}),
  awful.key({ modkey,           }, "t", function () run_webprompt("Torrent: ", "http://thepiratebay.se/search/", "torrent") end,
    {description = "run torrent prompt", group = "launcher"}),
  awful.key({ modkey,           }, "g", function () run_webprompt("Google: ", "http://google.com/search?q=", "google") end,
    {description = "run google prompt", group = "launcher"}),
  awful.key({ modkey,           }, "d", function ()
      awful.prompt.run({
        prompt       = "Define: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function (word)
          if string.len(word) == 0 then return end
          local f = io.popen("dict -d wn " .. word .. " 2>&1")
          local fr = ""
          for line in f:lines() do
            fr = fr .. line .. '\n'
          end
          f:close()
          naughty.notify({ text = fr, timeout = 90, width = 400 })
        end,
        history_path = awful.util.get_cache_dir() .. "/history_define"
      }) end,
    {description = "run define prompt", group = "launcher"}),
  awful.key({ modkey,           }, "c", function ()
    awful.prompt.run({
      prompt       = "Calc: ",
      textbox      = awful.screen.focused().mypromptbox.widget,
      exe_callback = function (word)
        if string.len(word) == 0 then return end
        local f = io.popen("calc " .. word)
        local fr = word .. "="
        for line in f:lines() do
          fr = fr .. line
        end
        f:close()
        naughty.notify({ text = fr, timeout = 30})
      end,
      history_path = awful.util.get_cache_dir() .. "/history_calc"
    }) end,
    {description = "run calc prompt", group = "launcher"}),
  awful.key({ modkey, ctrlkey   }, "c", function ()
      awful.prompt.run({
        prompt       = "Units: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function (input)
        if string.len(input) == 0 then return end
        local f = io.popen("units " .. input .. " -d 5 -H '' -1 | cut -d ' ' -f 2-")
        local split = input:gmatch("[^%s]+")
        local fr = split() .. " is "
        for line in f:lines() do
          fr = fr .. line
        end
        f:close()
        fr = fr .. split()
        naughty.notify({ text = fr, timeout = 30})
      end,
      history_path = awful.util.get_cache_dir() .. "/history_units"
    }) end,
    {description = "run units prompt", group = "launcher"})
)
-- }}}

-- {{{ Globalkeys - tag numbers
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.

function find_tag_by_position(tags, position)
  for i, v in pairs(tags) do
    if v.position == position then
      return v
    end
  end
  return nil
end

-- retrieves the tag with the smallest position among the provided table of tags
function get_tag_with_min_position(tags)
  local min_position_tag = tags[1]
  for t in gears.table.iterate(tags, function (item) return true end) do
    if min_position_tag.position > t.position then
      min_position_tag = t
    end
  end
  return min_position_tag
end

-- sorts tags by position
function arrange_tags(tags)
  local own_tags = gears.table.clone(tags)
  -- iterate through tag indices to be "distributed"
  local tag_count = gears.table.reverse(gears.table.keys(own_tags))[1]
  for i = 1, tag_count do
    -- find min-position tag which should receive the current index
    local tag = get_tag_with_min_position(own_tags)
    -- remove the tag from the table of tags that need an index
    for k, v in pairs(own_tags) do
      if v == tag then
        table.remove(own_tags, k)
        break
      end
    end
    -- assign index
    tag.index = i
  end
end

-- ensures that the tag with the requested position exists
-- if it already exists, it is returned, otherwise it's created
function retrieve_tag_by_position(i)
  -- try and retrieve tag on current screen
  local screen = awful.screen.focused()
  local tag = find_tag_by_position(screen.tags, i)
  if tag then return tag end

  -- try and retrieve tag on any screen
  tag = find_tag_by_position(root.tags(), i)
  if tag then return tag end

  -- try to find tag to create
  tag = find_tag_by_position(tyrannical.tags_by_name, i)
  if tag == nil then return end
  -- we found a tag we need to create
  -- but, the tag may be "recycled" and already be assigned to some screen
  -- -> clear the screen to have it created on the current screen
  tag.screen = nil
  -- lastly, we must make sure that all tags on the screen are in the correct order
  tag = awful.tag.add(tag.name, tag)
  arrange_tags(screen.tags)
  return tag
end

for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
  -- View tag only.
  awful.key({ modkey }, "#" .. i + 9,
  function ()
    local tag = retrieve_tag_by_position(i)
    if tag == nil then return end
    tag:view_only()
    awful.screen.focus(tag.screen)
  end,
    {description = "view tag #"..i, group = "tag"}),

  -- Toggle tag display.
  awful.key({ modkey, "Control" }, "#" .. i + 9,
  function ()
    local tag = retrieve_tag_by_position(i)
    if tag == nil then return end
    awful.tag.viewtoggle(tag)
  end,
    {description = "toggle tag #" .. i, group = "tag"}),

  -- Move client to tag.
  awful.key({ modkey, "Shift" }, "#" .. i + 9,
  function ()
    if not client.focus then return end
    local tag = retrieve_tag_by_position(i)
    if tag == nil then return end
    client.focus:move_to_tag(tag)
    tag:view_only()
  end,
    {description = "move focused client to tag #"..i, group = "tag"}),

  -- Toggle tag on focused client.
  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
  function ()
    if not client.focus then return end
    local tag = retrieve_tag_by_position(i)
    if tag == nil then return end
    client.focus:toggle_tag(tag)
  end,
    {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end
-- }}}

-- {{{ Clientkeys
clientkeys = gears.table.join(
  awful.key({ modkey,           }, "f", function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),
  awful.key({ modkey, shiftkey  }, "c", function (c) c:kill() end,
    {description = "close", group = "client"}),
  awful.key({ modkey, ctrlkey   }, "space", awful.client.floating.toggle,
    {description = "toggle floating", group = "client"}),
  awful.key({ modkey, ctrlkey   }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),
  awful.key({ modkey, shiftkey  }, "o", function (c) c:move_to_screen() end,
    {description = "move to next screen", group = "client"}),
  awful.key({ modkey, shiftkey  }, "t", function (c) c.ontop = not c.ontop end,
    {description = "toggle keep on top", group = "client"}),
  awful.key({ modkey,           }, "n", function (c) c.minimized = true end,
    {description = "minimize", group = "client"}),
  awful.key({ modkey,           }, "m", function (c)
      c.maximized = not c.maximized
      c:raise()
    end ,
    {description = "toggle maximize", group = "client"}),
  awful.key({ modkey, ctrlkey   }, "m", function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end ,
    {description = "toggle maximize vertically", group = "client"}),
  awful.key({ modkey, shiftkey  }, "m", function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end ,
    {description = "toggle maximize horizontally", group = "client"})
)
-- }}}

-- {{{ Clientbuttons; set global keys and buttons
-- set client buttons
clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- add own global keys to root keys
root.keys(gears.table.join(root.keys(), globalkeys))

-- right click on wallpaper opens menu
root.buttons(gears.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}

-- {{{ Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      -- Without this, the following
      -- :isvisible() makes no sense
      c.minimized = false
      if not c:isvisible() and c.first_tag then
        c.first_tag:view_only()
      end
      -- This will also un-minimize
      -- the client, if needed
      client.focus = c
      c:raise()
    end
  end),
  awful.button({ }, 3, client_menu_toggle_fn()),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end)
)

local current_wallpaper = beautiful.wallpaper()
local function set_wallpaper(s)
  if not beautiful.wallpaper then return end

  -- If current_wallpaper is a function, call it with the screen
  if type(current_wallpaper) == "function" then
    current_wallpaper = current_wallpaper(s)
  end

  gears.wallpaper.maximized(current_wallpaper, s, true)
end
wallpaper_timer_callback = function ()
  current_wallpaper = beautiful.wallpaper()
  for s in screen do
    set_wallpaper(s)
  end
end

wallpaper_timer = gears.timer({
  timeout = 3600,
  autostart = true,
  callback = wallpaper_timer_callback
})
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local function get_widgets()
  local separator = mywidgets.separator()
  local separator2 = mywidgets.separator2()
  return {
    layout = wibox.layout.fixed.horizontal,
    -- separator,
    mywidgets.volume(),
    separator,
    mywidgets.battery(),
    separator,
    mywidgets.cpu(),
    separator,
    mywidgets.memory(),
    separator,
    mywidgets.hdd(),
    separator,
    mywidgets.net(),
    -- separator,
    -- mywidgets.wifi(),
    separator,
    mywidgets.clock(),
    separator,
    mywidgets.caps_lock(),
    mywidgets.keyboardlayout(),
    wibox.widget.systray(),
  }
end
local shared_widgets = get_widgets()

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
  awful.button({ }, 1, function () awful.layout.inc( 1) end),
  awful.button({ }, 3, function () awful.layout.inc(-1) end),
  awful.button({ }, 4, function () awful.layout.inc( 1) end),
  awful.button({ }, 5, function () awful.layout.inc(-1) end)))
  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s, height = beautiful.wibox_height })

  -- Add widgets to the wibox
  s.mywibox:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    gears.table.join(shared_widgets, { s.mylayoutbox }) -- Right widgets
  })
end)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      -- border_color = beautiful.border_normal, -- to get the borders we want, we apparently need to set the width but not the color
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      size_hints_honor = false, -- make clients fill tile even if they can't use the space
      placement = awful.placement.under_mouse+awful.placement.no_overlap+awful.placement.no_offscreen
    }
  },
  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "plugin-container",
      },
      class = {
        "Arandr",
        "Gpick",
        "Kruler",
        "MessageWin",  -- kalarm.
        "Sxiv",
        "Wpa_gui",
        "pinentry",
        "veromix",
        "xtightvncviewer"
      },
      name = {
        "Event Tester",  -- xev.
        "File Operation Progress",
      },
      role = {
        "AlarmWindow",  -- Thunderbird's calendar.
        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = { floating = true }
  },

  -- Add titlebars to normal clients and dialogs
  -- {
  --   rule_any = {type = { "normal", "dialog" } },
  --   properties = { titlebars_enabled = true }
  -- },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and
    not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
  awful.button({ }, 1, function()
    client.focus = c
    c:raise()
    awful.mouse.client.move(c)
  end),
  awful.button({ }, 3, function()
    client.focus = c
    c:raise()
    awful.mouse.client.resize(c)
  end)
  )

  awful.titlebar(c) : setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
      { -- Right
        awful.titlebar.widget.floatingbutton (c),
        awful.titlebar.widget.maximizedbutton(c),
        awful.titlebar.widget.stickybutton   (c),
        awful.titlebar.widget.ontopbutton    (c),
        awful.titlebar.widget.closebutton    (c),
        layout = wibox.layout.fixed.horizontal()
      },
      layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(c) then
    client.focus = c
  end
end)

local function is_class_opaque(class_name)
  opaque_classes = {
    "vlc",
    "smplayer",
    "mirage",
    "plugin-container",
    "firefox",
    "geeqie",
    "gimp",
    "chromium"
  }

  for index, value in ipairs(opaque_classes) do
    if class_name ~= nil and string.lower(value) == string.lower(class_name) then
      return true
    end
  end
  return false
end

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
  if is_class_opaque(c.class) then
    c.opacity = 1
  else
    c.opacity = beautiful.active_opacity or 0.95
  end
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
  if is_class_opaque(c.class) then
    c.opacity = 1
  else
    c.opacity = beautiful.inactive_opacity or 0.93
  end
end)
-- }}}

