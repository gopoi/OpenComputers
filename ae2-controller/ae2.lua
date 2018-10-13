local Class = dofile("Class.lua")

local component = require("component")
local unserialize = require("serialization").unserialize
local config = {}

{
   config = unserialize(io.open('/etc/ae2-controller.cfg'))
}

if component.isAvailable('me_interface') then
   meIface = component.me_interface
elseif component.isAvailable('me_controller') then
   meIface = component.me_controller
else
   error("No available ME network")
end

