require 'assets/Star'

local class = require '../middleclass'

SpaceStars = class('SpaceStars')

function SpaceStars:initialize()
	
	--Tabela das estrelas na tela
	self.Stars = {}

	--Numero Maximo de Estrelas
	self.NumberStars = 500

	--Se está sendo criado Estrelas
	self.CreatingStars = true

end

function SpaceStars:update(dt)

	--Se Numeros de Estrela na tela for menor que o NumberStars (500), então crie uma nova
	if table.getn(self.Stars) < self.NumberStars and self.CreatingStars then
		table.insert(self.Stars, Star:new())
	end

	--For:Update padrão das estrelas
	for i, estrelas in ipairs(self.Stars) do

		estrelas:update(dt)

		--Caso alguma delas esteja invisível/Morta/FadedOut, destruir Estrela
		if estrelas.Dead then
			table.remove(self.Stars, i)
		end
	end

end

function SpaceStars:draw()
	for i, estrelas in ipairs(self.Stars) do
		estrelas:draw()
	end
end


