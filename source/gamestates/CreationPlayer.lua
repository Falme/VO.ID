-- Requires

	require 'assets/Player'
	require 'assets/Enemies'

local class = require '../middleclass'

CreationPlayer = class('CreationPlayer')

function CreationPlayer:initialize()
	
	--create Player : Global
		player = Player:new()

	--create Enemy : Global
		enemies = Enemies:new()


	--Create Image Tutorial

		--X e Y Inicial, utilizado para qualquer gamestate
		local tutsX, tutsY = camera.camera:getPosition()
		tuts = {
			src = love.graphics.newImage( 'graphics/tuts.png' ),
			alpha = 0,
			X= tutsX,
			Y= tutsY,
			learned = false
		}

	--Player está sendo criado
		self.playerCreating = true

	--Tutorial está sendo criado
		self.tutorialCreating = false

end

function CreationPlayer:update(dt)

	--Animação Criar Player
	if self.playerCreating then
		player.player.Size = mathFunc:QuadOut(0.1, player.player.Size, (6 - player.player.Size), 5)
		if math.floor(player.player.Size) == 5 then 
			self.playerCreating = false
			self.tutorialCreating = true
		end
	end

	--Animação Fade Tutorial
	if self.tutorialCreating then
		tuts.alpha = mathFunc:QuadOut(0.1, tuts.alpha, (255 - tuts.alpha), 5)
		if math.floor(tuts.alpha) == 254 then 
			self.tutorialCreating = false
			gameStateValue = 3
		end
	end

end

function CreationPlayer:draw()

	--Desenhar Player
	player:draw()
	
	--Desenhar Enemy
	-- for i,line in ipairs(enemies) do
	-- 	line:draw()
	-- end
	
	--Desenhar Tutorial
	love.graphics.setColor(255,255,255, tuts.alpha)
	local Iw, Ih = tuts.src:getDimensions( )
	love.graphics.draw(tuts.src,tuts.X-(Iw/2), tuts.Y-(Ih/2)) 


end