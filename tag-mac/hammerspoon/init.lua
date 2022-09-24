require('util')

MEH = {"cmd", "alt", "ctrl"}
HYPER = {"cmd", "alt", "ctrl", "shift"}

-- TODO: add keyboard backlight bindings

hs.hotkey.bind(MEH, ".", function()
  hs.reload()
end)
hs.notify.new({title = "Hammerspoon", informativeText = "Config loaded"}):send()

hs.hotkey.bind(HYPER, "b", "Bluetooth toggle", function(eventName, params)
    hs.execute("/opt/homebrew/bin/blueutil --power toggle")
end)
hs.hotkey.bind(HYPER, "c", "Bluetooth connect", function(eventName, params)
    hs.execute("ID=$(/opt/homebrew/bin/blueutil --paired | grep 'WH-1000XM3' | sed -E 's/^address: ([0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}-[0-9a-f]{2}).*/\\1/'); /opt/homebrew/bin/blueutil --connect $ID")
end)

HyperPickWindow("j", "Brave Browser")
HyperPickWindow("k", "Kitty")
HyperPickWindow("o", "Visual Studio Code")
HyperPickWindow("l", "Slack")
HyperPickWindow("m", "Signal")
HyperPickWindow("u", "Spotify")
HyperPickWindow(";", "Emacs")

SetRightCmdToHyper()
