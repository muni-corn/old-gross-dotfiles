--[[
   ___       ___       ___       ___       ___       ___       ___
  /\  \     /\__\     /\  \     /\  \     /\  \     /\__\     /\  \
 /::\  \   /:/\__\   /::\  \   /::\  \   /::\  \   /::L_L_   /::\  \
/::\:\__\ /:/:/\__\ /::\:\__\ /\:\:\__\ /:/\:\__\ /:/L:\__\ /::\:\__\
\/\::/  / \::/:/  / \:\:\/  / \:\:\/__/ \:\/:/  / \/_/:/  / \:\:\/  /
  /:/  /   \::/  /   \:\/  /   \::/  /   \::/  /    /:/  /   \:\/  /
  \/__/     \/__/     \/__/     \/__/     \/__/     \/__/     \/__/

-- >> The file that binds everything together.
--]]
colors = require("colors")
local awful = require("awful")

-- Start apps
awful.spawn.with_shell(os.getenv("HOME") .. "/.config/wpg/wp_init.sh")
awful.spawn.with_shell(os.getenv("HOME") .. "/.config/awesome/autostart.sh")

local theme = "amarena"
local decoration_theme = "ephemeral"
local bar_theme = "amarena"
local notification_theme = "amarena"
local sidebar_theme = "amarena"
local dashboard_theme = "amarena"
local exit_screen_theme = "ephemeral"
user = {
    -- >> Default applications <<
    -- Check apps.lua for more
    terminal = "kitty -1",
    floating_terminal = "kitty -1",
    browser = "firefox",
    file_manager = "kitty -1 --class files -e ranger",
    editor = "kitty -1 --class editor -e nvim",
    email_client = "thunderbird",
    music_client = "spotify",

    -- >> Web Search <<
    web_search_cmd = "xdg-open https://duckduckgo.com/?q=",
    -- web_search_cmd = "xdg-open https://www.google.com/search?q="

    -- >> User profile <<
    profile_picture = os.getenv("HOME").."/.config/awesome/profile.png",

    -- Directories with fallback values
    dirs = {
        downloads = os.getenv("XDG_DOWNLOAD_DIR") or "~/Downloads",
        documents = os.getenv("XDG_DOCUMENTS_DIR") or "~/Documents",
        music = os.getenv("XDG_MUSIC_DIR") or "~/Music",
        pictures = os.getenv("XDG_PICTURES_DIR") or "~/Pictures",
        videos = os.getenv("XDG_VIDEOS_DIR") or "~/Videos",
        -- Make sure the directory exists so that your screenshots
        -- are not lost
        screenshots = os.getenv("XDG_SCREENSHOTS_DIR") or "~/Pictures/Screenshots",
    },

    -- >> Sidebar <<
    sidebar = {
        hide_on_mouse_leave = true,
        show_on_mouse_screen_edge = true,
    },

    -- >> Battery <<
    -- You will receive notifications when your battery reaches these
    -- levels.
    battery_threshold_low = 20,
    battery_threshold_critical = 5,

    -- >> Weather <<
    -- Get your key and find your city id at
    -- https://openweathermap.org/
    -- (You will need to make an account!)
    openweathermap_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    openweathermap_city_id = "yyyyyy",
    -- > Use "metric" for Celcius, "imperial" for Fahrenheit
    weather_units = "metric",

    -- >> Coronavirus <<
    -- Country to check for corona statistics
    -- Uses the https://corona-stats.online API
    coronavirus_country = "germany",
}
-- ===================================================================


-- Jit
--pcall(function() jit.on() end)

-- Initialization
-- ===================================================================

-- Theme handling library
local beautiful = require("beautiful")
local xrdb = beautiful.xresources.get_current_theme()

-- Make dpi function global
dpi = beautiful.xresources.apply_dpi

-- Load AwesomeWM libraries
local gears = require("gears")
require("awful.autofocus")
-- Default notification library
local naughty = require("naughty")

-- Load theme
local theme_dir = os.getenv("HOME") .. "/.config/awesome/theme/"
beautiful.init(theme_dir .. "theme.lua")

-- Error handling
-- ===================================================================
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-- Features
-- ===================================================================

-- Keybinds and mousebinds
local keys = require("keys")

-- Load notification daemons and notification theme
local notifications = require("notifications")
notifications.init()

-- Load window decoration theme and custom decorations
local decorations = require("decorations")
decorations.init()

-- Load helper functions
local helpers = require("helpers")

-- >> Elements - Desktop components
-- Statusbar(s)
require("elemental.bar")

-- Exit screen
require("elemental.exit")

-- Sidebar
require("elemental.sidebar")

-- Dashboard (previously called: Start screen)
require("elemental.dashboard")

-- App drawer
require("elemental.app_drawer")
-- Window switcher
require("elemental.window_switcher")

-- >> Daemons
-- Most widgets that display system/external info depend on evil.
-- Make sure to initialize it last in order to allow all widgets to connect to
-- their needed evil signals.
require("evil")
-- ===================================================================
-- ===================================================================

-- Get screen geometry
-- I am using a single screen setup and I assume that screen geometry will not
-- change during the session.
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Layouts
-- ===================================================================
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
    -- awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
})

-- Wallpaper
-- ===================================================================
local function set_wallpaper(s)
    -- Wallpaper
    awful.spawn.easy_async_with_shell('wpg -c', function(stdout, _, __, ___) 
        local wallpaper = os.getenv("HOME") .. "/Pictures/Wallpapers/Photos/" .. (stdout:match "^%s*(.-)%s*$")
        print(wallpaper)

        gears.wallpaper.maximized(wallpaper, s, true)
    end)
end

-- Set wallpaper
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Focus on hover
client.connect_signal("mouse::enter", function(c)                                                                                                                           
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c 
    end 
end)

-- nice rounded corners
client.connect_signal("manage", function (c)
    c.shape = gears.shape.rounded_rect
end)

-- Tags
-- ===================================================================
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    local l = awful.layout.suit -- Alias to save time :)
    -- Tag layouts
    local layouts = {
        l.max,
        l.max,
        l.max,
        l.max,
        l.tile,
        l.max,
        l.max,
        l.max,
        l.tile,
        l.max
    }

    -- Tag names
    local tagnames = beautiful.tagnames or { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }
    -- Create all tags at once (without seperate configuration for each tag)
    awful.tag(tagnames, s, layouts)

    -- Create tags with seperate configuration for each tag
    -- awful.tag.add(tagnames[1], {
    --     layout = layouts[1],
    --     screen = s,
    --     master_width_factor = 0.6,
    --     selected = true,
    -- })
    -- ...
end)

-- Determines how floating clients should be placed
local floating_client_placement = function(c)
    -- If the layout is floating or there are no other visible
    -- clients, center client
    if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating or #mouse.screen.clients == 1 then
        return awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
    end

    -- Else use this placement
    local p = awful.placement.no_overlap + awful.placement.no_offscreen
    return p(c, {honor_padding = true, honor_workarea=true, margins = beautiful.useless_gap * 2})
end

local centered_client_placement = function(c)
    return gears.timer.delayed_call(function ()
        awful.placement.centered(c, {honor_padding = true, honor_workarea=true})
    end)
end

-- Rules
-- ===================================================================
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    {
        -- All clients will match this rule.
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = keys.clientbuttons,
            -- screen = awful.screen.preferred,
            screen = awful.screen.focused,
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true,
            maximized = false,
            titlebars_enabled = beautiful.titlebars_enabled,
            maximized_horizontal = false,
            maximized_vertical = false,
            placement = floating_client_placement
        },
    },

    -- Floating clients
    {
        rule_any = {
            instance = {
                "copyq",  -- Includes session name in class.
                "floating_terminal",
                "riotclientux.exe",
                "leagueclientux.exe",
                "Devtools", -- Firefox devtools
            },
            class = {
                "Gpick",
                "Lxappearance",
                "Nm-connection-editor",
                "File-roller",
                "fst",
                "Nvidia-settings",
            },
            name = {
                "MetaMask Notification",
            },
            role = {
                "AlarmWindow",
                "pop-up",
                "GtkFileChooserDialog",
                "conversation",
            },
            type = {
                "dialog",
            }
        },
        properties = { floating = true }
    },

    -- TODO why does Chromium always start up floating in AwesomeWM?
    -- Temporary fix until I figure it out
    {
        rule_any = {
            class = {
                "Chromium-browser",
                "Chromium",
            }
        },
        properties = { floating = false }
    },

    -- Fullscreen clients
    {
        rule_any = {
            class = {
                "lt-love",
                "portal2_linux",
                "csgo_linux64",
                "EtG.x86_64",
                "factorio",
                "dota2",
                "Terraria.bin.x86",
                "dontstarve_steam",
            },
            instance = {
                "synthetik.exe",
            },
        },
        properties = { fullscreen = true }
    },

    -- -- Unfocusable clients (unless clicked with the mouse)
    -- -- If you want to prevent focusing even when clicking them, you need to
    -- -- modify the left click client mouse bind in keys.lua
    -- {
    --     rule_any = {
    --         class = {
    --             "scratchpad"
    --         },
    --     },
    --     properties = { focusable = false }
    -- },

    -- Centered clients
    {
        rule_any = {
            type = {
                "dialog",
            },
            class = {
                "Steam",
                "discord",
                "music",
                "markdown_input",
                "scratchpad",
            },
            instance = {
                "music",
                "markdown_input",
                "scratchpad",
            },
            role = {
                "GtkFileChooserDialog",
                "conversation",
            }
        },
        properties = { placement = centered_client_placement },
    },

    -- Titlebars OFF (explicitly)
    {
        rule_any = {
            instance = {
            },
            class = {
            },
            type = {
              "splash"
            },
            name = {
                -- "^discord.com is sharing your screen.$" -- Discord (running in browser) screen sharing popup
            }
        },
        callback = function(c)
            decorations.hide(c)
        end
    },

    -- Titlebars ON (explicitly)
    {
        rule_any = {
            type = {
                "dialog",
            },
            role = {
                "conversation",
            }
        },
        callback = function(c)
            decorations.show(c)
        end
    },

    -- "Needy": Clients that steal focus when they are urgent
    {
        rule_any = {
            class = {
            },
            type = {
                "dialog",
            },
        },
        callback = function (c)
            c:connect_signal("property::urgent", function ()
                if c.urgent then
                    c:jump_to()
                end
            end)
        end
    },

    -- Fixed terminal geometry for floating terminals
    {
        rule_any = {
            class = {
                "Alacritty",
                "Termite",
                "mpvtube",
                "kitty",
                "st-256color",
                "st",
                "URxvt",
            },
        },
        properties = { width = screen_width * 0.45, height = screen_height * 0.5 }
    },

    -- Visualizer
    {
        rule_any = { class = { "Visualizer" } },
        properties = {
            floating = true,
            maximized_horizontal = true,
            sticky = true,
            ontop = false,
            skip_taskbar = true,
            below = true,
            focusable = false,
            height = screen_height * 0.40,
            opacity = 0.6,
            titlebars_enabled = false,
        },
        callback = function (c)
            awful.placement.bottom(c)
        end
    },

    -- File chooser dialog
    {
        rule_any = { role = { "GtkFileChooserDialog" } },
        properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.65 }
    },

    -- Pavucontrol
    {
        rule_any = { class = { "Pavucontrol" } },
        properties = { floating = true, width = screen_width * 0.45, height = screen_height * 0.8 }
    },

    -- Galculator
    {
        rule_any = { class = { "Galculator" } },
        except_any = { type = { "dialog" } },
        properties = { floating = true, width = screen_width * 0.2, height = screen_height * 0.4 }
    },

    -- File managers
    {
        rule_any = {
            class = {
                "Nemo",
                "Thunar"
            },
        },
        except_any = {
            type = { "dialog" }
        },
        properties = { floating = true, width = screen_width * 0.45, height = screen_height * 0.55}
    },

    -- Screenruler
    {
        rule_any = { class = { "Screenruler" } },
        properties = { border_width = 0, floating = true, ontop = true, titlebars_enabled = false },
        callback = function (c)
            awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
        end
    },

    -- Keepass
    {
        rule_any = { class = { "KeePassXC" } },
        except_any = { name = { "KeePassXC-Browser Confirm Access" }, type = { "dialog" } },
        properties = { floating = true, width = screen_width * 0.7, height = screen_height * 0.75},
    },

    -- Scratchpad
    {
        rule_any = {
            instance = {
                "scratchpad",
                "markdown_input"
            },
            class = {
                "scratchpad",
                "markdown_input"
            },
        },
        properties = {
            skip_taskbar = false,
            floating = true,
            ontop = false,
            minimized = true,
            sticky = false,
            width = screen_width * 0.7,
            height = screen_height * 0.75
        }
    },

    -- Markdown input
    {
        rule_any = {
            instance = {
                "markdown_input"
            },
            class = {
                "markdown_input"
            },
        },
        properties = {
            skip_taskbar = false,
            floating = true,
            ontop = false,
            minimized = true,
            sticky = false,
            width = screen_width * 0.5,
            height = screen_height * 0.7
        }
    },

    -- Music clients (usually a terminal running ncmpcpp)
    {
        rule_any = {
            class = {
                "music",
            },
            instance = {
                "music",
            },
        },
        properties = {
            floating = true,
            width = screen_width * 0.45,
            height = screen_height * 0.50
        },
    },

    -- Image viewers
    {
        rule_any = {
            class = {
                "feh",
                "Sxiv",
            },
        },
        properties = {
            floating = true,
            width = screen_width * 0.7,
            height = screen_height * 0.75
        },
        callback = function (c)
            awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
        end
    },

    -- Magit window
    {
        rule = { instance = "Magit" },
        properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.6 }
    },

    -- Steam guard
    {
        rule = { name = "Steam Guard - Computer Authorization Required" },
        properties = { floating = true },
        -- Such a stubborn window, centering it does not work
        -- callback = function (c)
        --     gears.timer.delayed_call(function()
        --         awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
        --     end)
        -- end
    },

    -- MPV
    {
        rule = { class = "mpv" },
        properties = {},
        callback = function (c)
            -- Make it floating, ontop and move it out of the way if the current tag is maximized
            if awful.layout.get(awful.screen.focused()) == awful.layout.suit.max then
                c.floating = true
                c.ontop = true
                c.width = screen_width * 0.30
                c.height = screen_height * 0.35
                awful.placement.bottom_right(c, {
                    honor_padding = true,
                    honor_workarea = true,
                    margins = { bottom = beautiful.useless_gap * 2, right = beautiful.useless_gap * 2}
                })
            end

            -- Restore `ontop` after fullscreen is disabled
            -- Sorta tries to fix: https://github.com/awesomeWM/awesome/issues/667
            c:connect_signal("property::fullscreen", function ()
                if not c.fullscreen then
                    c.ontop = true
                end
            end)
        end
    },

    -- "Fix" games that minimize on focus loss.
    -- Usually this can be fixed by launching them with
    -- SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0 but not all games use SDL
    {
        rule_any = {
            instance = {
                "synthetik.exe"
            },
        },
        properties = {},
        callback = function (c)
            -- Unminimize automatically
            c:connect_signal("property::minimized", function()
                if c.minimized then
                    c.minimized = false
                end
            end)
        end
    }
}
-- (Rules end here) ..................................................
-- ===================================================================

-- Signals
-- ===================================================================
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- For debugging awful.rules
    -- print('c.class = '..c.class)
    -- print('c.instance = '..c.instance)
    -- print('c.name = '..c.name)

    -- Set every new window as a slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    -- if awesome.startup
    -- and not c.size_hints.user_position
    -- and not c.size_hints.program_position then
    --     -- Prevent clients from being unreachable after screen count changes.
    --     awful.placement.no_offscreen(c)
    --     awful.placement.no_overlap(c)
    -- end
end)

-- When a client starts up in fullscreen, resize it to cover the fullscreen a short moment later
-- Fixes wrong geometry when titlebars are enabled
client.connect_signal("manage", function(c)
    if c.fullscreen then
        gears.timer.delayed_call(function()
            if c.valid then
                c:geometry(c.screen.geometry)
            end
        end)
    end
end)

if beautiful.border_width > 0 then
    client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
    client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
end

-- Set mouse resize mode (live or after)
awful.mouse.resize.set_mode("live")

-- Restore geometry for floating clients
-- (for example after swapping from tiling mode to floating mode)
-- ==============================================================
tag.connect_signal('property::layout', function(t)
    for k, c in ipairs(t:clients()) do
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            local cgeo = awful.client.property.get(c, 'floating_geometry')
            if cgeo then
                c:geometry(awful.client.property.get(c, 'floating_geometry'))
            end
        end
    end
end)

client.connect_signal('manage', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)

client.connect_signal('property::geometry', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)

-- ==============================================================
-- ==============================================================

-- When switching to a tag with urgent clients, raise them.
-- This fixes the issue (visual mismatch) where after switching to
-- a tag which includes an urgent client, the urgent client is
-- unfocused but still covers all other windows (even the currently
-- focused window).
awful.tag.attached_connect_signal(s, "property::selected", function ()
    local urgent_clients = function (c)
        return awful.rules.match(c, { urgent = true })
    end
    for c in awful.client.iterate(urgent_clients) do
        if c.first_tag == mouse.screen.selected_tag then
            client.focus = c
        end
    end
end)

-- Raise focused clients automatically
client.connect_signal("focus", function(c) c:raise() end)

-- Focus all urgent clients automatically
-- client.connect_signal("property::urgent", function(c)
--     if c.urgent then
--         c.minimized = false
--         c:jump_to()
--     end
-- end)

-- Disable ontop when the client is not floating, and restore ontop if needed
-- when the client is floating again
-- I never want a non floating client to be ontop.
client.connect_signal('property::floating', function(c)
    if c.floating then
        if c.restore_ontop then
            c.ontop = c.restore_ontop
        end
    else
        c.restore_ontop = c.ontop
        c.ontop = false
    end
end)

-- Disconnect the client ability to request different size and position
-- Breaks fullscreen and maximized
-- client.disconnect_signal("request::geometry", awful.ewmh.client_geometry_requests)
-- client.disconnect_signal("request::geometry", awful.ewmh.geometry)

-- Show the dashboard on login
-- Add `touch /tmp/awesomewm-show-dashboard` to your ~/.xprofile in order to make the dashboard appear on login
local dashboard_flag_path = "/tmp/awesomewm-show-dashboard"
-- Check if file exists
awful.spawn.easy_async_with_shell("stat "..dashboard_flag_path.." >/dev/null 2>&1", function (_, __, ___, exitcode)
    if exitcode == 0 then
      -- Show dashboard
      if dashboard_show then dashboard_show() end
      -- Delete the file
      awful.spawn.with_shell("rm "..dashboard_flag_path)
    end
end)

-- Garbage collection
-- Enable for lower memory consumption
-- ===================================================================

-- collectgarbage("setpause", 160)
-- collectgarbage("setstepmul", 400)

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
