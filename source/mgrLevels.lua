mgrLevels = {}
mgrLevels.levelTilemapSprites = {}
local gfx <const> = playdate.graphics

function mgrLevels.update()
    
end


--Feed a Tiled layers table into this function and it will render
    --all the layers in order. 
function mgrLevels.renderLevelTilemaps(layersTable)

    for k,v in pairs(mgrLevels.levelTilemapSprites) do
        v:remove();
    end
    mgrLevels.levelTilemapSprites = {}

    for k,v in pairs(layersTable) do
        if string.find(v.name, 'render') then
            local tilemap = playdate.graphics.tilemap.new()
            tilemap:setImageTable(myImages.mainTilesheet )
            tilemap:setTiles(v.data, 20)
            local newTilemapSprite = gfx.sprite.new(tilemap)
            newTilemapSprite:setCenter(0, 0)
            newTilemapSprite:add()
            table.insert(mgrLevels.levelTilemapSprites, newTilemapSprite);
        end       
        
        --look for the entry point of the player to set their position.
        if string.find(v.name, 'entry') then
            for kk,vv in pairs(v.objects) do
                if string.find(vv.name, 'default') then
                    playerThing.pos.x = vv.x
                    playerThing.pos.x = vv.y
                end  
            end
        end
    end  
end

function mgrLevels.init()

    mgrLevels.renderLevelTilemaps(levels.level1.layers)
    
    
end




SIGNALS:subscribe("loadLevel", mgrEffects, function(_, __, ___, posX, posY)
    local newSwipe = swipe:new()
    newSwipe.pos.x = posX
    newSwipe.pos.y = posY
    table.insert(mgrEffects.swipeEffects, newSwipe)
   
 end)