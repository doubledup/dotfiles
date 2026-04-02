function noise-off
    if test -f /tmp/sox.pid
        kill (cat /tmp/sox.pid)
        rm /tmp/sox.pid
    end
end
