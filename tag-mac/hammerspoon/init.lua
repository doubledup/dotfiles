-- require('util')
-- SetRightCmdToHyper()

-- TODO: https://www.hammerspoon.org/Spoons/MicMute.html
-- TODO: add keyboard backlight bindings

local meh = {"cmd", "alt", "ctrl"}
local hyper = {"cmd", "alt", "ctrl", "shift"}

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

hs.notify.new({title = "Hammerspoon", informativeText = "Config loaded"}):send()
hs.hotkey.bind(meh, ",", function()
    hs.reload()
end)

hs.hotkey.bind(hyper, "b", "Bluetooth toggle", function(eventName, params)
    hs.execute("/opt/homebrew/bin/blueutil --power toggle")
end)
hs.hotkey.bind(hyper, "c", "Bluetooth connect", function(eventName, params)
    hs.execute("ID=$(/opt/homebrew/bin/blueutil --paired | grep 'WH-1000XM3' | sed -E 's/^address: ([0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}).*/\\1/'); /opt/homebrew/bin/blueutil --connect $ID")
end)

function PickWindow(modifier, key, appName)
    hs.hotkey.bind(modifier, key, appName, function()
        hs.application.launchOrFocus(appName)
    end)
end

PickWindow("alt", "1", "Kitty")
PickWindow("alt", "2", "Brave Browser")
PickWindow("alt", "3", "Slack")
PickWindow("alt", "4", "Spotify")
PickWindow("alt", "5", "Signal")
PickWindow("alt", "0", "Visual Studio Code")
PickWindow("alt", ";", "Emacs")

hs.loadSpoon('ControlEscape'):start() -- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon
