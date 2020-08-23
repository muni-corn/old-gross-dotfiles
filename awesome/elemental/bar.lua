local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")
local keys = require("keys")

local dock_autohide_delay = 0 -- seconds

local dock = require("noodle.dock")
local dock_placement = function(w)
    return awful.placement.bottom(w)
end

status_primary = wibox.widget {
    valign = 'center',
    align = 'center',
    markup = 'pri',
    fg = beautiful.fg,
    widget = wibox.widget.textbox
}

status_secondary = wibox.widget {
    valign = 'center',
    align = 'right',
    markup = 'sec',
    fg = beautiful.fg,
    widget = wibox.widget.textbox
}

awful.spawn.with_line_callback("muse-status sub p -m plain -p '" .. colors.color15 .. "' -s '" .. colors.active .. "'", {
    stdout = function(l)
        status_primary.markup = l
    end
})

awful.spawn.with_line_callback("muse-status sub s -m plain -p '" .. colors.color15 .. "' -s '" .. colors.active .. "'", {
    stdout = function(l)
        status_secondary.markup = l
    end
})

awful.screen.connect_for_each_screen(function(s)
    -- Create a taglist for every screen
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        widget_template = {
            {
                {
                    id     = 'text_role',
                    valign = "center",
                    widget = wibox.widget.textbox,
                },
                left  = dpi(8),
                right = dpi(8),
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
        buttons = taglist_buttons
    }

    -- Create the taglist wibox
    s.taglist_box = awful.wibar({
        screen = s,
        visible = true,
        ontop = false,
        type = "dock",
        position = "top",
        height = dpi(32),
        bg = beautiful.bg,
    })

    s.taglist_box:setup {
        {
            s.mytaglist,
            status_primary,
            status_secondary,
            layout = wibox.layout.flex.horizontal
        },
        right = dpi(8),
        widget = wibox.container.margin
    }

    -- Create the dock wibox
    s.dock = awful.popup({
        -- Size is dynamic, no need to set it here
        visible = false,
        bg = "#000000c0",
        ontop = true,
        -- type = "dock",
        placement = dock_placement,
        widget = dock
    })
    dock_placement(s.dock)

    local popup_timer
    local autohide = function ()
        if popup_timer then
            popup_timer:stop()
            popup_timer = nil
        end
        popup_timer = gears.timer.start_new(dock_autohide_delay, function()
            popup_timer = nil
            s.dock.visible = false
        end)
    end

    -- Initialize wibox activator
    s.dock_activator = wibox({ screen = s, height = 1, bg = "#00000000", visible = true, ontop = false })
    awful.placement.bottom(s.dock_activator)
    s.dock_activator:connect_signal("mouse::enter", function()
        s.dock.visible = true
        if popup_timer then
            popup_timer:stop()
            popup_timer = nil
        end
    end)

    -- Keep dock activator below fullscreen clients
    local function no_dock_activator_ontop(c)
        if not s then 
            return
        elseif c.fullscreen and s.dock_activator then
            s.dock_activator.ontop = false
        elseif s.dock_activator then
            s.dock_activator.ontop = true
        end
    end
    client.connect_signal("focus", no_dock_activator_ontop)
    client.connect_signal("unfocus", no_dock_activator_ontop)
    client.connect_signal("property::fullscreen", no_dock_activator_ontop)

    -- s.dock_activator:buttons(
    --     gears.table.join(
    --         awful.button({ }, 4, function ()
    --             awful.tag.viewprev()
    --         end),
    --         awful.button({ }, 5, function ()
    --             awful.tag.viewnext()
    --         end)
    -- ))

    local function adjust_dock()
        -- Reset position every time the number of dock items changes
        dock_placement(s.dock)

        -- Adjust activator width every time the dock wibox width changes
        s.dock_activator.width = s.dock.width + dpi(256)
        -- And recenter
        awful.placement.bottom(s.dock_activator)
    end

    adjust_dock()
    s.dock:connect_signal("property::width", adjust_dock)

    s.dock:connect_signal("mouse::enter", function ()
        if popup_timer then
            popup_timer:stop()
            popup_timer = nil
        end
    end)

    s.dock:connect_signal("mouse::leave", function ()
        autohide()
    end)
    s.dock_activator:connect_signal("mouse::leave", function ()
        autohide()
    end)

end)

awesome.connect_signal("elemental::dismiss", function()
    local s = mouse.screen
    s.dock.visible = false
end)

-- Every bar theme should provide these fuctions
function wibars_toggle()
    local s = awful.screen.focused()
    s.dock.visible = not s.dock.visible
end
