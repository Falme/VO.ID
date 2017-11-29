-- Requires

	require 'assets/Circle'

local class = require '../middleclass'

Wave = class('Wave')

function Wave:initialize(X,Y)

	--Cria o Sonar
	self.wave = Circle:new(X, Y, 0)

	--Se Está desaparecendo (animacao) : Fading Out
	self.dying = false

end

function Wave:update(dt)
	
	--Sempre Crescendo
	self:IncreasingSize(dt)

	--Animacao FadeOut
	if self.dying then
		self:FadingOut()
	end

	--Se há colisão com o player
	if mathFunc:GetDistance(player.player, self.wave) - (self.wave.Size + player.player.Size) < 0 then
		self.dying = true
	end

	--Ao desaparecer, Auto Destruir
	if self.wave.Cor.A < 2 then
		spaceAura.Wave = nil
	end

end

function Wave:draw()

	self.wave:draw()

end

--Other Functions

function Wave:IncreasingSize(dt)

	--Aumenta de acordo com o Delta Time
	self.wave.Size = self.wave.Size + (300*dt)

end

function Wave:FadingOut()

	--Fading out Quad tween
	self.wave.Cor.A = mathFunc:QuadOut(0.1, self.wave.Cor.A, (1 - self.wave.Cor.A), 5)
	
end