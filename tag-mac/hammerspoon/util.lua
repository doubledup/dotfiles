function HyperPickWindow(key, appName)
    hs.hotkey.bind(HYPER, key, appName, function()
        hs.application.launchOrFocus(appName)
    end)
end

function SetRightCmdToHyper()
    -- right cmd as hyper, cribbed from https://github.com/Hammerspoon/hammerspoon/issues/1025#issuecomment-1011435207
    -- we have to watch for flag changes *and* keyDown/Up since a command key (e.g. Cmd-C) is
    -- it's own event
    hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(ev)
        -- synthesized events set 0x20000000 and we may or may not get the nonCoalesced bit,
        -- so filter them out
        local rawFlags = ev:getRawEventData().CGEventData.flags & 0xdffffeff
        local regularFlags = ev:getFlags()

        -- uncomment this out when troubleshooting -- apparently different modifiers use
        -- different flags indicating left vs right: e.g.

        --     {
        --       cmd = true
        --     }    1048584
        --     {}   0
        --     {
        --       cmd = true
        --     }    1048592        // right
        --     {}   0
        --
        --     {
        --       shift = true
        --     }    131076         // right
        --     {}   0
        --     {
        --       shift = true
        --     }    131074
        --     {}   0
        --
        -- etc.
        --     print(inspect(regularFlags), rawFlags)

        if rawFlags == 1048592 and ev:getType() == hs.eventtap.event.types.keyDown then
            ev:setFlags({
                cmd = true,
                alt = true,
                shift = true,
                ctrl = true,
            })
            return true, { ev }
        end
    end):start()
end
