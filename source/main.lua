--Requires

	--Anothers
	require 'GameCamera'
	require 'MateFunc'

	--Assets
	require 'assets/Circle'
	require 'assets/SpaceStars'
	require 'assets/Star'

	--GameStates
	require 'gamestates/MainMenu'
	require 'gamestates/Intro'
	require 'gamestates/CreationPlayer'
	require 'gamestates/Gameplay'

function love.load()

	--Settings Variables

	--Joystick
	p1joystick = nil

	test = ""

	math.randomseed(os.time())

		--Game State Idle
		--gameStateValue = 0
		gameStateValue = 2

		-- Hiding Mouse
		love.mouse.setVisible(false)

	--Setting Window

		--width and height of desktop
		local w,h = love.window.getDesktopDimensions(1)

		--set Size to Window application
		love.window.setMode(w,h, {resizable=false, borderless=true, highdpi=true })


	--Calling Classes

		--Camera
		camera = GameCamera:new()

		--Math
		mathFunc = MateFunc:new()

		--Assets
		spaceStars = SpaceStars:new()

		--GameStates Classes
		mainMenu = MainMenu:new()
		intro = Intro:new()
		creationPlayer = CreationPlayer:new()
		gameplay = Gameplay:new()

end


function love.update(dt)

	--MainMenu
	if gameStateValue == 0 then
		mainMenu:update(dt)
		spaceStars.CreatingStars = false

	--Intro
	elseif gameStateValue == 1 then
		intro:update(dt)
		spaceStars.CreatingStars = false

	--CreationPlayer
	elseif gameStateValue == 2 then
		creationPlayer:update(dt)
		spaceStars.CreatingStars = true

	--Gameplay
	elseif gameStateValue == 3 then
		gameplay:update(dt)
	end

	spaceStars:update(dt)

end


function love.draw()

	camera.camera:draw(function() 

		--MainMenu
		if gameStateValue == 0 then
			mainMenu:draw()

		--Intro
		elseif gameStateValue == 1 then
			intro:draw()

		--CreationPlayer
		elseif gameStateValue == 2 then
			creationPlayer:draw()

		--Gameplay
		elseif gameStateValue == 3 then
			gameplay:draw()
	
		end

		spaceStars:draw()
			
	end)


	
end


--KeyboardGeneral : 

	function love.keypressed(k)
   
		if k == 'escape' then
	    	love.event.quit()
	   	end

		
	   	--MainMenu
		if gameStateValue == 0 then

			--Ativar Fading/out do menu inicial
			mainMenu.Fading = true

		--Gameplay
		elseif gameStateValue == 3 then

			--Tecla para ativar Sonar
			if k == ' ' then
	    		spaceAura:Sonar()
	   		end

		end

	end


--Mouse General :

	function love.mousepressed(x, y, button)

		--MainMenu
		if gameStateValue == 0 then

			--Ativar Fading/out do menu inicial
			mainMenu.Fading = true

		end

		if button == 'r' then

			if player.Mode.attack then
				player.Mode.attack = false
				player.Mode.defense = true
				
			elseif player.Mode.defense then
			    player.Mode.attack = true
				player.Mode.defense = false
				
			end

		elseif button == 'l' then

			if player.Mode.attack then
				player:Launch()
			end

		end

	end


--Joystick General

function love.joystickadded(joystick)
    p1joystick = joystick
end

function love.joystickpressed(joystick,button)

	--MainMenu
	if gameStateValue == 0 then

		--Ativar Fading/out do menu inicial
		mainMenu.Fading = true

	end

   	if button == 1 then
   		spaceAura:Sonar()
	 elseif button == 2 then
	 	if player.Mode.attack then
			player:Launch()
		end
	 elseif button == 4 or button == 5 or button == 6 then
	 	if player.Mode.attack then
			player.Mode.attack = false
			player.Mode.defense = true
			
		elseif player.Mode.defense then
		    player.Mode.attack = true
			player.Mode.defense = false
			
		end
	 end
end


function love.joystickaxis( joystick, axis, value )

	if (axis == 3 or axis == 6) and value == 1 then
		if player.Mode.attack then
			player:Launch()
		end

	end

end