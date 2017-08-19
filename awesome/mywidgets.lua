local naughty = require("naughty")
local awful = require("awful")
local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")
local calendar2 = require("calendar2")
local gears = require("gears")

local mywidgets = {}

-- TODO: Check out vicious for more widgets

-- {{{ Separators
function mywidgets.separator ()
  return wibox.widget.textbox("<span color='"..beautiful.fg_urgent.."'> ⚫ </span>")
  -- return wibox.layout(
  -- {
  --   layout = wibox.layout.fixed.horizontal,
  --   wibox.widget.imagebox(beautiful.arr3),
  --   wibox.widget.imagebox(beautiful.arr2)
  -- })
end
function mywidgets.separator2 ()
  return wibox.layout(
  {
    layout = wibox.layout.fixed.horizontal,
    -- wibox.widget.imagebox(beautiful.arr2)
  })
end
-- }}}

-- {{{ Volume
function mywidgets.volume()
  local widget = wibox.widget.textbox()
  local icon = wibox.widget.imagebox()
  local layout = wibox.layout({
    {
      icon,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    {
      widget,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal
  })
  vicious.register(widget, vicious.widgets.volume, function(widget, args)
    local label = { ["♫"] = "O", ["♩"] = "M" }
    local max_volume = 200
    if label[args[2]] == "M" or args[1] <= 0 then
      icon.image = beautiful.sound_mute
    elseif args[1] <= max_volume / 4 then
      icon.image = beautiful.sound_1_25
    elseif args[1] <= max_volume / 2 then
      icon.image = beautiful.sound_26_50
    elseif args[1] <= max_volume / 4 * 3 then
      icon.image = beautiful.sound_51_75
    else
      icon.image = beautiful.sound_76_100
    end
    return " ".. args[1] .. " "
  end, 2, "Master")
  layout:connect_signal("button::press", function()
    awful.util.spawn("amixer sset Master toggle")
  end)
  return layout
end
-- }}}

-- {{{ Battery
function mywidgets.battery()
  local widget = wibox.widget.textbox()
  local icon = wibox.widget.imagebox()
  local layout = wibox.layout({
    {
      icon,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    {
      widget,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal
  })
  vicious.register(widget, vicious.widgets.bat, function(widget, args)
    if args[2] <= 5 then
      icon.image = beautiful.battery1
    elseif args[2] <= 10 then
      icon.image = beautiful.battery2
    elseif args[2] <= 20 then
      icon.image = beautiful.battery3
    elseif args[2] <= 30 then
      icon.image = beautiful.battery4
    elseif args[2] <= 40 then
      icon.image = beautiful.battery5
    elseif args[2] <= 50 then
      icon.image = beautiful.battery6
    elseif args[2] <= 60 then
      icon.image = beautiful.battery7
    elseif args[2] <= 70 then
      icon.image = beautiful.battery8
    elseif args[2] <= 80 then
      icon.image = beautiful.battery9
    elseif args[2] <= 90 then
      icon.image = beautiful.battery10
    else
      icon.image = beautiful.battery11
    end
    local fh = io.popen("acpi | cut -d, -f 3,3 - | cut -b 2-9", "r")
    local charging_duration = fh:read("*l")
    fh.close()
    local charging = charging_duration ~= "" and " (" .. charging_duration .. ")" or ""
    return args[2] .. "% " .. args[1] .. charging
  end, 31, "BAT0")
  return layout
end
-- }}}

-- {{{ Wifi
function mywidgets.wifi()
  -- TODO: Display detailed info on hover
  local widget = wibox.widget.textbox()
  local icon = wibox.widget.imagebox()
  local layout = wibox.layout({
    {
      icon,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    {
      widget,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal
  })
  vicious.register(widget, vicious.widgets.wifi,
  function(widget, args)
    local signal = args['{link}']
    local name = args['{ssid}']
    if signal <= 0 then
      -- no wifi signal - check if we have internet connection
      local handle = io.popen("wget -q --tries=1 --timeout=1 --spider http://google.com &> /dev/null ; echo $?")
      local inet = handle:read("*a")
      handle:close()
      if inet:sub(1, #inet - 1) == "0" then
        -- we're connected to the internet, assume it's via ethernet
        icon.image = beautiful.ethernet
        name = "ethernet"
      else
        icon.image = beautiful.wifinone
      end
    elseif signal <= 20 then
      icon.image = beautiful.wifi1
    elseif signal <= 40 then
      icon.image = beautiful.wifi2
    elseif signal <= 60 then
      icon.image = beautiful.wifi3
    elseif signal <= 80 then
      icon.image = beautiful.wifi4
    else
      icon.image = beautiful.wifi5
    end
    return name
  end, 37, "wlp3s0")
  return layout
end
-- }}}

-- {{{ CPU
function mywidgets.cpu()
  -- TODO: Display detailed info on hover
  local widget = wibox.widget {
    width = 24,
    border_color = beautiful.widget_border,
    background_color = gears.color.transparent,
    widget = wibox.widget.graph
  }
  local icon = wibox.widget.imagebox(beautiful.widget_cpu)
  local mirror = wibox.container.mirror(widget, { horizontal = true })
  local layout = wibox.layout({
    {
      icon,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    {
      mirror,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal
  })
  widget.color = {
    type = "linear",
    from = {0, widget.height},
    to = {0, 0},
    stops = {{0, beautiful.widget_graph_low}, {0.33, beautiful.widget_graph_low}, {1, beautiful.widget_graph_high}}
  }
  vicious.register(widget, vicious.widgets.cpu, "$1", 3)

  layout:connect_signal("button::press", function()
    awful.util.spawn(os.getenv("HOME") .. "/git/linux-scripts/cpu-toggle-govenor")
  end)
  local cpunaughty = nil
  layout:connect_signal("mouse::enter", function ()
    cpunaughty = naughty.notify({ text = "CPU govenor: " .. getCpuNaughtyText() })
  end)
  layout:connect_signal("mouse::leave", function ()
    naughty.destroy(cpunaughty)
  end)
  function getCpuNaughtyText()
    local fh = io.popen("cpupower frequency-info | sed -n \"9p\" | cut -d \'\"\' -f 2")
    local data = fh:read("*l")
    fh:close()
    return data
  end
  return layout
end
-- }}}

-- {{{ Memory
function mywidgets.memory()
  local widget = wibox.widget {
    width = 24,
    border_color = beautiful.widget_border,
    background_color = gears.color.transparent,
    widget = wibox.widget.graph
  }
  local icon = wibox.widget.imagebox(beautiful.widget_mem)
  local mirror = wibox.container.mirror(widget, { horizontal = true })
  local layout = wibox.layout({
    {
      icon,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    {
      mirror,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal
  })
  widget.color = {
    type = "linear",
    from = {0, widget.height},
    to = {0, 0},
    stops = {{0, beautiful.widget_graph_low}, {0.33, beautiful.widget_graph_low}, {1, beautiful.widget_graph_high}}
  }
  vicious.register(widget, vicious.widgets.mem, "$1", 3)
  return layout
end
-- }}}

-- {{{ HDD
function mywidgets.hdd()
  local widget = wibox.widget {
    width = 24,
    border_color = beautiful.widget_border,
    background_color = gears.color.transparent,
    widget = wibox.widget.graph
  }
  local icon = wibox.widget.imagebox(beautiful.widget_hdd)
  local mirror = wibox.container.mirror(widget, { horizontal = true })
  local layout = wibox.layout({
    {
      icon,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    {
      mirror,
      bg = beautiful.widget_bg,
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal
  })
  widget.color = {
    type = "linear",
    from = {0, widget.height},
    to = {0, 0},
    stops = {{0, beautiful.widget_graph_low}, {0.33, beautiful.widget_graph_low}, {1, beautiful.widget_graph_high}}
  }
  vicious.register(widget, vicious.widgets.dio, "${sda total_kb}", 3)
  return layout
end
-- }}}

-- {{{ Caps Lock
function mywidgets.caps_lock()
  -- initialize
  local handle = io.popen("xset q | grep Caps | cut -d ' ' -f 10")
  local data = handle:read("*l")
  handle:close()
  local box = wibox.widget({
    image  = beautiful.widget_caps,
    background = beautiful.widget_bg,
    visible = data == "on",
    widget = wibox.widget.imagebox
  })

  -- make sure the icon is toggled when caps lock is pressed
  local function toggle_capslock ()
    box.visible = not box.visible
  end
  root.keys(gears.table.join(root.keys(),
    awful.key({ }, "Caps_Lock", toggle_capslock),
    awful.key({"Shift"}, "Caps_Lock", toggle_capslock),
    awful.key({"Control"}, "Caps_Lock", toggle_capslock),
    awful.key({modkey}, "Caps_Lock", toggle_capslock),
    awful.key({altkey}, "Caps_Lock", toggle_capslock)
  ))

  return box
end
-- }}}

-- {{{ Keyboard
function mywidgets.keyboardlayout ()
  local kblayouticon = wibox.widget.imagebox()
  local num_layouts = 2
  layouts = {
    [0] = beautiful.layout_us,
    [1] = beautiful.layout_ch
  }
  local function set_layout_icon (self)
    self.image = layouts[awesome.xkb_get_layout_group()]
  end
  awesome.connect_signal("xkb::group_changed", function () set_layout_icon(kblayouticon) end)
  kblayouticon:connect_signal("button::release", function () awesome.xkb_set_layout_group(awful.util.cycle(num_layouts, awesome.xkb_get_layout_group() + 1)) end)
  set_layout_icon(kblayouticon)
  return {
    kblayouticon,
    bg = beautiful.widget_bg,
    widget = wibox.container.background
  }
end
-- }}}

-- {{{ Clock
function mywidgets.clock()
  local widget = wibox.widget.textclock("%A, %B %e, <span color='"..beautiful.bg_focus.."'>%H:%M</span>", 29)
  calendar2.addCalendarToWidget(widget, "<span color='"..beautiful.bg_focus.."'>%s</span>")
  return {
    widget,
    bg = beautiful.widget_bg,
    widget = wibox.container.background
  }
end
-- }}}

return mywidgets

