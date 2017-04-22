local tileset = love.graphics.newImage("assets/tileset.png")
tileset:setFilter( "nearest", "nearest" )

map = {
	layers = {
		fg = love.graphics.newSpriteBatch( tileset, 5000 ),
		mg = love.graphics.newSpriteBatch( tileset, 5000 ),
		bg = love.graphics.newSpriteBatch( tileset, 5000 )
	},
	dynamics = {},
	world = {
		fg = {},
		mg = {},
		bg = {}
	}
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



function map.initializeLevel( path )

	local path = path or "levels/default.lua"
	local m = love.filesystem.load( path )()
	for i, v in pairs( m ) do
		local t = {
			x = x,
			y = y,
			name = tilesConv[ id ]
		}
		for i, v in pairs( tiles[ tilesConv[ id ] ] ) do

			t[i] = v

		end
		if tiles[ t.name ].mode == "dynamic" then
			t.xvel = 0
			t.yvel = 0
			table.insert( map.dynamics, t )
		else
			table.insert( map.world[ t.layer ], t )
		end
	end

end

function map.update( dt )
	for i, v in pairs( map.dynamics ) do

	end
end

function map.drawDynamics( layer )
	for i, v in pairs( map.dynamics ) do
		if v.layer == layer then
			love.graphics.draw( Textures[v.name], v.x, v.y )
		end
	end
end

function map.draw()
	if Gamestate == "Game" then
		love.graphics.draw( map.layers.bg )
		map.drawDynamics("bg")

		love.graphics.draw( map.layers.mg )
		map.drawDynamics("mg")

		love.graphics.draw( map.layers.fg )
		map.drawDynamics("fg")
	end
end
