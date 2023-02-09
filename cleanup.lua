shared.CLEANUP_EVENT = shared.CLEANUP_EVENT or Instance.new("BindableEvent")
shared.CLEANUP_EVENT:Fire()

local cleanup = {}

cleanup._connections = {}
cleanup._outdated = false

function cleanup:WatchConnection(conn)
    assert(conn, "No connection passed")
    assert(typeof(conn) == 'RBXScriptConnection', ('Connection must be of type RBXScriptConnection. Got type: %s'):format(typeof(conn)))

    table.insert(self._connections, conn)
end

function cleanup:IsOutdated()
    return self._outdated
end

task.spawn(function()
    shared.CLEANUP_EVENT.Event:Wait()
    
    shared._outdated = true
    for _, conn in pairs(cleanup._connections) do
        if typeof(conn) ~= 'RBXScriptConnection' then continue end
        conn:Disconnect()
    end
end)

return cleanup
