local class = require '../middleclass'

Circle = class('Circle')

function Circle:initialize(X,Y,Size)
	self.X = X
	self.Y = Y
	self.Size = Size
	self.Type = 'line'
	self.Cor = {
		R=255,
		G=255,
		B=255,
		A=255
	}

	--self.Uping = true

end

function Circle:update()
	-- body
end

function Circle:draw()
	
	love.graphics.setColor(self.Cor.R, self.Cor.G, self.Cor.B, self.Cor.A) 
	love.graphics.circle(self.Type, self.X, self.Y, self.Size, 100)
end