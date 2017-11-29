-- Requires

	require 'assets/Circle'

local class = require '../middleclass'

Aura = class('Aura')

function Aura:initialize(X,Y)

	--Cria a Aura
	self.aura = Circle:new(X, Y, 0)

	--Se Está sendo criado (animacao)
	self.animation = {
		creating = true,
		collecting = false,
		collectedIncreasing = false,
		destroying = false
	}

	--Se pertence ao player: Não Finalizado
	self.followPlayer = false

	--Se pertence ao player: Não Finalizado
	self.followShooter = false

	self.lethal = false

	self.otherside = false

	--Se pertence ao player: Não Finalizado
	self.launched = false

	self.AngleDefenseRotation = 180
	self.AngleLaunch = 0

	self.destroyed = false
	--self.AdicaoAngulo = 0

end

function Aura:update(dt)
	
	--Animações da Aura : 
	-- 1 - Criando Animacao (expand)
	-- 2 - Sendo coletado, vai diminuir até o tamanho minimo dentro do jogador
	-- 3 - Após o tamanho mínimo, cresce e segue o jogador com tamanho normal
	if self.animation.creating then
		self:CreatingAnimation()

	elseif self.animation.collecting then
		self:CollectingAuraAnimation()
		
		if self.aura.Size < 2 then
			self.animation.collecting =false
			self.animation.collectedIncreasing =true
		end

	elseif self.animation.collectedIncreasing then
		self:IncreasingAnimation()
	end

	--Segue o jogador com valores Fixos, a ser modificado.
	if self.followPlayer then
		self.aura.X = mathFunc:QuadOut(0.1, self.aura.X, (player.player.X - self.aura.X), 1)
		self.aura.Y = mathFunc:QuadOut(0.1, self.aura.Y, (player.player.Y - self.aura.Y), 1)
	end

	if self.launched then

		self.aura.X = self.aura.X+10 * math.cos(self.AngleLaunch*(math.pi/180))
		self.aura.Y = self.aura.Y+10 * math.sin(self.AngleLaunch*(math.pi/180))
	end

	if self.animation.destroying then
		self:destroyingAnimation()
	end

end

function Aura:draw()

	self.aura:draw()

end

--Other Functions

function Aura:CreatingAnimation()

	--Aura padrão na criação
	self.aura.Size = mathFunc:QuadOut(0.1, self.aura.Size, (30 - self.aura.Size), 5)

	if math.floor(self.aura.Size) == 29 then
		self.animation.creating = false
	end

end

function Aura:CollectingAuraAnimation()

	self.aura.Size = mathFunc:QuadOut(0.1, self.aura.Size, (1 - self.aura.Size), 5)

end

function Aura:IncreasingAnimation()

	if player.Mode.attack then
		self.aura.Size = mathFunc:QuadOut(0.1, self.aura.Size, (5 - self.aura.Size), 5)

		if not self.launched then
			self.aura.X = self.aura.X+10 * math.sin(self.AngleDefenseRotation * (math.pi / 180))
			self.aura.Y = self.aura.Y+10 * math.cos(self.AngleDefenseRotation * (math.pi / 180))
		end

	elseif player.Mode.defense then
		self.aura.Size = mathFunc:QuadOut(0.1, self.aura.Size, (25 + (10*spaceAura.NumeroAurasColetadas) - self.aura.Size), 5)
	end

end

function Aura:destroyingAnimation()


	if self.aura.Cor.A < 6 then
		self.destroyed = true
	else
		self.aura.Cor.A = self.aura.Cor.A-5
	end

end

function Aura:destroy()

	self.animation.destroying = true


end