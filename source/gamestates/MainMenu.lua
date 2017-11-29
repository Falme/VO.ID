local class = require '../middleclass'

MainMenu = class('MainMenu')

function MainMenu:initialize()

	--Opacidade Das Letras
	self.Alpha = 255

	--Ativado/Desativado FadingOut : Transicao para Intro(GameState:1)
	self.Fading = false

end

function MainMenu:update(dt)

	--Animação de FadeOut
	if self.Fading then 
		if self.Alpha > 5 then
			--TODO : TweenMotion
			self.Alpha = mathFunc:QuadOut(0.1, self.Alpha, (1 - self.Alpha), 150* dt)
			--self.Alpha = self.Alpha - 100* dt
		else
			--Transicao para Intro
			gameStateValue = 1
		end
	end

end

function MainMenu:draw()

	local fontSize = 12

	--Se Altura>Largura, caso PC esteja na vertical
	if camera.h > camera.w then
		fontSize = (camera.w-30)/2
	else	
		fontSize = (camera.h-30)/2
	end
	
	--Nome do Jogo, FonteSize = Metade da Altura Desktop
	local font = love.graphics.newFont(mathFunc:PxToPt(fontSize))
	love.graphics.setFont(font)
	love.graphics.setColor(255, 255, 255, self.Alpha)

	love.graphics.print("V", camera.w/4,0)
	love.graphics.print("O", camera.w/1.5,0)
	love.graphics.print("I", camera.w/4,camera.h/2)
	love.graphics.print("D", camera.w/1.5,camera.h/2)

	--Criadores : Falme Streamless (Guaxinim Games)
	local fontSize = 16
	local font = love.graphics.newFont(fontSize)
	love.graphics.setFont(font)
	love.graphics.print("@Falme73h",0,camera.h - (mathFunc:PtToPx(fontSize)))
	love.graphics.print("Guaxinim Games", (camera.w/2) - (mathFunc:PtToPx(fontSize)*7), camera.h - (mathFunc:PtToPx(fontSize)))
	love.graphics.print("@GamesGuaxinim", camera.w - (mathFunc:PtToPx(fontSize)*7), camera.h - (mathFunc:PtToPx(fontSize)))


end