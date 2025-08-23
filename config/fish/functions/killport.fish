function killport --description "Kill process on port"
    lsof -ti:$argv[1] | xargs kill -9
end
