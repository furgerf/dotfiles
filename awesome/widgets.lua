-- {{{ Main
local naughty = require("naughty")
local awful = require("awful")
local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")
local calendar2 = require("calendar2")
local gears = require("gears")

local mywidgets = {}

-- TODO: Suspend widgets when they're not needed
-- TODO: Add "powersave" mode for widgets
-- }}}

-- {{{ Utils
local function get_layout_widget(icon, widget, bg_color)
  -- local background = bg_color ~= nil and bg_color or beautiful.widget_bg
  local background = beautiful.widget_bg
  return wibox.layout({
    {
      icon,
      bg = background,
      widget = wibox.container.background
    },
    {
      widget,
      bg = background,
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.horizontal
  })
end
-- }}}

-- {{{ Separators
function mywidgets.separator ()
  return wibox.widget.textbox("<span color='"..beautiful.colors.arch.."'> ⚫ </span>")
  -- return wibox.layout(
  -- {
  --   layout = wibox.layout.fixed.horizontal,
  --   wibox.widget.imagebox(beautiful.widget_arr0),
  --   -- wibox.widget.imagebox(beautiful.widget_arr2)
  -- })
end
function mywidgets.separator2 ()
  return wibox.layout(
  {
    layout = wibox.layout.fixed.horizontal,
    wibox.widget.imagebox(beautiful.widget_arr2)
  })
end
-- }}}

-- {{{ Volume
function mywidgets.volume()
  local icon = wibox.widget.imagebox()
  local widget = wibox.widget.textbox()
  local layout = get_layout_widget(icon, widget, beautiful.colors.dark)
  vicious.register(widget, vicious.widgets.volume, function(widget, args)
    local label = { ["♫"] = "O", ["♩"] = "M" }
    local max_volume = 200
    if label[args[2]] == "M" or args[1] <= 0 then
      icon.image = beautiful.widget_sound_mute
    elseif args[1] <= max_volume / 4 then
      icon.image = beautiful.widget_sound_1_25
    elseif args[1] <= max_volume / 2 then
      icon.image = beautiful.widget_sound_26_50
    elseif args[1] <= max_volume / 4 * 3 then
      icon.image = beautiful.widget_sound_51_75
    else
      icon.image = beautiful.widget_sound_76_100
    end
    return " ".. args[1] .. " "
  end, 1, "Master")
  layout:connect_signal("button::press", function()
    awful.util.spawn("amixer sset Master toggle")
  end)
  return layout
end
-- }}}

-- {{{ Battery
function mywidgets.battery()
  local icon = wibox.widget.imagebox()
  local widget = wibox.widget.textbox()
  local layout = get_layout_widget(icon, widget)
  vicious.register(widget, vicious.widgets.bat, function(widget, args)
    if args[2] <= 5 then
      icon.image = beautiful.widget_battery1
    elseif args[2] <= 10 then
      icon.image = beautiful.widget_battery2
    elseif args[2] <= 20 then
      icon.image = beautiful.widget_battery3
    elseif args[2] <= 30 then
      icon.image = beautiful.widget_battery4
    elseif args[2] <= 40 then
      icon.image = beautiful.widget_battery5
    elseif args[2] <= 50 then
      icon.image = beautiful.widget_battery6
    elseif args[2] <= 60 then
      icon.image = beautiful.widget_battery7
    elseif args[2] <= 70 then
      icon.image = beautiful.widget_battery8
    elseif args[2] <= 80 then
      icon.image = beautiful.widget_battery9
    elseif args[2] <= 90 then
      icon.image = beautiful.widget_battery10
    else
      icon.image = beautiful.widget_battery11
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
  -- Note: currently unused - might need some adjustment if resurrected
  local icon = wibox.widget.imagebox()
  local widget = wibox.widget.textbox()
  local layout = get_layout_widget(icon, widget)
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
        icon.image = beautiful.widget_ethernet
        name = "ethernet"
      else
        icon.image = beautiful.widget_wifinone
      end
    elseif signal <= 20 then
      icon.image = beautiful.widget_wifi1
    elseif signal <= 40 then
      icon.image = beautiful.widget_wifi2
    elseif signal <= 60 then
      icon.image = beautiful.widget_wifi3
    elseif signal <= 80 then
      icon.image = beautiful.widget_wifi4
    else
      icon.image = beautiful.widget_wifi5
    end
    return name
  end, 37, "wlp3s0")
  return layout
end
-- }}}

-- {{{ CPU
function mywidgets.cpu()
  local icon = wibox.widget.imagebox(beautiful.widget_cpu)
  local widget = wibox.widget {
    width = beautiful.widget_width,
    border_color = beautiful.widget_border,
    background_color = gears.color.transparent,
    widget = wibox.widget.graph
  }
  local mirror = wibox.container.mirror(widget, { horizontal = true })
  local layout = get_layout_widget(icon, mirror, beautiful.colors.dark)
  widget.color = {
    type = "linear",
    from = {0, widget.height},
    to = {0, 0},
    stops = {{0, beautiful.widget_graph_low}, {0.33, beautiful.widget_graph_low}, {1, beautiful.widget_graph_high}}
  }
  vicious.register(widget, vicious.widgets.cpu, "$1", 3) -- cpu usage of all cores

  layout:connect_signal("button::press", function()
    awful.spawn(os.getenv("HOME") .. "/git/linux-scripts/cpu-toggle-govenor")
  end)

  local cpu_naughty = nil
  local cpu_data = {}
  local cpu_naughty_title = "CPU usage"

  -- set up widgets that retrieve the CPU data
  function extract_cpu_data(data)
    local govenors = { ["⌁"] = "powersafe", ["⚡"] = "performance" }
    return {
      govenor = govenors[data[5]],
      frequency = string.format("%.2f", data[2])
    }
  end
  for i,v in pairs({"cpu0", "cpu1", "cpu2", "cpu3"}) do
    vicious.register({}, vicious.widgets.cpufreq, function (widget, args)
      cpu_data[v] = extract_cpu_data(args)
      if cpu_naughty ~= nil then
        naughty.replace_text(cpu_naughty, cpu_naughty_title, get_cpu_naughty_text())
      end
    end, 3, v)
  end

  layout:connect_signal("mouse::enter", function ()
    cpu_naughty = naughty.notify({
      title = cpu_naughty_title,
      text = get_cpu_naughty_text(),
      icon = beautiful.widget_cpu,
      timeout = 0
    })
  end)
  layout:connect_signal("mouse::leave", function ()
    naughty.destroy(cpu_naughty)
    cpu_naughty = nil
  end)
  function get_cpu_naughty_text()
    return string.format(
      "\nCPU0:\n" ..
      "    Speed:\t\t%s GHz\n" ..
      "    Govenor:\t%s\n" ..
      "\nCPU1:\n" ..
      "    Speed:\t\t%s GHz\n" ..
      "    Govenor:\t%s\n" ..
      "\nCPU2:\n" ..
      "    Speed:\t\t%s GHz\n" ..
      "    Govenor:\t%s\n" ..
      "\nCPU3:\n" ..
      "    Speed:\t\t%s GHz\n" ..
      "    Govenor:\t%s\t\n",
      cpu_data.cpu0.frequency, cpu_data.cpu0.govenor,
      cpu_data.cpu1.frequency, cpu_data.cpu1.govenor,
      cpu_data.cpu2.frequency, cpu_data.cpu2.govenor,
      cpu_data.cpu3.frequency, cpu_data.cpu3.govenor
      )
  end
  return layout
end
-- }}}

-- {{{ Memory
function mywidgets.memory()
  local icon = wibox.widget.imagebox(beautiful.widget_mem)
  local widget = wibox.widget {
    width = beautiful.widget_width,
    border_color = beautiful.widget_border,
    background_color = gears.color.transparent,
    widget = wibox.widget.graph
  }
  local mirror = wibox.container.mirror(widget, { horizontal = true })
  local layout = get_layout_widget(icon, mirror)
  widget.color = {
    type = "linear",
    from = {0, widget.height},
    to = {0, 0},
    stops = {{0, beautiful.widget_graph_low}, {0.33, beautiful.widget_graph_low}, {1, beautiful.widget_graph_high}}
  }

  local memory_naughty = nil
  local memory_data = {}
  local memory_naughty_title = "Memory usage"
  vicious.register(widget, vicious.widgets.mem, function (widget, args)
    memory_data = {
      percentage = args[1],
      used = args[2] / 1024,
      total = args[3] / 1024,
      free = args[4] / 1024,
      swap_percentage = args[5],
      swap_used = args[6] / 1024,
      swap_total = args[7] / 1024,
      swap_free = args[8] / 1024,
      -- total_usage = math.floor(args[9] / 1000)
    }
    if memory_naughty ~= nil then
      naughty.replace_text(memory_naughty, memory_naughty_title, get_memory_naughty_text())
    end
    return args[1] -- memory usage in %
  end, 3)

  layout:connect_signal("mouse::enter", function ()
    memory_naughty = naughty.notify({
      title = memory_naughty_title,
      text = get_memory_naughty_text(),
      icon = beautiful.widget_mem,
      timeout = 0
    })
  end)
  layout:connect_signal("mouse::leave", function ()
    naughty.destroy(memory_naughty)
    memory_naughty = nil
  end)
  function get_memory_naughty_text()
    return string.format(
      "\nRAM:\t\t%d %%\n" ..
      "    Used:\t%.1f GB\n" ..
      "    Free:\t%.1f GB\n" ..
      "    Total:\t%.1f GB\n" ..
      "\nSwap:\t%d %%\n" ..
      "    Used:\t%.1f GB\n" ..
      "    Free:\t%.1f GB\n" ..
      "    Total:\t%.1f GB\t\n",
      memory_data.percentage, memory_data.used, memory_data.free, memory_data.total,
      memory_data.swap_percentage, memory_data.swap_used, memory_data.swap_free, memory_data.swap_total)
  end
  return layout
end
-- }}}

-- {{{ HDD
function mywidgets.hdd()
  local icon = wibox.widget.imagebox(beautiful.widget_hdd)
  local widget1 = wibox.widget {
    width = beautiful.widget_width,
    height = beautiful.wibox_height / 2,
    border_color = beautiful.widget_border,
    background_color = gears.color.transparent,
    widget = wibox.widget.graph
  }
  local widget2 = wibox.widget {
    width = beautiful.widget_width,
    height = beautiful.wibox_height / 2,
    border_color = beautiful.widget_border,
    background_color = gears.color.transparent,
    widget = wibox.widget.graph
  }
  local widget = wibox.layout({
    {
      wibox.container.mirror(widget1, { horizontal = true }),
      bg = background,
      widget = wibox.container.background
    },
    {
      wibox.container.mirror(widget2, { horizontal = true }),
      bg = background,
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.vertical
  })
  local layout = get_layout_widget(icon, widget, beautiful.colors.dark)
  widget1.color = {
    type = "linear",
    from = {0, widget1.height},
    to = {0, 0},
    stops = {{0, beautiful.widget_graph_low}, {0.33, beautiful.widget_graph_low}, {1, beautiful.widget_graph_high}}
  }
  widget2.color = {
    type = "linear",
    from = {0, widget2.height},
    to = {0, 0},
    stops = {{0, beautiful.widget_graph_low}, {0.33, beautiful.widget_graph_low}, {1, beautiful.widget_graph_high}}
  }

  local disk_naughty = nil
  local disk_data = {}
  local disk_naughty_title = "Disk usage"
  vicious.register(widget1, vicious.widgets.dio, function (widget, args)
    local sda = args["{sda total_mb}"]
    local sdb = args["{sdb total_mb}"]
    widget2:add_value(tonumber(sdb))

    disk_data = {
      sda_read = args["{sda read_mb}"],
      sda_write = args["{sda write_mb}"],
      sda_total = args["{sda total_mb}"],
      sda_iotime = args["{sda iotime_ms}"],
      sdb_read = args["{sdb read_mb}"],
      sdb_write = args["{sdb write_mb}"],
      sdb_total = args["{sdb total_mb}"],
      sdb_iotime = args["{sdb iotime_ms}"],
    }
    if disk_naughty ~= nil then
      naughty.replace_text(disk_naughty, disk_naughty_title, get_disk_naughty_text())
    end
    return sda
  end, 3)

  layout:connect_signal("mouse::enter", function ()
    disk_naughty = naughty.notify({
      title = disk_naughty_title,
      text = get_disk_naughty_text(),
      icon = beautiful.widget_hdd,
      timeout = 0
    })
  end)
  layout:connect_signal("mouse::leave", function ()
    naughty.destroy(disk_naughty)
    disk_naughty = nil
  end)
  function get_disk_naughty_text()
    return string.format(
      "\n/dev/sda:\n" ..
      "    Read:\t%.2f MB\n" ..
      "    Write:\t%.2f MB\n" ..
      "    Total:\t%.2f MB\n" ..
      "    IO wait:\t%.2f ms\n" ..
      "\n/dev/sdb:\n" ..
      "    Read:\t%.2f MB\n" ..
      "    Write:\t%.2f MB\n" ..
      "    Total:\t%.2f MB\n" ..
      "    IO wait:\t%.2f ms\t\n",
      disk_data.sda_read, disk_data.sda_write, disk_data.sda_total, disk_data.sda_iotime,
      disk_data.sdb_read, disk_data.sdb_write, disk_data.sdb_total, disk_data.sdb_iotime)
  end
  return layout
end
-- }}}

-- {{{ Net
function mywidgets.net()
  local icon = wibox.widget.imagebox(beautiful.widget_net)
  local widget = wibox.widget {
    width = beautiful.widget_width,
    border_color = beautiful.widget_border,
    background_color = gears.color.transparent,
    widget = wibox.widget.graph
  }
  local mirror = wibox.container.mirror(widget, { horizontal = true })
  local layout = get_layout_widget(icon, mirror)
  widget.color = {
    type = "linear",
    from = {0, widget.height},
    to = {0, 0},
    stops = {{0, beautiful.widget_graph_low}, {0.33, beautiful.widget_graph_low}, {1, beautiful.widget_graph_high}}
  }

  local net_naughty = nil
  local net_data = {}
  local net_naughty_title = "Network usage"
  vicious.register(widget, vicious.widgets.net, function (widget, args)
    net_data = {
      wifi_rx = args["{wlp3s0 rx_mb}"],
      wifi_tx = args["{wlp3s0 tx_mb}"],
      wifi_down = args["{wlp3s0 down_kb}"],
      wifi_up = args["{wlp3s0 up_kb}"],
      ethernet_rx = args["{enp0s25 rx_mb}"],
      ethernet_tx = args["{enp0s25 tx_mb}"],
      ethernet_down = args["{enp0s25 down_kb}"],
      ethernet_up = args["{enp0s25 up_kb}"],
    }
    if net_naughty ~= nil then
      naughty.replace_text(net_naughty, net_naughty_title, get_net_naughty_text())
    end
    return args["{wlp3s0 down_kb}"]
  end, 3)

  layout:connect_signal("mouse::enter", function ()
    net_naughty = naughty.notify({
      title = net_naughty_title,
      text = get_net_naughty_text(),
      icon = beautiful.widget_net,
      timeout = 0
    })
  end)
  layout:connect_signal("mouse::leave", function ()
    naughty.destroy(net_naughty)
    net_naughty = nil
  end)
  function get_net_naughty_text()
    return string.format(
      "\nWiFi:\n" ..
      "    Up:\t%.1f KB\t(%.1f MB)\n" ..
      "    Down:\t%.1f KB\t(%.1f MB)\n" ..
      "\nEthernet:\n" ..
      "    Up:\t%.1f KB\t(%.1f MB)\n" ..
      "    Down:\t%.1f KB\t(%.1f MB)\n" ..
      "\nTotal:\n" ..
      "    Up:\t%.1f KB\t(%.1f MB)\n" ..
      "    Down:\t%.1f KB\t(%.1f MB)\t\n",
      net_data.wifi_up, net_data.wifi_tx, net_data.wifi_down, net_data.wifi_rx,
      net_data.ethernet_up, net_data.ethernet_tx, net_data.ethernet_down, net_data.ethernet_rx,
      net_data.wifi_up + net_data.ethernet_up, net_data.wifi_tx + net_data.ethernet_tx,
      net_data.wifi_down + net_data.ethernet_down, net_data.wifi_rx + net_data.ethernet_rx)
  end
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
    [0] = beautiful.widget_layout_us,
    [1] = beautiful.widget_layout_ch
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
    bg = beautiful.widget_background,
    widget = wibox.container.background
  }
end
-- }}}

return mywidgets

