thing = {}

-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- NOTE: Because it's local, you'll have to do it in every .lua source file.
local gfx <const> = playdate.graphics

thing.pos = {x=100, y=100}
thing.scale = {x=1, y=1}
thing.velocity = {x=0.0, y=0.0}
thing.drag = {x=0.9, y=0.9}
thing.sprite = {}
thing.speed = 2;
thing.maxSpeed = 13;
thing.rotDeg = 0;

thing.playerSheet= playdate.graphics.image.new("/res/sprites/player.png")

thing.spriteStack = {}
local sF =70.0
local polygon1 = playdate.geometry.polygon.new((0.3) * sF, (0.25) * sF,
(0.7) * sF, (0.25) * sF,
(0.7) * sF, (0.72) * sF,
(0.61) * sF, (0.86) * sF,
(0.5) * sF, (0.91) * sF,
(0.4) * sF, (0.85) * sF,
(0.3) * sF, (0.7) * sF)

polygon1:close()


local polygon2 = playdate.geometry.polygon.new((0.3) * sF, (0.25) * sF,
(0.7) * sF, (0.25) * sF,
(0.7) * sF, (0.72) * sF,
(0.61) * sF, (0.86) * sF,
(0.5) * sF, (0.91) * sF,
(0.4) * sF, (0.85) * sF,
(0.3) * sF, (0.7) * sF,
(0.3) * sF, (0.28) * sF,
(0.37) * sF, (0.28) * sF,
(0.37) * sF, (0.69) * sF,
(0.44) * sF, (0.81) * sF,
(0.5) * sF, (0.85) * sF,
(0.58) * sF, (0.8) * sF,
(0.64) * sF, (0.7) * sF,
(0.64) * sF, (0.29) * sF,
(0.3) * sF, (0.28) * sF)

polygon2:close()


local boundingBox = {loX =65, loY=60, hiX =440, hiY=260}


local stackScaleY = .8;

function thing:new ()
	--this "function" creates a new object and needs to be initialized
	--for any class that is expect to be used in an OO way.
	o = o or {};   -- create object if user does not provide one
	setmetatable(o, self);
	self.__index = self;


	self:addToStack(polygon1);
	self:addToStack(polygon1);
	self:addToStack(polygon1);
	self:addToStack(polygon1);
	self:addToStack(polygon2);
	self:addToStack(polygon2);
	self:addToStack(polygon2);
	
	return o
end

function thing:addToStack(poly)

	local sprite = gfx.sprite.new();
	sprite.thingScale = self.scale;
	
	local sT = playdate.geometry.affineTransform.new()
	sT:translate(0, sF- (sF*stackScaleY))
	sT:scale(1,stackScaleY)
	
	sprite.basePoly = poly * sT
	sprite.poly = sprite.basePoly;
	function sprite:draw(x, y, width, height)
		playdate.graphics.setLineWidth(2)
		playdate.graphics.setColor(playdate.graphics.kColorWhite)
		playdate.graphics.fillPolygon(self.poly)
		playdate.graphics.setColor(playdate.graphics.kColorBlack)
		
		playdate.graphics.drawPolygon(self.poly)
	end

	sprite:moveTo( self.pos.x, self.pos.y )
	sprite:setSize(200, 200) 
	sprite:add()

	table.insert(self.spriteStack, sprite)
end


function thing:update()
	if playdate.buttonIsPressed( playdate.kButtonUp ) then
        self.velocity.y = self.velocity.y - self.speed;
		print("I am going up;")
    end
    if playdate.buttonIsPressed( playdate.kButtonRight ) then
        self.velocity.x = self.velocity.x +  self.speed;
		print("I am going right;")
    end
    if playdate.buttonIsPressed( playdate.kButtonDown ) then
        self.velocity.y = self.velocity.y +  self.speed;
		print("I am going down;")
    end
    if playdate.buttonIsPressed( playdate.kButtonLeft ) then
        self.velocity.x = self.velocity.x -  self.speed;
		print("I am going left;")
    end
	
	self.velocity.x = clamp(self.velocity.x,-self.maxSpeed,self.maxSpeed)
	self.velocity.y = clamp(self.velocity.y,-self.maxSpeed,self.maxSpeed)

	self.pos.x = self.velocity.x + self.pos.x;
	self.pos.y = self.velocity.y + self.pos.y;
	self.velocity.x = self.velocity.x * self.drag.x;
	self.velocity.y = self.velocity.y * self.drag.y;

	if self.pos.x >= boundingBox.hiX or self.pos.x <= boundingBox.loX  then
		self.velocity.x = -1.1 * self.velocity.x
		self.pos.x = self.velocity.x + self.pos.x;
	end
	if self.pos.y >= boundingBox.hiY or self.pos.y <= boundingBox.loY  then
		self.velocity.y = -1.1 *self.velocity.y
		self.pos.y = self.velocity.y + self.pos.y;
	end
	local sT = playdate.geometry.affineTransform.new()
	if playdate.buttonIsPressed( playdate.kButtonA ) then
		self.rotDeg =  self.rotDeg + 2;		
    end
	if playdate.buttonIsPressed( playdate.kButtonB ) then
		self.rotDeg  = self.rotDeg-2;
    end

	--rotate around the size of the sprite * the scale of the stack
	sT:rotate(playdate.getCrankPosition(), sF/2,sF/2)

	
	for i=1,#self.spriteStack do
		self.spriteStack[i].poly = self.spriteStack[i].basePoly *  sT;

		self.spriteStack[i].thingScale = self.scale;
		self.spriteStack[i]:moveTo( self.pos.x, self.pos.y + ((i-1) * 2) )
		self.spriteStack[i]:markDirty();
	end


	
	
	print(self.pos.x, self.pos.y)
end