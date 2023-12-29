function thing:new (o)
	--this "function" creates a new object and needs to be initialized
	--for any class that is expect to be used in an OO way.
	o = o or {}   -- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	return o
end

function thing:draw ()
end