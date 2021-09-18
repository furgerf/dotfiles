-- {{{ Main
local naughty = require("naughty")
local awful = require("awful")
local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")
local calendar2 = require("calendar2")
local gears = require("gears")

local mywidgets = {}

-- TODO: Add "powersave" mode for widgets
-- TODO: Check out new widgets https://vicious.readthedocs.io/en/latest/widgets.html
-- }}}

-- {{{ Utils
local function get_layout_widget(icon, widget)
  return wibox.layout({
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
end

local function get_graph_widget(max_value)
  return wibox.widget {
    width = beautiful.widget_width,
    border_color = beautiful.widget_border,
    background_color = gears.color.transparent,
    widget = wibox.widget.graph,
    max_value = max_value
  }
end
-- }}}

-- {{{ Separators
function mywidgets.separator ()
  return wibox.widget.textbox(string.format("<span color='%s'> ⚫ </span>", beautiful.colors.arch))
end
-- }}}

-- {{{ Volume
function mywidgets.volume()
  local icon = wibox.widget.imagebox()
  local widget = wibox.widget.textbox()
  local layout = get_layout_widget(icon, widget)
  vicious.register(widget, vicious.widgets.volume, function(widget, args)
    local label = { ["♫"] = "O", ["♩"] = "M", ["🔉"] = "0", ["🔈"] = "M" }
    local max_volume = 100
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
    awful.util.spawn(os.getenv("HOME") .. "/git/linux-scripts/toggle-sink")
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
    local time_left = args[3]
    if args[3] == "N/A" then
      local handle = io.popen(os.getenv("HOME") .. "/git/linux-scripts/discharge")
      time_left = handle:read("*a"):gsub("\n", "")
      handle:close()
    end
    if time_left ~= "" then
      time_left = " (" .. time_left .. ")"
    end
    return args[2] .. "% " .. args[1] .. time_left
  end, 31, "BAT0")
  return layout
end
-- }}}

-- {{{ Wifi
function mywidgets.wifi()
  -- Note: currently unused - might need some adjustment if resurrected; remove popen
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
    return function () return "foobar" end
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
  local layout = get_layout_widget(icon, mirror)
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
  local cpus = {}
  local cpu_data = {}
  local cpu_naughty_title = "CPU usage"

  -- set up widgets that retrieve the CPU data
  function extract_cpu_data(data)
    local govenors = { ["⌁"] = "powersafe", ["⚡"] = "performance" }
    return {
      govenor = govenors[data[5]],
      frequency = type(data[2]) == "int" and string.format("%.2f", data[2]) or data[2]
    }
  end
  awful.spawn.easy_async_with_shell("cat /proc/cpuinfo | grep processor | wc -l", function(count)
    for i = 0, count-1 do
      cpu = "cpu" .. i
      cpus[#cpus+1] = cpu
      vicious.register({}, vicious.widgets.cpufreq, function (widget, args)
        cpu_data[cpu] = extract_cpu_data(args)
        if cpu_naughty ~= nil then
          naughty.replace_text(cpu_naughty, cpu_naughty_title, get_cpu_naughty_text())
        end
      end, 3, cpu)
    end
  end)

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
    local result = ""
    for _, cpu in pairs(cpus) do
      local data = cpu_data[cpu]
      result = result .. string.format(
        "\n%s:\t\t\t\t\t\n" ..
        "    Speed:\t\t%.2f GHz\n" ..
        "    Govenor:\t%s\n",
      cpu, data.frequency, data.govenor)
    end
    return result
  end
  return layout
end
-- }}}

-- {{{ Memory
function mywidgets.memory()
  local icon = wibox.widget.imagebox(beautiful.widget_mem)
  local widget = get_graph_widget()
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
    local text = string.format(
      "\nRAM:\t\t%d %%\n" ..
      "    Used:\t%.1f GB\n" ..
      "    Free:\t%.1f GB\n" ..
      "    Total:\t%.1f GB\t\n",
      memory_data.percentage, memory_data.used, memory_data.free, memory_data.total)

    if memory_data.swap_percentage == memory_data.swap_percentage then
      -- swap_percentage isn't NaN
      text = text .. string.format(
      "\nSwap:\t%d %%\n" ..
      "    Used:\t%.1f GB\n" ..
      "    Free:\t%.1f GB\n" ..
      "    Total:\t%.1f GB\n",
      memory_data.swap_percentage, memory_data.swap_used, memory_data.swap_free, memory_data.swap_total)
    else
      -- swap_percentage is NaN, presumably there's no swap at all
      text = text .. "\n(no swap)\n"
    end
    return text
  end
  return layout
end
-- }}}

-- {{{ HDD
function mywidgets.hdd()
  local icon = wibox.widget.imagebox(beautiful.widget_hdd)
  local widget = get_graph_widget()
  local mirror = wibox.container.mirror(widget, { horizontal = true })
  local layout = get_layout_widget(icon, mirror)
  widget.color = {
    type = "linear",
    from = {0, widget.height},
    to = {0, 0},
    stops = {{0, beautiful.widget_graph_low}, {0.33, beautiful.widget_graph_low}, {1, beautiful.widget_graph_high}}
  }

  local disk_naughty = nil
  local disks = {}
  local disk_data = {}
  local disk_naughty_title = "Disk usage"
  awful.spawn.easy_async_with_shell("lsblk -o NAME,TYPE | grep disk | cut -d' ' -f1", function(output)
    for disk in string.gmatch(output, "([^\n]+)") do
      disks[#disks+1] = disk
    end
  end)
  vicious.register(widget, vicious.widgets.dio, function (widget, args)
    local first_disk_total_mb = nil
    for _, disk in pairs(disks) do
      if first_disk_total_mb == nil then
        first_disk_total_mb = args[string.format("{%s total_mb}", disk)]
      end

      disk_data[disk] = {
        read = args[string.format("{%s read_mb}", disk)],
        write = args[string.format("{%s write_mb}", disk)],
        total = args[string.format("{%s total_mb}", disk)],
        iotime = args[string.format("{%s iotime_ms}", disk)]
      }
    end
    if disk_naughty ~= nil then
      naughty.replace_text(disk_naughty, disk_naughty_title, get_disk_naughty_text())
    end
    return first_disk_total_mb
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
    local result = ""
    for _, disk in pairs(disks) do
      local data = disk_data[disk]
      if data == nil then
        naughty.notify({text = "No data for disk '" .. disk .. "' available"})
      else
        result = result .. string.format(
          "\n/dev/%s:\n" ..
          "    Read:\t%.2f MB\n" ..
          "    Write:\t%.2f MB\n" ..
          "    Total:\t%.2f MB\n" ..
          "    IO wait:\t%.2f ms\t\n",
        disk, data.read, data.write, data.total, data.iotime)
      end
    end
    return result
  end
  return layout
end
-- }}}

-- {{{ Net
function mywidgets.net()
  local icon = wibox.widget.imagebox(beautiful.widget_net)
  local widget = get_graph_widget(10) -- max 1 Mbps
  local mirror = wibox.container.mirror(widget, { horizontal = true })
  local layout = get_layout_widget(icon, mirror)
  widget.color = {
    type = "linear",
    from = {0, widget.height},
    to = {0, 0},
    stops = {{0, beautiful.widget_graph_low}, {0.33, beautiful.widget_graph_low}, {1, beautiful.widget_graph_high}}
  }

  local net_naughty = nil
  local net_interfaces = {}
  local net_data = {}
  local net_naughty_title = "Network usage"
  -- grep for qlen to (try and) skip docker interfaces
  awful.spawn.easy_async_with_shell("ip link show | grep UP | grep qlen | grep -v LOOPBACK | cut -d: -f2 | tr -d ' '", function(output)
    for net_interface in string.gmatch(output, "([^\n]+)") do
      net_interfaces[#net_interfaces+1] = net_interface
    end
  end)
  vicious.register(widget, vicious.widgets.net, function (widget, args)
    net_data.total = {
      rx_mb = 0,
      tx_mb = 0,
      down_kb = 0,
      up_kb = 0
    }
    for _, net_interface in pairs(net_interfaces) do
      if args[string.format("{%s rx_mb}", net_interface)] ~= nil then
        net_data[net_interface] = {
          rx_mb = args[string.format("{%s rx_mb}", net_interface)],
          tx_mb = args[string.format("{%s tx_mb}", net_interface)],
          down_kb = args[string.format("{%s down_kb}", net_interface)],
          up_kb = args[string.format("{%s up_kb}", net_interface)]
        }
        net_data.total.rx_mb = net_data.total.rx_mb + net_data[net_interface].rx_mb
        net_data.total.tx_mb = net_data.total.tx_mb + net_data[net_interface].tx_mb
        net_data.total.down_kb = net_data.total.down_kb + net_data[net_interface].down_kb
        net_data.total.up_kb = net_data.total.up_kb + net_data[net_interface].up_kb
      end
    end

    if net_naughty ~= nil then
      naughty.replace_text(net_naughty, net_naughty_title, get_net_naughty_text())
    end

    return net_data.total.down_kb
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
    local result = ""
    local function add_device_info(device, device_data)
      result = result .. string.format(
        "\n%s:\n" ..
        "    Up:\t%.1f KB\t(%.1f GB)\n" ..
        "    Down:\t%.1f KB\t(%.1f GB)\t\n",
        device, device_data.up_kb, device_data.tx_mb / 1024, device_data.down_kb, device_data.rx_mb / 1024)
    end
    for device, device_data in pairs(net_data) do
      if device ~= "total" then
        add_device_info(device, device_data)
      end
    end
    add_device_info("total", net_data.total)
    return result
  end
  return layout
end
-- }}}

-- {{{ Caps Lock
function mywidgets.caps_lock()
  -- initialize - NOTE: async methods called from another function always return the same xset data...
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

