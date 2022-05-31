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
    hs.application.launchOrFocus("Firefox")
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
