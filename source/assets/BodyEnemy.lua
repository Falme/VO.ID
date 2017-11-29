-- Requires

	require 'assets/Circle'

local class = require '../middleclass'

BodyEnemy = class('BodyEnemy')

function BodyEnemy:initialize(X,Y,numero,head)

	self.Tamanho = numero
	self.X = X
	self.Y = Y
	self.BodyTop ={}
	self.BodyBottom ={}
	self.Rotation = 90
	self.head = head
	self.Oscilation = 0

	for i=1,self.Tamanho do
		table.insert(self.BodyTop, Circle:new(self.X-(10*i),self.Y+10,3));
		table.insert(self.BodyBottom, Circle:new(self.X-(10*i),self.Y+10,3));
	end


end

function BodyEnemy:update(dt)

	self.Oscilation = self.Oscilation+1

	for i=1,self.Tamanho do
	
		if self.Oscilation % 2 == 0 then
			self.BodyTop[i].Y =  (self.head.TopHand.Y +(10*i) * math.sin((self.head.Angle-180) * (math.pi / 180)))
			self.BodyTop[i].X =  (self.head.TopHand.X-(10*i) * math.cos(self.head.Angle * (math.pi / 180)))
		else
			self.BodyTop[i].Y =  (self.head.BottomHand.Y +(10*i) * math.sin((self.head.Angle-180) * (math.pi / 180)))
			self.BodyTop[i].X =  (self.head.BottomHand.X-(10*i) * math.cos(self.head.Angle * (math.pi / 180)))
		end


	end
end

function BodyEnemy:draw()

	for i=1,self.Tamanho do
		self.BodyTop[i]:draw()
		--self.BodyBottom[i]:draw()
	end

end

--Other Functions

function BodyEnemy:moveForward(angle)

	
end
