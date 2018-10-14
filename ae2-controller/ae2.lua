local Class = dofile("Class.lua")

local component = require("component")
local unserialize = require("serialization").unserialize
local config = {}

do --lazy file ref close
   config = unserialize(io.open('/etc/ae2-controller.cfg').read('*a'))
end

if component.isAvailable('me_interface') then
   meIface = component.me_interface
elseif component.isAvailable('me_controller') then
   meIface = component.me_controller
else
   error("No available ME network")
end

local Item = {}
Class(Item)

function Item:constructor(itemLabel, itemTargetQty)
   self.itemLabel = itemLabel
   self.itemTargetQty = itemTargetQty
   self.orderQtyAmmount = math.floor(self.itemTargetQty * 0.2)
   self.iscraftable = false --false until proven otherwise
   self.tracker = {
      isDone = function() return true end}
   self:getCurrentQty()

end

function Item:getCurrentQty()
   local result = meIface.getItemsInNetwork({label=self.itemLabel})
   if result['n'] >= 1 then
      self.isCraftable = result[1].isCraftable
      return result[1].size
   else
      io.stderr:write('Item not present and is not craftable: ' .. self.itemLabel)
      self.isCraftable = false
      return -1
   end
end

function Item:requestItem()
   if self.tracker.isDone() or self.tracker.isCanceled() then
      local result = meIface.getCraftables({label=self.itemLabel})
      if result['n'] >= 1 then 
	 self.tracker = result[1].request(self.orderQtyAmmount)
      else
	 io.stderr:write('Item not present or not craftable: ' .. self.itemLabel
			    .. '\n Skipping...')
	 self.isCraftable = false
      end
   else
      io.stderr:write('Item are still being crafted: ' .. self.iemLabel)
   end
end

      
