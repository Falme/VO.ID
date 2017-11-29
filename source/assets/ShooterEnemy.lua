-- Requires

	--require 'assets/HeadEnemy'
	--require 'assets/BodyEnemy'

local class = require '../middleclass'

ShooterEnemy = class('ShooterEnemy')

function ShooterEnemy:initialize(X,Y, nodes)

	self.X = X
	self.Y = Y

	self.Angle = 0
	self.nodes = nodes

	self.numberBullets = nodes

	self.AdicaoAngulo = 0

	self.ShootingPlayer = true

	self.Animation = {
		CreatingBullets = false
	}

	--self.body = BodyEnemy:new(X+self.X,Y+self.Y,nodes, self.head)

	self.bullets = {}

	self.Cor = {
		R=255,
		G=255,
		B=255,
		A=255
	}

	self.Alive = true
	self.Destroyed = false

	self:CreateBullets()

end

function ShooterEnemy:update(dt)

	self.X = self.X+(2*(self.nodes*0.05)) * math.cos(self.Angle*(math.pi/180))
	self.Y = self.Y+(2*(self.nodes*0.05)) * math.sin(self.Angle*(math.pi/180))

	self:updateBullets()


	if self.Alive then
		--self.body:update(dt)
	elseif not self.Alive and not self.Destroyed then
		self:death()
	end



	--Caso Enemy Está ou não seguindo o jogador
	if player.Alive then
		self.Angle = mathFunc:GetAngleTwoPoints(self, player.player)
	elseif not player.Alive then
		self.Angle = self.Angle
	end
	

	

	if table.getn(self.bullets) == 0 then
		self:CreateBullets()
	end



end

function ShooterEnemy:draw()


	love.graphics.setColor(self.Cor.R, self.Cor.G, self.Cor.B, self.Cor.A) 
	love.graphics.rectangle("line", self.X-10, self.Y-10, 20, 20)

	for i, Bullets in ipairs(self.bullets) do
		Bullets:draw()
	end
	--self.body:draw()

end


function ShooterEnemy:death()

	self.Cor.A = self.Cor.A -5

	-- for i=1,self.body.Tamanho do
	-- 	self.body.BodyTop[i].Cor.A = self.body.BodyTop[1].Cor.A -5
	-- end

	if self.Cor.A < 6 then
		self.Destroyed = true
		self.Cor.A = 0

		for i, bullets in ipairs(self.bullets) do
			
			if not bullets.launched then
				table.insert(spaceAura.Auras, Aura:new(bullets.aura.X,bullets.aura.Y))
			end

		end
		-- for i, bullets in ipairs(self.bullets) do
		-- 	bullets = nil
		-- end

		--table.remove(self.bullets)

	end

end

function ShooterEnemy:updateBullets()

	-- Adiciona ao contador o angulo diferencial (Giro de cada)
	self.AdicaoAngulo = self.AdicaoAngulo+1


	--contador total para divisao perfeita
	local adicao = 0

	--Liste todos os Bullets do Shooter
	for i, bullets in ipairs(self.bullets) do

		-- Faça com que as balas tenham 5*2 de diâmetro
		bullets.aura.Size = mathFunc:QuadOut(0.1, bullets.aura.Size, (5 - bullets.aura.Size), 3)

		if not bullets.launched then
			adicao=adicao+1
		end

		-- Em que posição certo bullet está em relação ao Shooter
		bullets.AngleDefenseRotation = (adicao*(360/self.numberBullets))+self.AdicaoAngulo
		
		-- Set X e Y em relação ao angulo de rotação em relação ao Shooter
		local X,Y = self.X+40 * math.sin(bullets.AngleDefenseRotation * (math.pi / 180)), self.Y+40 * math.cos(bullets.AngleDefenseRotation * (math.pi / 180))

		-- Se não foram lançadas, será rodeada em torno do Shooter
		if not bullets.launched then
			
			bullets.aura.X = mathFunc:QuadOut(0.1, bullets.aura.X, (X - bullets.aura.X), 3)
			bullets.aura.Y = mathFunc:QuadOut(0.1, bullets.aura.Y, (Y - bullets.aura.Y), 3)
			

		-- Caso seja lançado e tenha sido repelido pelo bloqueio do jogador 
		elseif bullets.launched and bullets.otherside then
			bullets.aura.X = bullets.aura.X+10 * math.cos((bullets.AngleLaunch-180)*(math.pi/180))
			bullets.aura.Y = bullets.aura.Y+10 * math.sin((bullets.AngleLaunch-180)*(math.pi/180))

			if mathFunc:GetDistance(bullets.aura, self) < 10 then
				self.Alive = false
			end

		-- Caso seja lançado, somente 
		elseif bullets.launched and not bullets.otherside then
			bullets.aura.X = bullets.aura.X+10 * math.cos(bullets.AngleLaunch*(math.pi/180))
			bullets.aura.Y = bullets.aura.Y+10 * math.sin(bullets.AngleLaunch*(math.pi/180))
		end


		-- Caso o bullets esteja longe do player a ponto de ser destruído
		if mathFunc:GetDistance(player.player, bullets.aura) > (camera.w*1.5) then

			-- Remove o bullet
			table.remove(self.bullets, i)

		end


		-- Caso o bullet colida com o player, o player irá morrer
		if mathFunc:GetDistance(bullets.aura, player.player) < 20 then
	   		player.Alive = false
	   	end

	   	
	   	for j, Crawlers in ipairs(enemies.SpaceCrawler) do

			-- Caso o bullet colida com o Crawler, o Crawler irá morrer
			if mathFunc:GetDistance(bullets.aura, Crawlers.head.position) < 20 then
	   			Crawlers.Alive = false
	   		end

	   	end


		-- if mathFunc:GetDistance(player.player, self) < camera.h then
		-- 	self.ShootingPlayer = true
		-- else
		-- 	self.ShootingPlayer = false
		-- end


		--Checar todas as auras
	   	for i, auras in ipairs(spaceAura.Auras) do

	   		-- se a distancia entre bullets e as Auras gerais
	   		if mathFunc:GetDistance(bullets.aura, auras.aura) - (10 + auras.aura.Size) < 0 and player.Mode.defense then
	   			-- Seta o angulo para o "oposto do player"
	   			bullets.AngleLaunch = mathFunc:GetAngleTwoPoints(bullets.aura, auras.aura)
	   			-- Seta para que esteja indo para direção oposta do jogador
	   			bullets.otherside = true
	   		end
	   	end


	   	if self.ShootingPlayer then
			if not bullets.launched and math.floor(mathFunc:GetAngleTwoPoints(bullets.aura, player.player)) == math.floor(mathFunc:GetAngleTwoPoints(self, bullets.aura)) then
			--if 1==2 then	
				self.numberBullets = self.numberBullets - 1
				bullets.launched = true
				bullets.AngleLaunch = mathFunc:GetAngleTwoPoints(bullets.aura, player.player)
			end

		end



	end


end

function ShooterEnemy:CreateBullets()

	self.Animation.CreatingBullets = true

	for i=1,self.nodes do
		table.insert(self.bullets, Aura:new(self.X, self.Y))
	end

	for i, Bullets in ipairs(self.bullets) do
		self.bullets.followShooter = true
		self.bullets.lethal = true
	end

	self.numberBullets = self.nodes

end

function ShooterEnemy.remove(self)
    self = nil
end