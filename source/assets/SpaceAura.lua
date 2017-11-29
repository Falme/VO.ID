-- Requires

	require 'assets/Aura'
	require 'assets/Wave'

local class = require '../middleclass'

SpaceAura = class('SpaceAura')

function SpaceAura:initialize()

	--Tabela de Auras
	self.Auras = {}

	--Tabela de Auras Coletadas
	self.CollectedAuras = {}

	--Quantas auras foram coletadas
	self.NumeroAurasColetadas = 0

	--Limite de Auras
	--self.maxAuras = 10

	--Adiciona uma nova aura para o tutorial
	local X,Y = camera.camera:getPosition()
	table.insert(self.Auras, Aura:new(X+35,Y-190))
	
	--table.insert(self.Auras, Aura:new(X+125,Y-190))
	--table.insert(self.Auras, Aura:new(X+225,Y-200))
	--table.insert(self.Auras, Aura:new(X+325,Y-310))
	--table.insert(self.Auras, Aura:new(X+425,Y-420))

	self.AdicaoAngulo = 0

	--Sonar
	self.Wave = nil

	--Sonar Inicial:Demonstrativo
	self:Sonar()

end

function SpaceAura:update(dt)
	
	--Reseta as auras coletadas
	self.NumeroAurasColetadas = 0

	self.AdicaoAngulo = self.AdicaoAngulo+1

	--Update Padrão das Auras
	for i, auras in ipairs(self.Auras) do

		if mathFunc:GetDistance(player.player, auras.aura) < (camera.w*1.5) then
			auras:update(dt)
		end

		--Se Player Colidir com a Aura
		if mathFunc:GetDistance(player.player, auras.aura) - (auras.aura.Size + player.player.Size) < 0 and not auras.followPlayer and not auras.launched then
			tuts.learned = true
			auras.animation.collecting = true
			auras.followPlayer = true
			self:CreateRaioAura()
		end

		--Contar quantas foram coletadas
		if auras.followPlayer then
			self.NumeroAurasColetadas = self.NumeroAurasColetadas + 1
		end

		--Se Foi Destruída
		if auras.destroyed then
			table.remove(self.Auras, i)
		end

		--Se Foi Lançada pra fora da tela
		if auras.launched and mathFunc:GetDistance(player.player, auras.aura) > (camera.w*1.5) then
			table.remove(self.Auras, i)
		end

	end

	--Se Wave Não for nil(caso exista), rodar update()
	if self.Wave then
		self.Wave:update(dt)
	end

	--Verifica se Existe numero limite de Auras
	--self:VerifyLimitAuras()

	self:SpinAurasAtaque()

end

function SpaceAura:draw()

	--Desenha Auras
	for i, auras in ipairs(self.Auras) do
		if mathFunc:GetDistance(player.player, auras.aura) < (camera.w*1.5) then
			auras:draw()
		end
	end
	
	--love.graphics.print(Joystick:getAxes( ), 0, 0)
	--love.graphics.print(table.getn(self.CollectedAuras), 0, 200)
	--Se Wave existir, Desenhe-o
	if self.Wave then
		self.Wave:draw()
	end



end

--Outras funcoes

function SpaceAura:Sonar()

	--Caso caso exista alguma Aura na tela e caso não exista um Sonar Ativo
	if table.getn(self.Auras) > 0 and not self.Wave then

		--Criar Sonar na Aura mais proxima
		local found = self.Auras[self:ClosestAura()]
		self.Wave = Wave:new(found.aura.X,found.aura.Y)
		if mathFunc:GetDistance(self.Wave.wave, player.player) > camera.w then
			self.Wave.wave.Size = (mathFunc:GetDistance(self.Wave.wave, player.player) - (camera.w/1.5))
		end
	end

end

function SpaceAura:LaunchAura(Valor)

	self.CollectedAuras[Valor].followPlayer = false
	self.CollectedAuras[Valor].launched = true
	self.CollectedAuras[Valor].AngleLaunch = mathFunc:GetAngleTwoPoints(self.CollectedAuras[Valor].aura, alvo.alvoCirculo)
	--self.CollectedAuras[Valor].AngleDefenseRotation = mathFunc:GetAngleTwoPoints(player.player, alvo.alvoCirculo)
	print(self.CollectedAuras[Valor].AngleDefenseRotation)
end

function SpaceAura:ResetCollectedAuras()

	self.CollectedAuras = {}
	
	for i, auras in ipairs(self.Auras) do
		if auras.followPlayer == true then
			table.insert(self.CollectedAuras, auras)
		end
	end

end

--Qual Aura está mais proxima
function SpaceAura:ClosestAura()

	-- 1 para segurança
	local NearestID = 1
	local Nearestobj = camera.w*50

	-- Verificar se a Aura anterior está mais longe que a proxima, caso sim, substituir Nearest
	for i, auras in ipairs(self.Auras) do
		--if i < table.getn(self.Auras) then
			if mathFunc:Distance(player.player, auras.aura) < Nearestobj and not auras.followPlayer and not auras.launched then
				NearestID = i
				Nearestobj = mathFunc:Distance(player.player, auras.aura)
			end
		--end
	end

	return NearestID

end


-- Verifica se Alguma Aura foi coletada pelo player
function SpaceAura:VerificaAuraColetada()

	--Caso encontre alguma aura, retorna True, se não achar, 
	--Passa direto e retorna False
	for i, auras in ipairs(self.Auras) do
		if auras.followPlayer then
			return true
		end
	end
	
	return false

end


--Funcao de verificação se há maxAuras na tela
function SpaceAura:VerifyLimitAuras()

	--TODO : Fazer com que as auras criadas não estejam proximas da camera nem umas das outras
	if table.getn(self.Auras) < self.maxAuras then
		table.insert(self.Auras, Aura:new(math.random(-camera.w*20, camera.w*50),math.random(-camera.h*20, camera.h*50)))
	end
end

function SpaceAura:refreshAurasColetadas()
	if player.Mode.attack then
	
	elseif player.Mode.defense then
	    
	end
end


function SpaceAura:SpinAurasAtaque()
	local n = 0;
	for i, auras in ipairs(self.Auras) do
		if auras.followPlayer then
			n = n+1
			--auras.AngleDefenseRotation = (n*((auras.AngleDefenseRotation+self.AdicaoAngulo)/self.NumeroAurasColetadas))
			if not auras.launched then
				auras.AngleDefenseRotation = (n*(360/self.NumeroAurasColetadas))+self.AdicaoAngulo
			end
		end
	end


end


function SpaceAura:CreateRaioAura()
	local angus = math.random(1, 360)
	local distanceCreate = camera.w * math.random(1.5 , 2.5)
	local xAura = player.player.X+(distanceCreate) * math.sin(angus * (math.pi/ 180))
	local yAura = player.player.Y+(distanceCreate) * math.cos(angus * (math.pi/ 180))
	table.insert(self.Auras, Aura:new(xAura,yAura))
end