-- Requires

local class = require '../middleclass'

HeadEnemy = class('HeadEnemy')

function HeadEnemy:initialize(X,Y,velocity)

	self.position ={ X=X, Y=Y}
	self.TopHand = {X=0, Y=0}
	self.BottomHand = {X=0, Y=0}
	self.Angle = 0
	self.Alpha = 255
	self.followingPlayer = true
	self.timeScared = 0
	self.velocity = velocity

end

function HeadEnemy:update(dt)

	self.position.X = self.position.X+(2*(self.velocity*0.25)) * math.cos(self.Angle*(math.pi/180))
	self.position.Y = self.position.Y+(2*(self.velocity*0.25)) * math.sin(self.Angle*(math.pi/180))

	self.TopHand.X, self.TopHand.Y = (self.position.X+10 * math.cos(90+self.Angle*(math.pi/180))), (self.position.Y+10 * math.sin(90+self.Angle*(math.pi/180)))
	self.BottomHand.X, self.BottomHand.Y = (self.position.X+10 * math.cos(-90+self.Angle*(math.pi/180))), (self.position.Y+10 * math.sin(-90+self.Angle*(math.pi/180)))
	
	
	--Caso Enemy Está ou não seguindo o jogador
	if self.followingPlayer and player.Alive then
		self.Angle = mathFunc:GetAngleTwoPoints(self.position, player.player)
	elseif not self.followingPlayer and player.Alive then
		self.Angle = mathFunc:GetAngleTwoPoints(self.position, player.player)-180
		self.timeScared = self.timeScared-1
		if self.timeScared < 0 then
			self.followingPlayer = true
		end
	elseif not player.Alive then
		self.Angle = self.Angle
	end
	
end

function HeadEnemy:draw()

		self.Draws ={
			(self.position.X+10 * math.cos(90+self.Angle*(math.pi/180))), (self.position.Y+10 * math.sin(90+self.Angle*(math.pi/180))),
			(self.position.X+15 * math.cos(0+self.Angle*(math.pi/180))), (self.position.Y+15 * math.sin(0+self.Angle*(math.pi/180))),
			(self.position.X+10 * math.cos(-90+self.Angle*(math.pi/180))), (self.position.Y+10 * math.sin(-90+self.Angle*(math.pi/180))),
			(self.position.X+10 * math.cos(90+self.Angle*(math.pi/180))), (self.position.Y+10 * math.sin(90+self.Angle*(math.pi/180)))
		}

		love.graphics.print(""..self.position.X,0,-20)
		love.graphics.setColor(255, 255, 255, self.Alpha)
		love.graphics.line(self.Draws)

end

function HeadEnemy:Scared()

	self.timeScared = 150
	self.followingPlayer = false
end