swipe = {}

-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- NOTE: Because it's local, you'll have to do it in every .lua source file.
local gfx <const> = playdate.graphics

swipe.MAX_FRAMES = 3;

swipe.pos = {x=100, y=100}
swipe.sprite = {}
swipe.frame = 1;
swipe.lifetime = 0;
swipe.DURATION = 4
swipe.dead = false

function swipe:new (o)
	--this "function" creates a new object and needs to be initialized
	--for any class that is expect to be used in an OO way.
	o = o or {};   -- create object if user does not provide one
	setmetatable(o, self);
	self.__index = self;
	

	o.sprite = gfx.sprite.new(myImages.swipeSheet:getImage(o.frame));
	o.sprite:add()

	return o
end

function swipe:update()
	if not self.dead then
		self.sprite:moveTo( self.pos.x, self.pos.y )

		self.lifetime = self.lifetime + 1;	
		self.frame = self.frame + 1;

		self.sprite:setImage(myImages.swipeSheet:getImage(
					clamp(math.floor((self.lifetime/self.DURATION) * self.MAX_FRAMES) + 1,
												 1, self.MAX_FRAMES)));

		if(self.lifetime >= self.DURATION) then
			self.sprite:remove()
			self.dead = true
		end
	end
end
