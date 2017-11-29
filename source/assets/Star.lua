local class = require '../middleclass'

Star = class('Star')

function Star:initialize()

	--Posicao Central da Camera
	local X, Y = camera.camera:getPosition()

	--Criar Estrela em X,Y Randomico de acordo com a camera
	self.X = math.random(X-(camera.w*2),X+(camera.w*2))
	self.Y = math.random(Y-(camera.h*2),Y+(camera.h*2))

	--Cores das estrelas, inicialmente Branco e invisível
	self.Cor = {
		R=255,
		G=255,
		B=255,
		A=0
	}

	--Estrelas podem ter tamanhos diferentes
	self.Size = math.random(1, 3)

	--Podem brilhar mais também
	self.LifeTime = math.random(5, 10)

	--Se deixou de brilhar e está voltando a ficar invisível
	self.readyToDie = false

	--Caso tenha ficado invisível de novo, destruir para não pesar
	self.Dead = false

end

function Star:update(dt)

	--Se está aparecendo
	if not self.readyToDie then
		self.Cor.A = mathFunc:QuadOut(0.1, self.Cor.A, (255 - self.Cor.A), self.LifeTime)
		if self.Cor.A > 253 then
			self.readyToDie = true
		end

	--Se está desaparecendo
	else
		self.Cor.A = mathFunc:QuadOut(0.1, self.Cor.A, (1 - self.Cor.A), self.LifeTime)
		if self.Cor.A < 3 then
			self.Dead = true
		end
	end

end

function Star:draw()
	love.graphics.setColor(self.Cor.R, self.Cor.G, self.Cor.B, self.Cor.A) 
	love.graphics.rectangle('fill', self.X, self.Y, self.Size, self.Size)
end



