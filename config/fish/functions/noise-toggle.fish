function noise-toggle
    if test -f /tmp/sox.pid
        noise-off
    else
        noise-on
    end
end
