player = {}

-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- NOTE: Because it's local, you'll have to do it in every .lua source file.
local gfx <const> = playdate.graphics

player.pos = {x=100, y=100}
player.scale = {x=1, y=1}
player.velocity = {x=0.0, y=0.0}
player.velocityIntent = {x=1.0, y=0.0}
player.drag = {x=0.7, y=0.7}
player.sprite = {}
player.speed = 2;
player.maxSpeed = 4;
player.rotDeg = 0;

player.frame = 0;
player.samplePlayer = {};

local DIR_LIST = {
	{x=0,	y=1,	frame=5,	flip=false},
	{x=-0 ,	y=1,	frame=5,	flip=true},
	{x=1,	y=1,	frame=1,	flip=true},
	{x=-1,	y=1,	frame=1,	flip=false},
	{x=1,	y=0,	frame=4,	flip=false},
	{x=-1,	y=0,	frame=4,	flip=true},
	{x=1,	y=-1,	frame=3,	flip=false},
	{x=-1,	y=-1,	frame=3,	flip=true},
	{x=0,	y=-1,	frame=2,	flip=false},
	{x=-0,	y=-1,	frame=2,	flip=true},
}

local boundingBox = {loX =0, loY=0, hiX =440, hiY=260}

function player:new (o)
	--this "function" creates a new object and needs to be initialized
	--for any class that is expect to be used in an OO way.
	o = o or {};   -- create object if user does not provide one
	setmetatable(o, self);
	self.__index = self;
	--

	
	o.sprite = gfx.sprite.new(myImages.playerSheet:getImage(2));
	o.sprite:add()
	o.samplePlayer = playdate.sound.sampleplayer.new("res/sound/woosh.wav")

	return o
end

function player:update()
	
	local velAccel = playdate.geometry.vector2D.new(0,0);

	if playdate.buttonIsPressed( playdate.kButtonUp ) then
		self.velocityIntent.y = -1;
		velAccel.dy = -1
    end
    if playdate.buttonIsPressed( playdate.kButtonRight ) then
		self.velocityIntent.x = 1;
		velAccel.dx = 1
    end
    if playdate.buttonIsPressed( playdate.kButtonDown ) then
		self.velocityIntent.y = 1;
		velAccel.dy = 1
    end
    if playdate.buttonIsPressed( playdate.kButtonLeft ) then
		self.velocityIntent.x = -1;
		velAccel.dx = -1
    end




	
	velAccel = velAccel:normalized():scaledBy(self.speed)

	self.velocity.x = self.velocity.x + velAccel.x
	self.velocity.y = self.velocity.y + velAccel.y
	--If character is moving along one vector only it is likely walking up. 
	if math.abs(velAccel.x) < .9 and math.abs(velAccel.y) >.9  then
		self.velocityIntent.x = 0
	end
	if math.abs(velAccel.y) < .9 and math.abs(velAccel.x) >.9  then
		self.velocityIntent.y = 0
	end
	
	local velVecScaled =  playdate.geometry.vector2D.new(self.velocity.x, self.velocity.y)

	velVecScaled = velVecScaled:normalized():scaledBy(clamp(velVecScaled:magnitude(),0,self.maxSpeed))

	self.pos.x = velVecScaled.dx + self.pos.x;
	self.pos.y = velVecScaled.dy + self.pos.y;
	self.velocity.x = velVecScaled.x * self.drag.x;
	self.velocity.y = velVecScaled.y * self.drag.y;
	if velVecScaled:magnitude() <= .3 then
		self.velocity.x = 0.0;
		self.velocity.y = 0.0;
	end


	if self.pos.x >= boundingBox.hiX or self.pos.x <= boundingBox.loX  then
		self.velocity.x = 0 * self.velocity.x
		while self.pos.x >= boundingBox.hiX do
			self.pos.x = self.pos.x - 1			
		end
		while self.pos.x <= boundingBox.loX  do
			self.pos.x = self.pos.x + 1			
		end
	end
	if self.pos.y >= boundingBox.hiY or self.pos.y <= boundingBox.loY  then
		self.velocity.y = 0 *self.velocity.y
		while self.pos.y >= boundingBox.hiY do
			self.pos.y = self.pos.y - 1			
		end
		while self.pos.y <= boundingBox.loY  do
			self.pos.y = self.pos.y + 1			
		end
	end

	self.sprite:moveTo( self.pos.x, self.pos.y )

	

	

	
	local velVec =  playdate.geometry.vector2D.new(self.velocityIntent.x, self.velocityIntent.y)


	if playdate.buttonJustPressed( playdate.kButtonA ) then
		local posVec = playdate.geometry.vector2D.new(self.pos.x, self.pos.y)
		posVec = posVec + (velVec:normalized() * 20)
		self.velocity.y = 0;
		self.velocity.x = 0;
		SIGNALS:notify("swipe",_, posVec.dx, posVec.dy)
		self.samplePlayer:play();
    end
	local smallestDist = 9999
	for k,v in pairs(DIR_LIST) do
		local distTo = (velVec:normalized() - playdate.geometry.vector2D.new(v.x, v.y):normalized()):magnitude()
		if (smallestDist > distTo) then
			if(v.flip) then
				self.sprite:setImage(myImages.playerSheet:getImage(v.frame), "flipX"  )
			else
				self.sprite:setImage(myImages.playerSheet:getImage(v.frame)  )
			end
			
			smallestDist = distTo;
		end
	end
	self.frame = self.frame + 1;
end
