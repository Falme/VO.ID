-- Requires

	require 'assets/HeadEnemy'
	require 'assets/BodyEnemy'

local class = require '../middleclass'

CrawlerEnemy = class('CrawlerEnemy')

function CrawlerEnemy:initialize(X,Y, nodes)

	self.head = HeadEnemy:new(X+100,Y+100, nodes)

	self.body = BodyEnemy:new(X+self.head.position.X,Y+self.head.position.Y,nodes, self.head)

	self.Alive = true
	self.Destroyed = false

end

function CrawlerEnemy:update(dt)


		if self.Alive then
			self.head:update(dt)
			self.body:update(dt)
		elseif not self.Alive and not self.Destroyed then
			self:death()
		end


	for i, auras in ipairs(spaceAura.Auras) do
		
		if mathFunc:GetDistance(self.head.position, auras.aura) - (15 + player.player.Size) < 0 and auras.launched then
			self.Alive = false
		elseif mathFunc:GetDistance(self.head.position, auras.aura) - (15 + auras.aura.Size) < 0 and auras.followPlayer and player.Mode.defense then
			self.head:Scared()
			auras:destroy()
		elseif mathFunc:GetDistance(self.head.position, auras.aura) - (15 + auras.aura.Size) < 0 and auras.followPlayer and player.Mode.attack then
			auras:destroy()
		end

	end
	

end

function CrawlerEnemy:draw()

		self.head:draw()
		self.body:draw()

end


function CrawlerEnemy:death()

	self.head.Alpha = self.head.Alpha -5

	for i=1,self.body.Tamanho do
		self.body.BodyTop[i].Cor.A = self.body.BodyTop[1].Cor.A -5
	end

	if self.head.Alpha < 6 then
		self.Destroyed = true
	end

end
