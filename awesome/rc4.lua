-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- awful.rules = require("awful.rules")
local tyrannical = require("tyrannical")
local mywidgets = require("mywidgets")
local hints = require("hints")

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
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
hints.init()

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -x " .. editor

-- Default keys.
modkey = "Mod4"
altkey = "Mod1"

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
    { "config", myconfigmenu, beautiful.config_icon },
    { "places terminal", myplacestermmenu, beautiful.terminal_icon },
    { "places explorer", myplacemenu, beautiful.explorer_icon },
    { "awesome", myawesomemenu, beautiful.awesome_icon },
  }
})

mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon, menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
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

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end

    gears.wallpaper.maximized(wallpaper, s, true)
  end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
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
  s.mywibox = awful.wibar({ position = "top", screen = s, height = 16 }) -- TODO determine size based on icons

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      mylauncher,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mywidgets.volume(),
      mywidgets.separator(),
      mywidgets.battery(),
      mywidgets.separator(),
      mywidgets.wifi(),
      mywidgets.separator(),
      mywidgets.cpu(),
      mywidgets.separator(),
      awful.widget.keyboardlayout(),
      mywidgets.separator(),
      wibox.widget.systray(),
      mywidgets.separator(),
      mywidgets.clock(),
      mywidgets.separator(),
      s.mylayoutbox,
    },
  }
end)
-- }}}

-- {{{ Tags
tyrannical.tags = {
  {
    name        = "~",
    layout      = awful.layout.suit.fair,
    position = 1,
    screen = {1, 2}, -- force tag on *all* screens
    fallback = true,
  },
  {
    name        = "➋ ·web·🌏",
    layout      = awful.layout.suit.fair,
    position = 2,
    screen = 1, -- TODO: remove
    force_screen = true,
    init = false,
    class = { "firefox" },
    exec_once = "firefox",
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
    exec_once = terminal .. " --title video --working-directory /data/video", -- TODO: make it *really* spawn once
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
    class = { "gimp" },
  },
}
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
  -- custom bindings (HERE FOR NOW)
  awful.key({ modkey,           }, "o",      function () awful.screen.focus_relative(1) end,
    {description = "cycle focus through screens", group = "custom"}),
  awful.key({ modkey, "Shift"   }, "o",      awful.client.movetoscreen, -- TODO: This throws errors
    {description = "move client to next screen", group = "custom"}),
  -- MEDIA KEYS
  awful.key({ }, "XF86MonBrightnessUp", function ()
     awful.util.spawn("xbacklight -inc 15") end),
  awful.key({ }, "XF86MonBrightnessDown", function ()
     awful.util.spawn("xbacklight -dec 15") end),
  awful.key({ }, "XF86ScreenSaver", function ()
     awful.util.spawn("slock")
     awful.util.spawn("xset dpms force off")  end),
  awful.key({ }, "XF86AudioRaiseVolume", function ()
    awful.util.spawn("pulseaudio-ctl mute no")
    awful.util.spawn("pulseaudio-ctl up")
  end),
  awful.key({ }, "XF86AudioLowerVolume", function ()
    awful.util.spawn("pulseaudio-ctl mute no")
    awful.util.spawn("pulseaudio-ctl down")
  end),
  awful.key({ }, "XF86AudioMute", function () -- TODO: Button doesn't seem to work
    awful.util.spawn("pulseaudio-ctl mute")
  end),
  awful.key({ }, "XF86Display", function ()
     awful.util.spawn(os.getenv("HOME") .. "/git/linux-scripts/monitor") end),
  awful.key({modkey}, "F6", function ()
    awful.util.spawn(os.getenv("HOME") .. "/git/linux-scripts/compton-toggle") end),
  awful.key({ }, "Print", function ()
    awful.util.spawn("scrot -e 'mv $f /data/image/screenshots/archlinux'") end),
  awful.key({ modkey }, "F3",     function ()
    local fh = io.popen("xbacklight -get | cut -d '.' -f 1")
    local light = fh:read("*l")
    fh:close()
    if light == "0" then
      awful.util.spawn(os.getenv("HOME") .. "/git/linux-scripts/backlight")
    else
      awful.util.spawn("xbacklight -set 0 -time 0")
    end
  end),
  awful.key({ modkey }, "F4", function () awful.util.spawn("xset dpms force off")  end),
  awful.key({ modkey }, "a", function () hints.focus() end),
  -- awful.key({ modkey }, "r",      function () awful.util.spawn("bashrun") end),
  awful.key({ modkey }, "e",      function () awful.util.spawn("thunar -- " .. os.getenv("HOME") .. "/Desktop") end),

  -- Tag navigation
  awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
    {description="show help", group="awesome"}),
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

  -- Client navigation
  awful.key({ modkey,           }, "j", function ()
    awful.client.focus.byidx(1)
    -- if client.focus then client.focus:raise() end -- TODO: had this in my old rc
  end,
    {description = "focus next by index", group = "client"}),
  awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1) end,
    {description = "focus previous by index", group = "client"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),
  awful.key({ modkey,           }, "Tab",
  function ()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end,
    {description = "go back", group = "client"}),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx( 1) end,
    {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(-1) end,
    {description = "swap with previous client by index", group = "client"}),
  -- awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
  --   {description = "focus the next screen", group = "screen"}),
  -- awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
  --   {description = "focus the previous screen", group = "screen"}),
  --[[ TODO: figure out what this master client thing is
  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),
  --]]
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "u", function () while awful.client.urgent.get() ~= nil do awful.client.urgent.get().urgent = false end end,
    {description = "clear urgent flags", group = "client"}),
  awful.key({ modkey, "Control" }, "n",
  function ()
    local c = awful.client.restore()
    if c then
      client.focus = c
      c:raise()
    end
  end,
    {description = "restore minimized", group = "client"}),

    -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
    {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),


  -- Prompt
  awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    {description = "run prompt", group = "launcher"}),
  awful.key({ modkey }, "x",
  function ()
    awful.prompt.run {
      prompt       = "Run Lua code: ",
      textbox      = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval"
    }
  end,
    {description = "lua execute prompt", group = "awesome"}),
  awful.key({ modkey }, "q", function() menubar.show() end,
    {description = "show the menubar", group = "launcher"})
  -- TODO: Add all the own prompts
)

-- TODO CONTINUE HERE
clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

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

for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
  -- View tag only.
  awful.key({ modkey }, "#" .. i + 9,
  function ()
    -- try and retrieve tag on current screen
    local screen = awful.screen.focused()
    local tag = find_tag_by_position(screen.tags, i)
    if tag then
      -- found -> view it and return
      tag:view_only()
      return
    end

    -- try and retrieve tag on any screen
    tag = find_tag_by_position(root.tags(), i)
    if tag then
      -- found -> view it and return
      tag:view_only()
      awful.screen.focus(tag.screen)
      return
    end

    -- try to find tag to create
    tag = find_tag_by_position(tyrannical.tags_by_name, i)
    --   failed -> abort and return
    if tag == nil then
      return
    end

    -- create and move to tag
    tag = awful.tag.add(tag.name, tag)
    tag:view_only()
    awful.screen.focus(tag.screen) -- it's possible that the tag is forced on another screen
  end,
    {description = "view tag #"..i, group = "tag"}),

  -- Toggle tag display.
  awful.key({ modkey, "Control" }, "#" .. i + 9,
  function ()
    -- TODO: Make this work with not-yet-created tags (if I ever start using this)
    local screen = awful.screen.focused()
    local tag = screen.tags[i]
    if tag then
      awful.tag.viewtoggle(tag)
    end
  end,
    {description = "toggle tag #" .. i, group = "tag"}),

  -- Move client to tag.
  awful.key({ modkey, "Shift" }, "#" .. i + 9,
  function ()
    -- TODO: Make this work with not-yet-created tags
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then
        client.focus:move_to_tag(tag)
        tag:view_only()
      end
    end
  end,
    {description = "move focused client to tag #"..i, group = "tag"}),

  -- Toggle tag on focused client.
  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
  function ()
    -- TODO: Make this work with not-yet-created tags (if I ever start using this)
    if client.focus then
      local tag = client.focus.screen.tags[i]
      if tag then
        client.focus:toggle_tag(tag)
      end
    end
  end,
    {description = "toggle focused client on tag #" .. i, group = "tag"})
  )
end

clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = { },
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen
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

function is_class_opaque(class_name)
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
    if value ~= nil and string.lower(value) == string.lower(class_name) then
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
    c.opacity = 0.95
  end
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
  if is_class_opaque(c.class) then
    c.opacity = 1
  else
    c.opacity = 0.93
  end
end)
-- }}}
