enemyBlob = {}

-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- NOTE: Because it's local, you'll have to do it in every .lua source file.
local gfx <const> = playdate.graphics

enemyBlob.pos = playdate.geometry.vector2D.new(100,100)
enemyBlob.scale = playdate.geometry.vector2D.new(1,1)
enemyBlob.velocity = playdate.geometry.vector2D.new(0.0,0.0)
enemyBlob.velocityIntent = playdate.geometry.vector2D.new(1.0,0.0)
enemyBlob.drag = {x=0.6, y=0.6}
enemyBlob.sprite = {}
enemyBlob.handSprite = {}
enemyBlob.speed = 4;
enemyBlob.maxSpeed = 7;
enemyBlob.rotDeg = 0;
enemyBlob.walking = false;
enemyBlob.frame = 0;
enemyBlob.samplePlayer = {};

enemyBlob.shadowSprite = {}


enemyBlob.boundingBox = playdate.geometry.rect.new(-14, -5, 29, 21)

enemyBlob.stateMachine = {}

local DIR_LIST = {
	{x=-0 ,	y=1,	frame=5,	flip="flipX",	 handFlip="flipX",    handFrame = 8},
	{x=1,	y=1,	frame=1,	flip="flipX", 	 handFlip="flipX",	 handFrame = 1},
	{x=-1,	y=1,	frame=1,	flip="", 	 	handFlip="flipX",	handFrame = 7},
	{x=1,	y=0,	frame=4,	flip="", 		handFlip="",	 handFrame = 6},
	{x=-1,	y=0,	frame=4,	flip="flipX", 	 handFlip="",	 handFrame = 2},
	{x=1,	y=-1,	frame=3,	flip="", 	 	handFlip="flipX",	handFrame = 5},
	{x=-1,	y=-1,	frame=3,	flip="flipX", 	handFlip="",	 handFrame = 3},
	{x=0,	y=-1,	frame=2,	flip="", 	 	handFlip="flipX",	handFrame = 4},
}

function enemyBlob:new (o)
	--this "function" creates a new object and needs to be initialized
	--for any class that is expect to be used in an OO way.
	o = o or {};   -- create object if user does not provide one
	setmetatable(o, self);
	self.__index = self;
	--
	self.stateMachine = machine.create({
		initial = 'standing',
		events = {
		  { name = 'land',  from = 'inAir',  to = 'standing' },
		  { name = 'jump', from = 'standing', to = 'inAir'    }
	  }})
	self.stateMachine.curStateFrames = 0;

	function self.stateMachine:onstatechange(event, from, to)
		self.curStateFrames = 0 ;		
	end
	  
	
	o.sprite = gfx.sprite.new(myImages.enemyBlobSheet:getImage(1));
	o.sprite:add();

	o.shadowSprite = gfx.sprite.new(myImages.shadows:getImage(1));
	o.shadowSprite:add()
	
	return o;
end

function enemyBlob:update()

	
	self.stateMachine.curStateFrames = self.stateMachine.curStateFrames + 1;

	if(self.stateMachine:is('standing')) then
		self.velocityIntent.x = 0.0
		self.velocityIntent.y = 0.0
		if(self.stateMachine.curStateFrames > 30) then
			print("sss");
			self.stateMachine:jump()
			self.frame = 0;
		end
	end
	if(self.stateMachine:is('inAir')) then
		self.velocityIntent.x = (playerThing.pos.x - self.pos.x)
		self.velocityIntent.y = (playerThing.pos.y - self.pos.y)
		if(self.stateMachine.curStateFrames > 6) then
			self.stateMachine:land()
			self.frame = 0;
		end
	end

	self.velocityIntent = self.velocityIntent:normalized():scaledBy(self.speed);

	self.velocity.x = (self.velocity.x + self.velocityIntent.x)* self.drag.x;
	self.velocity.y = (self.velocity.y + self.velocityIntent.y)* self.drag.y;

	local velVec =  playdate.geometry.vector2D.new(self.velocity.x, self.velocity.y)	
	local velVecScaled =  playdate.geometry.vector2D.new(self.velocity.x, self.velocity.y)
	velVecScaled = velVecScaled:normalized():scaledBy(clamp(velVecScaled:magnitude(),0,self.maxSpeed))

	if velVecScaled:magnitude() <= .3 then
		self.velocity.x = 0.0;
		self.velocity.y = 0.0;
	end
	self.velocity.x = velVecScaled.x;
	self.velocity.y = velVecScaled.y;


	self.pos.x = self.velocity.x + self.pos.x;
	self.pos.y = self.velocity.y + self.pos.y;

	keepOutOfWalls(self)

	self.sprite:moveTo( self.pos.x, self.pos.y )
	
	

	self.sprite:setZIndex(PLAYER_ZINDEX)
	local smallestDist = 9999


	for k,v in pairs(DIR_LIST) do
		local distTo = (velVec:normalized() - playdate.geometry.vector2D.new(v.x, v.y):normalized()):magnitude()
		if (smallestDist > distTo) then
			
			if(self.stateMachine:is('standing')) then	
				
				--Get frame based on dir list, going down the sprite sheet.

				--5 rows is where the multiply * 5 comes from, for each direction
				--numFrames is the total number of frames in the animation.
				--	In this setup, frames are animated downwards on the sprite sheet
				--animSpeed is the speed at which the animations should play per frame

				local numFrames = 1;
				local animSpeed  = 0.3;
				local animFrame = ((math.floor(self.frame * animSpeed) % numFrames)*5)
				self.sprite:setImage(myImages.enemyBlobSheet:getImage(v.frame + animFrame), v.flip  )

				self.shadowSprite:setImage(myImages.shadows:getImage(1))
				self.shadowSprite:moveTo( self.pos.x ,self.pos.y + 5 )
			end
			if(self.stateMachine:is('inAir')) then
				--This animation starts at 5 down, so we multiply 5 x 5 to get the starting frame
				--and can use the same logic to determine the frame
				local numFrames = 4;
				local animSpeed  = 0.5;
				local animFrame = (5*5) + ((math.floor(self.frame * animSpeed) % numFrames)*5)
				self.sprite:setImage(myImages.enemyBlobSheet:getImage(v.frame + animFrame), v.flip  )
		

				self.shadowSprite:setImage(myImages.shadows:getImage(3))
				self.shadowSprite:moveTo( self.pos.x ,self.pos.y + 5 )
			end
			
			smallestDist = distTo;
		end
	end

	self.frame = self.frame + 1;

end
