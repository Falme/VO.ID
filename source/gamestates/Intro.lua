local class = require 'middleclass'

Intro = class('Intro')

function Intro:initialize()

	--Circulos Iniciais, que diminuem repetidamente (Object)
	self.Circles = {}

	--Velocidade dos Circulos para diminuirem
	self.Velocity = 10

	--Contador de Auras a Aparecer
	self.Counter = 20

	--Distancia a aparecer os Circulos
	self.Distance = 50

	--Insercao Inicial, para não obter problema com o IF==0
	table.insert(self.Circles, Circle:new(camera.w/2,camera.h/2,camera.w))
end

function Intro:update(dt)

	--Listar Todos os Circulos
	for i,line in ipairs(self.Circles) do

		--line.Size = line.Size-(self.Velocity/dt)
		line.Size = mathFunc:QuadOut(0.1, line.Size, (0 - line.Size), self.Velocity-(150*dt))

		--Se o tamanho dos Circulos forem 0 || <, sera Destruido
		if line.Size < 1 then
			table.remove(self.Circles, i)
		end

	end

	--Se Nao houver Circulos na Tela
	if table.getn(self.Circles) < 1 then
		
		--CreatingPlayer
		gameStateValue = 2

	else

		--Identificar se Circulos estao com certa distancia
		if self.Circles[table.getn(self.Circles)].Size < camera.w - self.Distance then
			
			--Se Ainda sobrou numero no Contador
			if self.Counter > 0 then
				table.insert(self.Circles, Circle:new(camera.w/2,camera.h/2,camera.w))
				self.Counter = self.Counter - 1
			end
		end

	end

end

function Intro:draw()

	--Desenha todos os Circulos
	for i,line in ipairs(self.Circles) do
		line:draw()
	end

end