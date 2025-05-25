local gfx <const> = playdate.graphics

myImages = {}

--Player sheets
myImages.playerSheet = gfx.imagetable.new("/res/sprites/player")
myImages.handSheet = gfx.imagetable.new("/res/sprites/hand")
myImages.swipeSheet  = gfx.imagetable.new("/res/sprites/swipe/Spritesheet")
myImages.shadows  = gfx.imagetable.new("/res/sprites/shadow")


--enemyBlob
myImages.enemyBlobSheet = gfx.imagetable.new("/res/sprites/blobEnemy")

myImages.mainTilesheet =  gfx.imagetable.new("/res/sprites/PackedTilesets/mainTileset") 

myImages.gameStuff = gfx.image.new("/res/sprites/gameStuff")