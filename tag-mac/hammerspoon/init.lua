-- require('util')
-- SetRightCmdToHyper()

-- TODO: https://www.hammerspoon.org/Spoons/MicMute.html
-- TODO: add keyboard backlight bindings

local meh = {"cmd", "alt", "ctrl"}
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- config

hs.notify.new({title = "Hammerspoon", informativeText = "Config loaded"}):send()
hs.hotkey.bind(meh, ",", function()
    hs.reload()
end)

-- bluetooth

hs.hotkey.bind(hyper, "b", "Bluetooth toggle", function(eventName, params)
    hs.execute("/opt/homebrew/bin/blueutil --power toggle")
end)
hs.hotkey.bind(hyper, "c", "Bluetooth connect", function(eventName, params)
    hs.execute("ID=$(/opt/homebrew/bin/blueutil --paired | grep 'WH-1000XM3' | sed -E 's/^address: ([0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}).*/\\1/'); /opt/homebrew/bin/blueutil --connect $ID")
end)

-- key remapping

hs.loadSpoon('ControlEscape'):start() -- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon

-- window management

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
PickWindow("alt", "8", "Emacs")
PickWindow("alt", "0", "Visual Studio Code")
