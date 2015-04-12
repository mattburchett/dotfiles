-- -- NOVA Awesome Setup -- --
-- -- Created by Matt Burchett -- --
-- -- Fri, 2010/06/10 -- --

-- -- LIBRARY REQUIREMENTS -- --
-- -- THERE MAY BE LIBRARIES COMMENTED OUT THAT ARE CURRENTLY OUT OF USE -- --
awful = require("awful") 			-- Standard Awesome Library
awful.autofocus = require("awful.autofocus")		-- Standard Awesome Library
awful.rules = require("awful.rules")			-- Standard Awesome Library
local beautiful = require("beautiful")			-- Theme Handling Library
local naughty = require("naughty")			-- Notification Library
local gears = require("gears") --Gears Library
local vicious = require("vicious")			-- Dynamic Widget Library
local cal = require("lib/cal")			-- Calendar Library / Widget
local wibox = require("wibox")
local xdg_menu = require("lib/archmenu")
--local APW = require("lib/apw/widget")
local alttab = require("lib/alttab")
--require("scratch")                  -- ScratchPad Library / Widget
-- Standard awesome library
require("awful.autofocus")
local menubar = require("menubar")


-- -- APP AUTOSTART -- --
awful.util.spawn_with_shell("/home/matthew/ownCloud/computer/Scripts/dufresne-awesome.sh")
awful.util.spawn_with_shell("owncloud")
awful.util.spawn_with_shell("guake")
-- awful.util.spawn_with_shell("/home/matthew/.config/awesome/scripts/x11vnc")
--awful.util.spawn_with_shell("/home/burchettm/.config/awesome/scripts/synergys")
-- awful.util.spawn_with_shell("/usr/bin/numlockx")
awful.util.spawn_with_shell("xscreensaver -nosplash")
awful.util.spawn_with_shell("wmname LG3D")

-- DISABLE BUSY CURSOR WITH AWFUL.UTIL.SPAWN --
-- disable startup-notification globally
local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
  oldspawn(s, false)
end

-- -- VARIABLE DEFINITIONS -- --

-- -- SPECIFY THEME LOCATION (CONSISTS OF COLOURS, ICONS, AND WALLPAPERS) -- --
beautiful.init("/home/matthew/.config/awesome/themes/awesomeo/theme.lua")
for s = 1, screen.count() do
   gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end

-- CHANGE NAUGHTY FONT TO DIFFER FROM BANKGOTHIC LT BT --
naughty.config.defaults.font = "Sans 10"

-- -- SPECIFY DEFAULT APPLICATIONS -- --
terminal = "/usr/bin/mate-terminal --hide-menubar"			-- Specify Default Terminal
--terminal = "urxvt" -- Specify Default Terminal
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4" -- Set ModKey to Windows Key, use xmodmap to change

-- -- LAYOUTS -- --
layouts =
{
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
    awful.layout.suit.magnifier
}

-- -- TAGS --  --
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "WORK", "TERM", "WWW", "CHAT", "MEDIA", "SOCIAL" }, s,
 { layouts[1], layouts[2], layouts[1],          -- Tags: 1, 2, 3
   layouts[1], layouts[2], layouts[2],          --       4, 5 ,6
   layouts[1], layouts[1], layouts[1]           --       7, 8, 9
 })
end

-- -- MENU -- --

myawesomemenu = {
   { "Manual", terminal .. " -e man awesome" },
   { "Edit Config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "Restart", awesome.restart },
   { "Quit", awesome.quit }
}


mymainmenu = awful.menu({ items = { { "Firefox", "firefox" },
                                    { "Pidgin", "pidgin" },
                                    { "Skype", "skype" },
                                    { "NCMPC++", "terminal --geometry 200x60 --hide-menubar -e ncmpcpp" },
                                    { "Terminal", terminal },
                                    { "Thunderbird", "thunderbird" },
                                    { " ", " " },
                                    { "Applications" , xdgmenu },
                                    { " ", " " },
                                    { "Awesome", myawesomemenu, beautiful.awesome_icon }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.arch_icon,
                                     menu = mymainmenu })

-- -- WIBOXES -- --

mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    -- awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.

    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
-- WIDGETS --

-- TEXT CLOCK --
mytextclock = awful.widget.textclock("%H:%M:%S ", 1)

-- DATE -- 
mytextdate = awful.widget.textclock("%a, %Y/%m/%d", 1)

-- CALENDAR --
--cal.register(mytextdate, "<b><u>%s</u></b>") -- Added Calendar tooltip to date, bolded day & underlined day

-- SYSTRAY --
mysystray = wibox.widget.systray()

-- SPACER --
myspacer = wibox.widget.textbox()
myspacer:set_text(" | ")

-- TAG LIST -- 
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

-- TASKLIST -- 
    -- mytasklist[s] = awful.widget.tasklist(function(c)
    --                                           return awful.widget.tasklist.label.currenttags(c, s)
    --                                       end, mytasklist.buttons)

mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)



-- VOLUME --
volumewidget = wibox.widget.textbox()
vicious.register( volumewidget, vicious.widgets.volume, "$2 $1%", 2, "Master")
volumewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    awful.button({ }, 3, function () awful.util.spawn("urxvt -e alsamixer", true) end),
    awful.button({ }, 4, function () awful.util.spawn("amixer -q sset Master 5%+", false) end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -q sset Master 5%-", false) end)
))

   -- Load the widget.
--   APWTimer = timer({ timeout = 0.5 }) -- set update interval in s
--   APWTimer:connect_signal("timeout", APW.Update)
--   APWTimer:start()

   
-- WEATHER --

weatherwidget = wibox.widget.textbox()
   vicious.register( weatherwidget, vicious.widgets.weather, '${tempf}°F',300, 'KSTL')


-- TOP BOX --
    mywibox[s] = awful.wibox({ position = "top", screen = s, bg = "#000000" })
    -- Add widgets to the wibox - order matters
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    -- left_layout:add(mytasklist[s])

    local right_layout = wibox.layout.fixed.horizontal()




    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(myspacer)
    right_layout:add(volumewidget)
    right_layout:add(myspacer)
    right_layout:add(weatherwidget)
    right_layout:add(myspacer)
    right_layout:add(mytextdate)
    right_layout:add(myspacer)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])



    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)
    layout:set_middle(mytasklist[s])

    -- local layout2 = wibox.layout.align.horizontal()
    -- layout2:set_middle(mytasklist[s])

    mywibox[s]:set_widget(layout)
    

-- BOTTOM BOX -- 

-- BLANK SPACER --
blankspacer = wibox.widget.textbox()
blankspacer:set_text(" ")

-- OS --
sysinfo = wibox.widget.textbox()
vicious.register(sysinfo, vicious.widgets.os, 'OS: Arch<span color = "'..beautiful.archblue..'">Linux</span> $2')

-- UPTIME --
uptime = wibox.widget.textbox()
vicious.register(uptime, vicious.widgets.uptime, 'UP:<span color = "'..beautiful.dgreen..'"> $1D $2H $3M</span>')

-- CPU USAGE --
cpu = wibox.widget.textbox()
vicious.register(cpu, vicious.widgets.cpu, 'CPU: <span color = "orange">$1%</span>')

-- MEMORY --
memory = wibox.widget.textbox()
vicious.register(memory, vicious.widgets.mem, 'RAM:<span color = "cyan"> $1%</span> | SWAP:<span color = "green"> $5%</span>')

-- FILESYSTEM --
fileroot = wibox.widget.textbox()
vicious.register(fileroot, vicious.widgets.fs, 'Root:<span color = "'..beautiful.orange..'"> ${/ used_gb} GB</span> / <span color = "green">${/ size_gb} GB</span>', 30)

-- filehome = wibox.widget.textbox()
-- vicious.register(filehome, vicious.widgets.fs, 'Home:<span color = "'..beautiful.orange..'"> ${/home used_gb} GB</span> / <span color = "green">${/home size_gb} GB</span>', 30)

-- filetera = wibox.widget.textbox()
-- vicious.register(filetera, vicious.widgets.fs, 'Terabyte: <span color = "'..beautiful.orange..'">${/media/Terabyte used_gb} GB</span> / <span color = "green">${/media/Terabyte size_gb} GB</span>', 30)

-- NET --
net = wibox.widget.textbox()
vicious.register(net, vicious.widgets.net, 'D: <span color = "cyan">${eth0 down_kb} KB</span> / U: <span color = "#01A40D">${eth0 up_kb} KB</span> | D: <span color = "cyan">${wlan0 down_kb} KB</span> / U: <span color = "#01A40D">${wlan0 up_kb} KB</span>')

-- -- MPD --

-- mpd = wibox.widget.textbox()
-- mpd.width, mpd.align = 750, "right"
-- vicious.register(mpd, vicious.widgets.mpd,
-- function (widget, args)
-- if args ["{state}"] == "Stop" then return 'MPD: <span color = "'..beautiful.orange..'">Stopped</span>'
-- else return 'MPD: <span color = "cyan"> '..
-- args ["{Artist}"]..' - '.. args["{Title}"]..'</span>'
-- end
-- end)

-- WIBOX --

infobox = {}
infobox[s] = awful.wibox({ position = "bottom", screen = s, bg = "#000000" })

-- Add widgets to the wibox - order matters
local left_info_layout = wibox.layout.fixed.horizontal()
left_info_layout:add(sysinfo)
left_info_layout:add(myspacer)
left_info_layout:add(uptime)
left_info_layout:add(myspacer)
left_info_layout:add(cpu)
left_info_layout:add(myspacer)
left_info_layout:add(memory)
left_info_layout:add(myspacer)
left_info_layout:add(fileroot)
left_info_layout:add(myspacer)
left_info_layout:add(net)



local right_info_layout = wibox.layout.fixed.horizontal()

-- right_info_layout:add(mylayoutbox[s])
-- right_info_layout:add(mytextclock)

    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_info_layout)
    layout:set_right(right_info_layout)

    local layout2 = wibox.layout.align.horizontal()
    layout2:set_middle(mytasklist[s])

    infobox[s]:set_widget(layout)



end
-- -- BINDINGS -- --

-- MOUSE -- 
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- KEYBOARD --
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

   -- Configure the hotkeys.
   -- awful.key({ }, "XF86AudioRaiseVolume",  APW.Up),
   -- awful.key({ }, "XF86AudioLowerVolume",  APW.Down),
   -- awful.key({ }, "XF86AudioMute",         APW.ToggleMute),

      awful.key({ "Mod1",           }, "Tab",                                                      
       function ()                                                                              
          alttab.switch(1, "Alt_L", "Tab", "ISO_Left_Tab")                                             
       end                                                                                      
   ),                                                                                           
                                                                                                
   awful.key({ "Mod1", "Shift"   }, "Tab",                                                      
       function ()                                                                              
          alttab.switch(-1, "Alt_L", "Tab", "ISO_Left_Tab")                                            
       end                                                                                      
   ),


    -- User Added Keybindings
    awful.key({modkey,            }, "F1",     function () awful.screen.focus(1) end),
    awful.key({modkey,            }, "F2",     function () awful.screen.focus(2) end),
    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Master 5%+") end),
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Master 5%-") end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("amixer set Master toggle") end), 
    awful.key({}, "Print", function () awful.util.spawn("mate-screenshot") end), 
    awful.key({}, "Sys_Req", function () awful.util.spawn("mate-screenshot -w") end),
    awful.key({modkey }, "p", function() awful.util.spawn( "dmenu_run" ) end),
    awful.key({modkey }, "e", function() awful.util.spawn( "caja --no-desktop" ) end),
    awful.key({ modkey }, "F12", function () scratch.drop( terminal, "top") end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.util.spawn("xscreensaver-command -lock")    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- -- RULES -- --

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { maximized_vertical = true, maximized_horizontal = true  } },
    { rule = { class = "Firefox" }, properties = { tag = tags[2][3], maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "Chrome" }, properties = { tag = tags[1][3], maximized_vertical = true, maximized_horizontal = true } },
    { rule = { class = "Pidgin" }, properties = { tag = tags[1][4] } },
    { rule = { class = "Skype" }, properties = { tag = tags[1][4]  } },
    { rule = { class = "Sonata" }, properties = { tag = tags[1][5] } },
    { rule = { class = "Turpial" }, properties = { tag = tags[1][6] } },
    { rule = { class = "NCMPC++" }, properties = { tag = tags[1][5] } },
    { rule = { class = "ts3client_linux_amd64" }, properties = { tag = tags[1][4] } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}

-- -- SIGNALS -- --

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

