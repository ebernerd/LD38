--global variables--
Gamestate = "Editor"

require "camera"
require "bump"
require "tiles"
require "ser"
require "editor"

function love.load()

end

function love.update( dt )
	editor.update( dt )
end

function love.draw()
	camera:set()
		
		editor.draw()
	
	camera:unset()
end

function love.keypressed( key )

end

function love.keyreleased( key )
	editor.keyreleased( key )
end

function love.mousepressed( x, y, button )

end

function love.mousereleased( x, y )

end

function love.wheelmoved( x, y )
	editor.wheelmoved( x, y )
end