player = {}

-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- NOTE: Because it's local, you'll have to do it in every .lua source file.
local gfx <const> = playdate.graphics

player.pos = playdate.geometry.vector2D.new(100,100)
player.scale = playdate.geometry.vector2D.new(1,1)
player.velocity = playdate.geometry.vector2D.new(0.0,0.0)
player.velocityIntent = playdate.geometry.vector2D.new(1.0,0.0)
player.drag = {x=0.7, y=0.7}
player.sprite = {}
player.handSprite = {}
player.speed = 2;
player.maxSpeed = 4;
player.rotDeg = 0;
player.walking = false;
player.frame = 0;
player.samplePlayer = {};
player.velHandMemory = playdate.geometry.vector2D.new(0,0)
player.timeSincePunch = 30
player.punchHandPos = playdate.geometry.vector2D.new(0,0);

player.buttonLastPressed = nil;
player.buttonLastPressedFrames = 0;
player.dashTime = 0

player.dashVec = playdate.geometry.vector2D.new(0,0)
player.boundingBox = playdate.geometry.rect.new(0, 0, 34, 21)

local DIR_LIST = {
	{x=0,	y=1,	frame=5,	flip=false,	     handFrame = 8},
	{x=-0 ,	y=1,	frame=5,	flip=true,	     handFrame = 8},
	{x=1,	y=1,	frame=1,	flip=true, 	 	 handFrame = 7},
	{x=-1,	y=1,	frame=1,	flip=false, 	 handFrame = 1},
	{x=1,	y=0,	frame=4,	flip=false, 	 handFrame = 6},
	{x=-1,	y=0,	frame=4,	flip=true, 	 	 handFrame = 2},
	{x=1,	y=-1,	frame=3,	flip=false, 	 handFrame = 5},
	{x=-1,	y=-1,	frame=3,	flip=true, 		 handFrame = 3},
	{x=0,	y=-1,	frame=2,	flip=false, 	 handFrame = 4},
	{x=-0,	y=-1,	frame=2,	flip=true, 	 	 handFrame = 4},
}

local boundingBox = {loX =0, loY=0, hiX =4400, hiY=2600}

function player:new (o)
	--this "function" creates a new object and needs to be initialized
	--for any class that is expect to be used in an OO way.
	o = o or {};   -- create object if user does not provide one
	setmetatable(o, self);
	self.__index = self;
	--

	
	o.sprite = gfx.sprite.new(myImages.playerSheet:getImage(2));
	o.sprite:add()

	
	o.handSprite = gfx.sprite.new(myImages.handSheet:getImage(1));
	o.handSprite:add()
	o.samplePlayer = playdate.sound.sampleplayer.new("res/sound/woosh.wav")

	return o
end

function player:update()
	
	self.walking = false;
	local velAccel = playdate.geometry.vector2D.new(0,0);
	
	self.buttonLastPressedFrames = self.buttonLastPressedFrames + 1;
	local FRAMES_BETWEEN_BUTTON_PRESSES_FOR_DASH = 8
	local FRAMES_BETWEEN_DASHES = 3
	local FRAMES_TO_DASH = 8
	self.dashTime = self.dashTime - 1 

	if self.dashTime <= 0 then
		if playdate.buttonIsPressed( playdate.kButtonUp )  then
			self.velocityIntent.y = -1;
			velAccel.dy = -1
			self.walking = true;
			local but = playdate.kButtonUp
			if playdate.buttonJustPressed(but) then
				if self.buttonLastPressed == but
				and  self.buttonLastPressedFrames < FRAMES_BETWEEN_BUTTON_PRESSES_FOR_DASH 
				and self.dashTime < -FRAMES_BETWEEN_DASHES then
					self.dashTime = FRAMES_TO_DASH			
					self.dashVec = playdate.geometry.vector2D.new(0, -1)	
				end
				self.buttonLastPressedFrames = 0;
				self.buttonLastPressed = but;
			end
			
		end

		if playdate.buttonIsPressed( playdate.kButtonRight ) then
			self.velocityIntent.x = 1;
			velAccel.dx = 1
			self.walking = true;
			local but = playdate.kButtonRight
			if playdate.buttonJustPressed(but) then
				if self.buttonLastPressed == but
				and  self.buttonLastPressedFrames < FRAMES_BETWEEN_BUTTON_PRESSES_FOR_DASH 
				and self.dashTime < -FRAMES_BETWEEN_DASHES then
					self.dashTime = FRAMES_TO_DASH	
					self.dashVec = playdate.geometry.vector2D.new(1, 0)			
				end
				self.buttonLastPressedFrames = 0;
				self.buttonLastPressed = but;
			end
			
		end
		if playdate.buttonIsPressed( playdate.kButtonDown ) or self.frame == 2 then
			self.velocityIntent.y = 1;
			velAccel.dy = 1
			self.walking = true;
			self.buttonLastPressed = playdate.kButtonDown;
			local but = playdate.kButtonDown
			if playdate.buttonJustPressed(but) then
				if self.buttonLastPressed == but
				and  self.buttonLastPressedFrames < FRAMES_BETWEEN_BUTTON_PRESSES_FOR_DASH 
				and self.dashTime < -FRAMES_BETWEEN_DASHES then
					self.dashTime = FRAMES_TO_DASH
					self.dashVec = playdate.geometry.vector2D.new(0, 1)				
				end
				self.buttonLastPressedFrames = 0;
				self.buttonLastPressed = but;
			end
			
		end
		if playdate.buttonIsPressed( playdate.kButtonLeft ) then
			self.velocityIntent.x = -1;
			velAccel.dx = -1
			self.walking = true;
			local but = playdate.kButtonLeft
			if playdate.buttonJustPressed(but) then
				if self.buttonLastPressed == but
				and  self.buttonLastPressedFrames < FRAMES_BETWEEN_BUTTON_PRESSES_FOR_DASH 
				and self.dashTime < -FRAMES_BETWEEN_DASHES then
					self.dashTime = FRAMES_TO_DASH				
					self.dashVec = playdate.geometry.vector2D.new(-1, 0)
				end
				self.buttonLastPressedFrames = 0;
				self.buttonLastPressed = but;
			end
			
		end
	end

	
	if self.dashTime == FRAMES_TO_DASH then
		pulp.audio.playSound('dash1')
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

	if velVecScaled:magnitude() > .5 then 
		self.velHandMemory = velVecScaled
	end
	
	self.handSprite:moveTo( -self.velHandMemory:normalized():scaledBy(20).y + self.pos.x,self.velHandMemory:normalized():scaledBy(20).x+ self.pos.y  )


	self.pos.x = velVecScaled.dx + self.pos.x;
	self.pos.y = velVecScaled.dy + self.pos.y;

	if self.dashTime >= 0 then
		self.pos = self.pos + (self.dashVec * 6.5)
	end
	self.velocity.x = velVecScaled.x * self.drag.x;
	self.velocity.y = velVecScaled.y * self.drag.y;
	if velVecScaled:magnitude() <= .3 then
		self.velocity.x = 0.0;
		self.velocity.y = 0.0;
	end
	keepOutOfWalls(self)

	self.sprite:moveTo( self.pos.x, self.pos.y )

	

	

	
	local velVec =  playdate.geometry.vector2D.new(self.velocityIntent.x, self.velocityIntent.y)



	self.timeSincePunch = self.timeSincePunch + 1

	local timeToHoldPunch = 4

	if playdate.buttonJustPressed( playdate.kButtonA ) then
		local posVec = playdate.geometry.vector2D.new(self.pos.x, self.pos.y)
		posVec = posVec + (velVec:normalized() * 20)
		self.velocity.y = 0;
		self.velocity.x = 0;
		SIGNALS:notify("swipe",_, posVec.dx, posVec.dy)
		self.samplePlayer:play();
		if self.timeSincePunch >= timeToHoldPunch then
			self.timeSincePunch = 0 
			self.punchHandPos.x = -self.velHandMemory:normalized():leftNormal():scaledBy(20).y + self.pos.x
			self.punchHandPos.y = self.velHandMemory:normalized():leftNormal():scaledBy(20).x+ self.pos.y 
		end
    end
	
	self.handSprite:setRotation(math.sin(self.frame/4) *6)
	if self.timeSincePunch >= timeToHoldPunch then
		self.punchHandPos.x = -self.velHandMemory:normalized():scaledBy(20).y + self.pos.x
		self.punchHandPos.y = self.velHandMemory:normalized():scaledBy(20).x+ self.pos.y 
	end

	self.handSprite:moveTo( self.punchHandPos.x,  self.punchHandPos.y )	

	if self.punchHandPos.y <= self.pos.y then
		self.handSprite:setZIndex(PLAYER_ZINDEX - 1 )
	else
		self.handSprite:setZIndex(PLAYER_ZINDEX + 1)
	end
	
	self.sprite:setZIndex(PLAYER_ZINDEX)
	local smallestDist = 9999


	for k,v in pairs(DIR_LIST) do
		local distTo = (velVec:normalized() - playdate.geometry.vector2D.new(v.x, v.y):normalized()):magnitude()
		if (smallestDist > distTo) then
			if self.walking == true then
				if(v.flip) then
					self.sprite:setImage(myImages.playerSheet:getImage(v.frame + ((math.floor(self.frame/2) % 3)*5) ), "flipX"  )
				else
					self.sprite:setImage(myImages.playerSheet:getImage(v.frame + ((math.floor(self.frame/2) % 3)*5 ))  )
				end
			elseif self.dashTime >0 then
				if(v.flip) then
					self.sprite:setImage(myImages.playerSheet:getImage(v.frame + 15), "flipX"  )
				else
					self.sprite:setImage(myImages.playerSheet:getImage(v.frame + 15))
				end
			else 
				if(v.flip) then
					self.sprite:setImage(myImages.playerSheet:getImage(v.frame + 5), "flipX"  )
				else
					self.sprite:setImage(myImages.playerSheet:getImage(v.frame + 5))
				end
			end
			self.handSprite:setImage(myImages.handSheet:getImage((math.floor(  (self.frame * .15) % 4) * 10 )  + v.handFrame) )
			
			smallestDist = distTo;
		end
	end
	if self.timeSincePunch <= timeToHoldPunch then
		self.handSprite:setImage(myImages.handSheet:getImage(51))
	end
	if self.timeSincePunch == 1 then
		pulp.audio.playSound('WHAMP' .. tostring( math.random(1,3)))
		shakeFramesSoft = 3
	end
	self.frame = self.frame + 1;



	if (self.walking and self.frame % 5 == 0 ) then
		pulp.audio.playSound('footstep')
	end
end
