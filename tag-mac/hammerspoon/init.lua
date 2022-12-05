require('util')

-- TODO: https://www.hammerspoon.org/Spoons/MicMute.html
-- TODO: add keyboard backlight bindings

local meh = {"cmd", "alt", "ctrl"}
local hyper = {"cmd", "alt", "ctrl", "shift"}

SetRightCmdToHyper()

-- hyper = hs.hotkey.modal.new({}, 'F20')
-- function enterHyperMode()
--     hs.alert.show("ENTER")
--     hyper.triggered = false
--     hyper:enter()
-- end
-- -- send ESCAPE if no other keys are pressed.
-- function exitHyperMode()
--     hs.alert.show("EXIT")
--     hyper:exit()
--     -- if not hyper.triggered then
--     --     hs.eventtap.keyStroke({}, 'ESCAPE')
--     -- end
-- end
-- hs.hotkey.bind({}, 'F20', enterHyperMode, exitHyperMode)

-- hyper:bind({}, ".", function ()
--     hs.reload()
-- end)

-- hyper:bind({}, "b", function ()
--     hs.execute("/opt/homebrew/bin/blueutil --power toggle")
-- end)
-- hyper:bind({}, "c", function ()
--     hs.execute("ID=$(/opt/homebrew/bin/blueutil --paired | grep 'WH-1000XM3' | sed -E 's/^address: ([0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}).*/\\1/'); /opt/homebrew/bin/blueutil --connect $ID")
-- end)

-- hyper:bind({}, "j", function ()
--     hs.application.launchOrFocus("Brave Browser")
-- end)
-- hyper:bind({}, "k", function ()
--     hs.application.launchOrFocus("Kitty")
-- end)


hs.notify.new({title = "Hammerspoon", informativeText = "Config loaded"}):send()

hs.hotkey.bind(meh, ".", function()
    hs.reload()
end)

hs.hotkey.bind(hyper, "b", "Bluetooth toggle", function(eventName, params)
    hs.execute("/opt/homebrew/bin/blueutil --power toggle")
end)
hs.hotkey.bind(hyper, "c", "Bluetooth connect", function(eventName, params)
    hs.execute("ID=$(/opt/homebrew/bin/blueutil --paired | grep 'WH-1000XM3' | sed -E 's/^address: ([0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}).*/\\1/'); /opt/homebrew/bin/blueutil --connect $ID")
end)

HyperPickWindow(hyper, "j", "Brave Browser")
HyperPickWindow(hyper, "k", "Kitty")
HyperPickWindow(hyper, "o", "Visual Studio Code")
HyperPickWindow(hyper, "l", "Slack")
HyperPickWindow(hyper, "m", "Signal")
HyperPickWindow(hyper, "u", "Spotify")
HyperPickWindow(hyper, ";", "Emacs")

SetRightCmdToHyper()
