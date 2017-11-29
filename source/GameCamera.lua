local class = require 'middleclass'

local gamera = require 'gamera'

GameCamera = class('GameCamera')

function GameCamera:initialize()

	--Setar Width e Height da tela do monitor
	self.w,self.h = love.graphics.getWidth(),love.graphics.getHeight()

	--Seta nova camera com a resolucao da tela
	self.camera = gamera.new(0,0,self.w,self.h)

	--Cria um mundo e janela de acordo com a tela do monitor
	self.camera:setWorld(-self.w*20,-self.h*20,self.w*50,self.h*50)
	self.camera:setWindow(0,0,self.w,self.h)
end


function GameCamera:update()

end


function GameCamera:draw()

end

function GameCamera:FollowPlayer()

	--Fazer com que a camera siga o jogador
	local X,Y = self.camera:getPosition()
	self.camera:setPosition(mathFunc:QuadOut(0.1, X, (player.player.X - X), 0.1), mathFunc:QuadOut(0.1, Y, (player.player.Y - Y), 0.1))

end

function GameCamera:GetY()
	local _,Y = self.camera:getPosition()
 return Y
end

function GameCamera:GetX()
	local X,_ = self.camera:getPosition()
 return X
end

function GameCamera:GetCameraPosition()

	local x,y = self.camera:getPosition()
	local _,_,w,h = self.camera:getWindow()

	return (x-(w/2)),(y-(h/2))
end