-- Class.lua factory to create classes
 
function Class(class, extends)
  class.__index = class;
  setmetatable( class, {
    __index = extends,
    __call = function ( cls, ... )
      local self = setmetatable( {}, cls )
      if self.Constructor then
        self:Constructor( ... )
      end
      return self
    end,
  })
  return class
end
 
return Class
