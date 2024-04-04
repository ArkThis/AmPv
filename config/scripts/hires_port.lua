-- Call with "mpv --script-opts=mpv.host=HOSTNAME,mpv.port=PORT" to override default values.
-- See: https://github.com/mpv-player/mpv/blob/master/DOCS/man/lua.rst
-- print("Host/Port: " .. mp.get_opt("mpv.host") .. mp.get_opt("mpv.port"))

-- Import LuaSocket library
local socket = require("socket")

local host = "*"
local port = 12345
local timeout = 0.5
local timer = timeout


-- Create a TCP socket and bind it to the localhost, on port 12345
local server = assert(socket.bind(host, port))
server:settimeout(timeout)
local client

function wait_socket()
    -- Start listening for connections
    -- DEBUG: print("Listening on host='"..host.."', port=".. port)

    client = server:accept()
    local msg

    if client == nil then
        -- print("Nothing")
        return
    end

    -- Handle the client connection
    client:send("Hello from MPV.\n")
    msg = client:receive('*l')

    handle_msg(msg)
    -- There may be replies in "handle_msg", so don't close the socket, yet.
    client:close()
end


function handle_msg(msg)
    if msg == nil then
        -- empty message, nothing to do.
        return
    end

   print("handling: " .. msg)

   -- Iterate through key=value commands, and convert them 
   -- to a table in one go:
   t = {}
   for k, v in string.gmatch(msg, "(%w+)=(%w+)") do
       t[k] = v
       print("key: " .. k .. " / value: " .. v)

       if k == 'seekframe' then
           local fps = mp.get_property_native("container-fps")
           local pos = t['seekframe'] / fps
           print("seek to frame: " .. pos)
           mp.commandv("seek", pos, "absolute", "exact")
           client:send("ok\n")
       end

       if k == 'status' then
           if v == 'connected' then
               print("connected.")
               client:send("ok\n")
           end
       end
   end
end


function cleanup(event)
    print("Goodbye!")

    -- Shutdown sockets:
    if client ~= nil then
        client:close()
    end

    if server ~= nil then
        server:close()
    end
end

-- =================================================

mp.add_periodic_timer(timer, wait_socket)
mp.register_event("shutdown", cleanup)

-- Seek to position:
-- mp.commandv("seek", 0.0, "absolute", "exact")

