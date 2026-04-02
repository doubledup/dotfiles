function noise-on
    if test -f /tmp/sox.pid
        echo "already running"
        return
    end

    play -n synth brownnoise vol 0.08 bass +6 </dev/null >/dev/null 2>&1 &
    echo $last_pid >/tmp/sox.pid
end
