-- Requires

	require 'assets/Circle'

--Initialize OOP

	local class = require '../middleclass'

	Alvo = class('Alvo')

-- New Alvo

function Alvo:initialize()
	-- Criar Circulo do alvo
	self.alvoCirculo = Circle:new(0, 0,5)
end


function Alvo:update(dt)

	local x,y = camera.camera:getPosition()
	local w,h = camera.w, camera.h

	--Set X,Y do alvo.
	--self.alvoCirculo.X = love.mouse.getX()+(x-(w/2))
	--self.alvoCirculo.Y = love.mouse.getY()+(y-(h/2))

	self.alvoCirculo.X = mathFunc:QuadOut(0.1, self.alvoCirculo.X, ((love.mouse.getX()+(x-(w/2))) - self.alvoCirculo.X), 0.5)
	self.alvoCirculo.Y = mathFunc:QuadOut(0.1, self.alvoCirculo.Y, ((love.mouse.getY()+(y-(h/2))) - self.alvoCirculo.Y), 0.5)

	if p1joystick ~= nil then

		local kx = p1joystick:getGamepadAxis("rightx")
		local ky = p1joystick:getGamepadAxis("righty")

		if (kx < -0.3 or kx > 0.3) or (ky < -0.3 or ky > 0.3) then
			local angle = math.atan2(p1joystick:getGamepadAxis("rightx"), p1joystick:getGamepadAxis("righty"))

			self.alvoCirculo.X  = player.player.X+150 * math.sin(angle)
			self.alvoCirculo.Y  = player.player.Y+150 * math.cos(angle)
		end

	end

end


function Alvo:draw()
	self.alvoCirculo:draw()

	--Desenho das linhas Acima/Abaixo do alvo
	love.graphics.line( self.alvoCirculo.X, self.alvoCirculo.Y-self.alvoCirculo.Size, self.alvoCirculo.X, self.alvoCirculo.Y-self.alvoCirculo.Size-3);
	love.graphics.line( self.alvoCirculo.X, self.alvoCirculo.Y+self.alvoCirculo.Size, self.alvoCirculo.X, self.alvoCirculo.Y+self.alvoCirculo.Size+3);
end