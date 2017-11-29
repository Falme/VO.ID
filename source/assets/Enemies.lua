-- Requires

	require 'assets/CrawlerEnemy'
	require 'assets/ShooterEnemy'

local class = require '../middleclass'

Enemies = class('Enemies')

function Enemies:initialize(X,Y, nodes, type)

	self.SpaceCrawler = {}
	self.SpaceShooter = {}

	--Maximo de Inimigos
	-- 1 : Crawler
	-- 2 : Shooter
	self.maxEnemies = {1,1}

end

function Enemies:update(dt)

	for i, Crawlers in ipairs(self.SpaceCrawler) do
		if mathFunc:GetDistance(player.player, Crawlers.head.position) < (camera.w*2.5) then
			Crawlers:update(dt)
		end

		if Crawlers.Destroyed then
			table.remove(enemies, i)
		end
	end

	for i, Shooter in ipairs(self.SpaceShooter) do
		Shooter:update(dt)
	end

	self:VerifyLimitEnemies()

end

function Enemies:draw()

	for i, Crawlers in ipairs(self.SpaceCrawler) do
		if mathFunc:GetDistance(player.player, Crawlers.head.position) < (camera.w*2) then
			Crawlers:draw(dt)
		end

		--Matar Player ao colidir
		if mathFunc:GetDistance(Crawlers.head.position, player.player) < 20 then
			player.Alive = false
		end
	end

	for i, Shooter in ipairs(self.SpaceShooter) do
		if mathFunc:GetDistance(player.player, Shooter) < (camera.w*2) then
			Shooter:draw(dt)
		end
		--Matar Player ao colidir
		if mathFunc:GetDistance(Shooter, player.player) < 20 then
			player.Alive = false
		end
	end



end

--Funcao de verificação se há maxAuras na tela
function Enemies:VerifyLimitEnemies()

	--TODO : Fazer com que as auras criadas não estejam proximas da camera nem umas das outras
	if table.getn(self.SpaceCrawler) < self.maxEnemies[1] then
		--table.insert(self.SpaceCrawler, CrawlerEnemy:new(math.random(-camera.w+20, camera.w+50),math.random(-camera.h+20, camera.h+50),math.random(4, 7)))
		table.insert(self.SpaceCrawler, CrawlerEnemy:new(math.random(-camera.w*20, camera.w*50),math.random(-camera.h*20, camera.h*50),math.random(4, 7)))
	end

	--TODO : Fazer com que as auras criadas não estejam proximas da camera nem umas das outras
	if table.getn(self.SpaceShooter) < self.maxEnemies[2] then
		--table.insert(self.SpaceShooter, ShooterEnemy:new(math.random(-camera.w*20, camera.w*50),math.random(-camera.h*20, camera.h*50),math.random(1, 7)))
		table.insert(self.SpaceShooter, ShooterEnemy:new(math.random(120, 150),math.random(120, 150),math.random(6, 7)))
	end
end