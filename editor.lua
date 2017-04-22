local tileset = love.graphics.newImage("assets/tileset.png")
tileset:setFilter( "nearest", "nearest" )

editor = {
	mx = 0,
	my = 0,
	unit = 50,
	selected = 1,
	layers = {
		fg = love.graphics.newSpriteBatch( tileset, 5000 ),
		mg = love.graphics.newSpriteBatch( tileset, 5000 ),
		bg = love.graphics.newSpriteBatch( tileset, 5000 )
	},
	world = {
		fg = {},
		mg = {},
		bg = {}
	},
	layer = "mg",
	speed = 4,
}



local tiles = love.filesystem.load( "tiles.lua" )()
local tilesConv = {}
for i, v in pairs( tiles ) do
	tilesConv[ #tilesConv+1 ] = i
end

local sblookup = {
	[1]   = { "dirt", "grass", "sand", "stone", "", "", "", "", "", "" },
	[2]  = { "", "", "", "", "", "", "", "", "", "" },
	[3] = { "", "", "", "", "", "", "", "", "", "" },
	[4] = { "", "", "", "", "", "", "", "", "", "" },
	[5] = { "", "", "", "", "", "", "", "", "", "" },
	[6] = { "", "", "", "", "", "", "", "", "", "" },
	[7] = { "", "", "", "", "", "", "", "", "", "" },
	[8] = { "", "", "", "", "", "", "", "", "", "" },
	[9] = { "", "", "", "", "", "", "", "", "", "" },
	[10] = { "", "", "", "", "", "", "", "", "", "" },
}
local tileQuads = {}
for y, b in pairs( sblookup ) do
	for x, k in pairs( b ) do
		tileQuads[ k ] = love.graphics.newQuad((x-1)*editor.unit, (y-1)*editor.unit, editor.unit, editor.unit, tileset:getWidth(), tileset:getHeight())
	end
end


function editor.hasObj()
	for i, v in pairs( editor.world[ editor.layer ] ) do
		if v.x == editor.mx and v.y == editor.my then
			return true, v.name
		end
	end
	return false
end

function editor.updateCurrentLayer()
	editor.layers[ editor.layer ]:clear()
	for i, v in pairs( editor.world[ editor.layer ] ) do
		editor.layers[ editor.layer ]:add( tileQuads[ v.name ], v.x, v.y, 0, 1, 1 )
	end
end

function editor.initializeObject( x, y, id )

	local t = {
		x = x,
		y = y,
		name = tilesConv[ id ]
	}
	for i, v in pairs( tiles[ tilesConv[ id ] ] ) do

		t[i] = v

	end
	table.insert( editor.world[ editor.layer ], t )
	editor.updateCurrentLayer()

end

function editor.destroyObject( x, y )

	for i, v in pairs( editor.world[ editor.layer ] ) do
		if v.x == x and v.y == y then
			table.remove( editor.world[ editor.layer ], i )
			v = nil
			editor.updateCurrentLayer()
			return
		end
	end

end

function editor.update( dt )
	if Gamestate == "Editor" then
		local x = ( love.mouse.getX( ) + camera.x )
		local y = ( love.mouse.getY( ) + camera.y )
		editor.mx = math.ceil( x / editor.unit ) * editor.unit - editor.unit
		editor.my = math.ceil( y / editor.unit ) * editor.unit - editor.unit

		if love.mouse.isDown( 1 ) then
			if not editor.hasObj() then
				editor.initializeObject( editor.mx, editor.my, editor.selected )
			end
		elseif love.mouse.isDown( 2 ) then
			if editor.hasObj() then
				editor.destroyObject( editor.mx, editor.my )
			end
		end

		if love.keyboard.isDown( "w" ) then
			camera.y = camera.y - editor.speed
		elseif love.keyboard.isDown( "s" ) then
			camera.y = camera.y + editor.speed
		end
		if love.keyboard.isDown( "a" ) then
			camera.x = camera.x - editor.speed
		elseif love.keyboard.isDown( "d" ) then
			camera.x = camera.x + editor.speed
		end
		if love.keyboard.isDown("[") then
			--save
			local savedata = {}
			for layer, layerData in pairs( editor.world ) do
				for i, v in pairs( layerData ) do
					table.insert( savedata, {
						x = v.x/editor.unit,
						y = v.y/editor.unit,
						layer = layer,
						name = v.name,
					})
				end
			end
			love.system.setClipboardText( table.serialize( savedata ) )
		end
	end
end

function editor.draw()

	if Gamestate == "Editor" then
		love.graphics.setColor( 255, 255, 255 )
		love.graphics.draw( editor.layers.bg )
		love.graphics.draw( editor.layers.mg )
		love.graphics.draw( editor.layers.fg )
		if not love.keyboard.isDown( "lalt" ) then
			love.graphics.printf( "(" .. editor.mx .. "," .. editor.my .. ")", editor.mx-editor.unit/2, editor.my+love.graphics.getFont():getHeight()+editor.unit-5, editor.unit*2, "center" )
			local _,obj = editor.hasObj()
			love.graphics.printf( "[" .. (obj or "none") .. "]", editor.mx-editor.unit/2, editor.my - love.graphics.getFont():getHeight()-2, editor.unit*2, "center")
		end
		love.graphics.rectangle( "line", editor.mx, editor.my, editor.unit, editor.unit )
		love.graphics.print( "Selected: " .. tilesConv[editor.selected], camera.x, camera.y )
		love.graphics.print( "Layer: " .. editor.layer, camera.x, camera.y + 15 )
	end

end

function editor.wheelmoved( x, y )
	if Gamestate == "Editor" then
		if y > 0 then
			--Wheel down--
			editor.selected = editor.selected + 1
			if editor.selected > #tilesConv then
				editor.selected = 1
			end
		elseif y < 0 then
			editor.selected = editor.selected - 1
			if editor.selected < 1 then
				editor.selected = #tilesConv
			end
		end
	end
end

function editor.keyreleased( key )
	if Gamestate == "Editor" then
		if key == "tab" then
			if editor.layer == "mg" then
				editor.layer = "fg"
			elseif editor.layer == "fg" then
				editor.layer = "bg"
			else
				editor.layer = "mg"
			end
		end
	end
end


--[[ Initialize the editor ]]--