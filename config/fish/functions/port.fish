function port --description "Find process using a port"
    lsof -ti:$argv[1]
end
