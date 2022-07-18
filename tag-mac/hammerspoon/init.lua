-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
--   hs.alert.show("Hello World!")
-- end)

-- hs.hotkey.bind({"ctrl"}, ";", function()
--     local app = hs.application.get("kitty")
--     if app then
--         if not app:mainWindow() then
--             app:selectMenuItem({"kitty", "New OS window"})
--         elseif app:isFrontmost() then
--             app:hide()
--         else
--             app:activate()
--         end
--     else
--         hs.application.launchOrFocus("kitty")
--     end
-- end)

hs.urlevent.bind("openKitty", function(eventName, params)
    hs.application.launchOrFocus("Kitty")
end)

hs.urlevent.bind("openBrowser", function(eventName, params)
    hs.application.launchOrFocus("Brave Browser")
end)

hs.urlevent.bind("openSlack", function(eventName, params)
    hs.application.launchOrFocus("Slack")
end)

hs.urlevent.bind("openSpotify", function(eventName, params)
    hs.application.launchOrFocus("Spotify")
end)

hs.urlevent.bind("openSignal", function(eventName, params)
    hs.application.launchOrFocus("Signal")
end)

hs.urlevent.bind("openEmacs", function(eventName, params)
    hs.application.launchOrFocus("Emacs")
end)

hs.urlevent.bind("openCode", function(eventName, params)
    hs.application.launchOrFocus("Visual Studio Code")
end)

hs.urlevent.bind("bluetoothToggle", function(eventName, params)
    hs.execute("/opt/homebrew/bin/blueutil --power toggle")
end)

hs.urlevent.bind("bluetoothConnect", function(eventName, params)
    hs.execute("/opt/homebrew/bin/blueutil --paired | /usr/bin/sed -E 's/^address: ([0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}).*/\\1/' | xargs /opt/homebrew/bin/blueutil --connect")
end)
