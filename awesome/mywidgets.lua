local naughty = require("naughty")
local awful = require("awful")
local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")
local calendar2 = require("calendar2")
-- local io = require("io")
-- local os = require("os")
local gears = require("gears")
-- local root = require("root")

local mywidgets = {}

-- {{{ Separator
function mywidgets.separator ()
  -- return wibox.layout(
  -- {
  --   layout = wibox.layout.fixed.horizontal,
  --   { widget = wibox.widget.imagebox(beautiful.arr0) },
  --   { widget = wibox.widget.imagebox(beautiful.arr9) },
  -- })
  return wibox.widget.textbox(" ⚫ ")
end
-- }}}

-- {{{ Volume
function mywidgets.volume()
  local widget = wibox.widget.textbox()
  local icon = wibox.widget.imagebox()
  local layout = wibox.layout(
  {
    layout = wibox.layout.fixed.horizontal,
    { widget = icon },
    { widget = widget }
  })
  vicious.register(widget, vicious.widgets.volume, function(widget, args)
    local label = { ["♫"] = "O", ["♩"] = "M" }
    if label[args[2]] == "M" then
      icon.image = beautiful.sound_mute
    elseif args[1]>0 and args[1]<=25 then
      icon.image = beautiful.sound_1_25
    elseif args[1]>25 and args[1]<=50 then
      icon.image = beautiful.sound_26_50
    elseif args[1]>50 and args[1]<=75 then
      icon.image = beautiful.sound_51_75
    elseif args[1]>75 then
      icon.image = beautiful.sound_76_100
    else -- sound is 0
      icon.image = beautiful.sound_mute
    end
    return " ".. args[1] .. " "
  end, 0.5, "Master")
  layout:connect_signal("button::press", function()
    awful.util.spawn("amixer sset Master toggle")
  end)
  return layout
end
-- }}}

-- {{{ CPU
function mywidgets.cpu()
  local widget = wibox.widget.graph()
  local icon = wibox.widget.imagebox()
  local layout = wibox.layout(
  {
    layout = wibox.layout.fixed.horizontal,
    { widget = icon },
    { widget = widget }
  })
  icon.image = beautiful.widget_cpu
  widget.forced_width = 24
  widget.color = beautiful.cpu_fg
  widget.background_color = beautiful.cpu_bg
  widget.border_color = beautiful.cpu_border
  vicious.register(widget, vicious.widgets.cpu, "$1")
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
  local widget = wibox.widget.graph()
  local icon = wibox.widget.imagebox()
  local layout = wibox.layout(
  {
    layout = wibox.layout.fixed.horizontal,
    { widget = icon },
    { widget = widget }
  })
  icon.image = beautiful.widget_mem
  widget.forced_width = 24
  widget.color = beautiful.mem_fg
  widget.background_color = beautiful.mem_bg
  widget.border_color = beautiful.mem_border
  vicious.register(widget, vicious.widgets.mem, "$1")
  return layout
end
-- }}}

-- {{{ HDD
function mywidgets.hdd()
  local widget = wibox.widget.graph()
  local icon = wibox.widget.imagebox()
  local layout = wibox.layout(
  {
    layout = wibox.layout.fixed.horizontal,
    { widget = icon },
    { widget = widget }
  })
  icon.image = beautiful.widget_hdd
  widget.forced_width = 24
  widget.color = beautiful.hdd_fg
  widget.background_color = beautiful.hdd_bg
  widget.border_color = beautiful.hdd_border
  vicious.register(widget, vicious.widgets.dio, "${sda write_kb}")
  return layout
end
-- }}}

-- {{{ Battery
function mywidgets.battery()
  local widget = wibox.widget.textbox()
  local icon = wibox.widget.imagebox()
  local layout = wibox.layout(
  {
    layout = wibox.layout.fixed.horizontal,
    { widget = icon },
    { widget = widget }
  })
  vicious.register(widget, vicious.widgets.bat, function(widget, args)
    local fh = io.popen("acpi | cut -d, -f 1,1 | cut -d: -f2,2 | cut -b 2-", "r")
    local direction = fh:read("*l")
    fh.close()
    fh = io.popen("acpi | cut -d, -f 3,3 - | cut -b 2-9", "r")
    local charging_duration = fh:read("*l")
    fh.close()
    local direction_sign = args[1]
    local no_battery = false
    if direction == "Discharging" then
      chargedesc = " (" .. charging_duration .. " rem)"
    elseif direction == "Charging" and charging_duration ~= "charging" then
      chargedesc = " (" .. charging_duration .. " rem)"
    elseif direction == "Unknown" or (direction == "Charging" and charging_duration == "charging") then
      chargedesc = ""
    elseif direction == "Full" then
      chargedesc = direction_sign
      direction_sign = ""
    else
      chargedesc = "No Battery"
      no_battery = true
    end

    local batterypercentage
    if no_battery then
      batterypercentage = direction_sign .. chargedesc
    else
      batterypercentage = args[2] .. direction_sign .. "%" .. chargedesc
    end
    if args[2]<=5 then
      icon:set_image(beautiful.battery1)
    elseif args[2]>5 and args[2]<=10 then
      icon:set_image(beautiful.battery2)
    elseif args[2]>10 and args[2]<=20 then
      icon:set_image(beautiful.battery3)
    elseif args[2]>20 and args[2]<=30 then
      icon:set_image(beautiful.battery4)
    elseif args[2]>30 and args[2]<=40 then
      icon:set_image(beautiful.battery5)
    elseif args[2]>40 and args[2]<=50 then
      icon:set_image(beautiful.battery6)
    elseif args[2]>50 and args[2]<=60 then
      icon:set_image(beautiful.battery7)
    elseif args[2]>60 and args[2]<=70 then
      icon:set_image(beautiful.battery8)
    elseif args[2]>70 and args[2]<=80 then
      icon:set_image(beautiful.battery9)
    elseif args[2]>80 and args[2]<=90 then
      icon:set_image(beautiful.battery10)
    else
      icon:set_image(beautiful.battery11)
    end
    icon:set_resize(false)
    return batterypercentage
  end, 30, "BAT0")
  return layout
end
-- }}}

-- {{{ Wifi
function mywidgets.wifi()
  local widget = wibox.widget.textbox()
  local icon = wibox.widget.imagebox()
  local layout = wibox.layout(
  {
    layout = wibox.layout.fixed.horizontal,
    { widget = icon },
    { widget = widget}
  })
  vicious.register(widget, vicious.widgets.wifi,
    function(widget, args)
      local signal = args['{link}']
      local name = "" .. args['{ssid}']
      if signal > 0 and signal <=20 then
        icon:set_image(beautiful.wifi1)
      elseif signal > 20 and signal <=40 then
        icon:set_image(beautiful.wifi2)
      elseif signal > 40 and signal <=60 then
        icon:set_image(beautiful.wifi3)
      elseif signal > 60 and signal <=80 then
        icon:set_image(beautiful.wifi4)
      elseif signal > 80 and signal <=100 then
        icon:set_image(beautiful.wifi5)
      else
       local handle = io.popen("wget -q --tries=1 --timeout=1 --spider http://google.com &> /dev/null ; echo $?")
       local inet = handle:read("*a")
       handle:close()
      if inet:sub(1, #inet - 1) == "0" then
        icon:set_image(beautiful.ethernet)
        name = "ethernet"
      else
        icon:set_image(beautiful.wifinone)
      end
    end
    -- icon:set_resize(false)
    return name
  end, 30, "wlp3s0")
  return layout
end

-- {{{ Clock
function mywidgets.clock()
  local mytextclock = wibox.widget.textclock("%A, %B %e, <span color='#1793D1'>%H:%M</span>", 29)
  calendar2.addCalendarToWidget(mytextclock, "<span color='#1793D1'>%s</span>") -- TODO port
  local tclockwrapper = wibox.container.background()
  tclockwrapper:set_widget(mytextclock)
  return mytextclock
end
-- }}}

-- {{{ Caps Lock
function mywidgets.caps_lock()
  local box = wibox.widget.textbox("CAPS")
  local handle = io.popen("xset q | grep Caps | cut -d ' ' -f 10")
  local data = handle:read("*l")
  handle:close()
  box.visible = data == "on"

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

function mywidgets.keyboardlayout ()
  -- TODO: Add switching with mousepress and displaying options on hover...
  local kblayouticon = wibox.widget.imagebox()
  local num_layouts = 2
  layouts = {
    [0] = "us",
    [1] = "ch"
  }

  local function set_layout_icon (self)
    local layout = layouts[awesome.xkb_get_layout_group()]
    local image = "/usr/share/awesome/themes/archdove/icons/" .. layout .. ".png"
    self.image = image
  end

  -- awesome.connect_signal("xkb::map_changed", function () set_layout_icon() end)
  awesome.connect_signal("xkb::group_changed", function () set_layout_icon(kblayouticon) end)
  kblayouticon:connect_signal("button::release", function () awesome.xkb_set_layout_group(util.cycle(num_layouts, awesome.xkb_get_layout_group())) end)

  set_layout_icon(kblayouticon)

  return kblayouticon
end
-- }}}

return mywidgets

