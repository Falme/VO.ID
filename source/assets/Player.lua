-- Requires

	require 'assets/Circle'

local class = require '../middleclass'

Player = class('Player')

function Player:initialize()

	--Define X e Y Inicial do player
	local X, Y = camera.camera:getPosition()

	--Cria um novo jogador de acordo com o X,Y da camera
	self.player = Circle:new(X, Y, 0)
	self.player.Type = 'fill'

	--Não se mover até começar o Gameplay
	self.canMove = false

	--Velocidade movimentação player
	self.Velocity = 200

	--Booleano que verifica se player não tem Aura Coletada
	self.Alone = true


	--Verifica se o player Esta vivo
	self.Alive = true

	--Modo de ataque ou defesa
	self.Mode = {
		attack = false,
		defense = true
	}


end

function Player:update(dt)

	--Se Está se Movimentando e Se Está no gameplay (para poder mover o player)
	if self:VerifyMovement() and self.canMove and self.Alive then
		
		--Seta X,Y que o player deve se mover
		local X, Y = self:moveForward(self:direction())

		--Move o jogador livremente Caso não há nenhuma aura coletada
			self.player.X = self.player.X+(X*dt)
			self.player.Y = self.player.Y+(Y*dt)

	end

	--if love.mouse.isDown(1) and self.Mode.attack then
	--	self.player:Launch()
	--end



	if love.mouse.isDown(2) then
		if self.Mode.attack then 
			self.Mode.attack = false
			self.Mode.defense = true
		elseif self.Mode.defense then 
			self.Mode.attack = true
			self.Mode.defense = false
		end
		--self.player:Launch()
	end

end

function Player:draw()

		self.player:draw()

end

--Other Functions

function Player:moveForward(angle)

	local x = self.Velocity * math.sin(angle);
    local y = self.Velocity * math.cos(angle);

	if spaceAura:VerificaAuraColetada() then

    	x = (self.Velocity-(10*spaceAura.NumeroAurasColetadas)) * math.sin(angle);
    	y = (self.Velocity-(10*spaceAura.NumeroAurasColetadas)) * math.cos(angle);
	end

    return x,y
end

function Player:Launch()

	spaceAura:ResetCollectedAuras()

	local Valor = -1
	local Saved = 100000000

	for i, auras in ipairs(spaceAura.CollectedAuras) do
		if i > 0 then

			if mathFunc:GetDistance(alvo.alvoCirculo, auras.aura) < Saved then
				Valor = i
				Saved = mathFunc:GetDistance(alvo.alvoCirculo, auras.aura)
			end

		end

	end

	if Valor > -1 then
		spaceAura:LaunchAura(Valor)
	end

end

--Angulo de direção do jogador para definir movimentação
function Player:direction()

	-- 270 degrees (ensures direction)
	local angle = 0

		if love.keyboard.isDown('d') or 
			love.keyboard.isDown('right') then

			-- 0/360 degrees
			angle = math.pi/2


		elseif love.keyboard.isDown('a') or 
			love.keyboard.isDown('left') then

			-- 180 degrees
			angle = math.pi+math.pi/2
		end


		if love.keyboard.isDown('w') or 
			love.keyboard.isDown('up') then

			-- 90 degrees
			angle = math.pi

			if love.keyboard.isDown('d') or 
				love.keyboard.isDown('right') then

				-- 45 degrees
				angle = angle - ((math.pi/2)/2)

			elseif love.keyboard.isDown('a') or 
				love.keyboard.isDown('left') then

				-- 135 degrees
				angle = angle + ((math.pi/2)/2)
			end

		elseif love.keyboard.isDown('s') or 
			love.keyboard.isDown('down') then

			-- 270 degrees
			angle = 0

			if love.keyboard.isDown('d') or 
				love.keyboard.isDown('right') then

				-- 315 degrees
				angle = angle + ((math.pi/2)/2)

			elseif love.keyboard.isDown('a') or 
				love.keyboard.isDown('left') then

				-- 225 degrees
				angle = angle - ((math.pi/2)/2)
			end
		end

	if p1joystick ~= nil then

		if (p1joystick:getGamepadAxis("leftx") < -0.3 or p1joystick:getGamepadAxis("leftx") > 0.3) or 
			(p1joystick:getGamepadAxis("lefty") < -0.3 or p1joystick:getGamepadAxis("lefty") > 0.3) then

			angle = math.atan2(p1joystick:getGamepadAxis("leftx"), p1joystick:getGamepadAxis("lefty"))

		end

	end

	return angle

end

-- Verificar se player está se movimentando
function Player:VerifyMovement()

	if 	not love.keyboard.isDown('w') and 
		not love.keyboard.isDown('a') and 
		not love.keyboard.isDown('s') and 
		not love.keyboard.isDown('d') and 
		not love.keyboard.isDown('up') and 
		not love.keyboard.isDown('down') and 
		not love.keyboard.isDown('left') and 
		not love.keyboard.isDown('right') then

		if p1joystick == nil then

			return false

		else
			if (p1joystick:getGamepadAxis("leftx") > -0.3 and p1joystick:getGamepadAxis("leftx") < 0.3) and 
			(p1joystick:getGamepadAxis("lefty") > -0.3 and p1joystick:getGamepadAxis("lefty") < 0.3) then

				return false

			end

		end
		--Não está sendo pressionada

	end


	--Está sendo pressionada
	return true

end
