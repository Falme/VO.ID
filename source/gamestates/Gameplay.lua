-- Requires

	require 'assets/Alvo'
	require 'assets/SpaceAura'

local class = require '../middleclass'

Gameplay = class('gameplay')

function Gameplay:initialize()
	
	--Criar Alvo
	alvo = Alvo:new()
	player.canMove=true
	spaceAura = SpaceAura:new()


end

function Gameplay:update(dt)

	alvo:update(dt)
	player:update(dt)

	spaceAura:update(dt)
	enemies:update(dt)
	
	camera:FollowPlayer()

	--Se o player pegou a primeira aura
	if tuts.learned then
		if tuts.alpha > 2 then
			tuts.alpha = mathFunc:QuadOut(0.1, tuts.alpha, (1 - tuts.alpha), 5)
		else
			tuts.alpha = 0
		end
	end

end

function Gameplay:draw()

	--Desenha Alvo:Mouse
	alvo:draw()

	--Desenha jogador
	player:draw()

	--Todas As Auras
	spaceAura:draw()


	--Todas As enemies
	enemies:draw()
	
	--Desenhar Tutorial
	love.graphics.setColor(255,255,255, tuts.alpha)
	local Iw, Ih = tuts.src:getDimensions( )
	love.graphics.draw(tuts.src,tuts.X-(Iw/2), tuts.Y-(Ih/2)) 


end

