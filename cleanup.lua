shared._cleanup_event_ = shared._cleanup_event_ or Instance.new("BindableEvent")
shared._cleanup_event_:Fire()

local cleanup = {}

cleanup._connections = {}

function cleanup:WatchConnection(conn)
    assert(conn, "No connection passed")
    assert(typeof(conn) == 'RBXScriptConnection', ('Connection must be of type RBXScriptConnection. Got type: %s'):format(typeof(conn)))

    table.insert(cleanup._connections, conn)
end

task.spawn(function()
    shared._cleanup_event_.Event:Wait()
    
    for _, conn in pairs(cleanup._connections) do
        if typeof(conn) ~= 'RBXScriptConnection' then continue end
        conn:Disconnect()
    end
end)

return cleanup
