enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage('alien.png')
particle_system = {}
particle_system.list = {}
particle_system.image = love.graphics.newImage('alien_death.png')
level_counter = 1


--[[function particle_Systems:spawn(x, y)
    local ps = {}
    ps.x = x
    ps.y = y
    ps.ps = love.graphics.newParticleSystem(particle_system.image,32)
    ps.ps:setParticleLifetime(2,4)
    ps.ps:setEmissionRate(5)
    ps.ps:setSizeVariation(1)
    ps.ps:setLinearAcceleration(-20,-20,20,20)
    ps.ps:setColors(100,255,100,255,0,255,0, 255)
    table.insert(particle_system.list, ps)
end

function particle_Systems:draw()
  for _, v in pairs(particle_system.list) do
    love.graphics.draw(v.ps, v.x, v.y)
  end
end

function particle_Systems:update(dt)
  for _, v in pairs(particle_system.list) do
    v.ps:update(dt)
  end
end

function particle_Systems:cleanup()
  --delete particles systems
end]]--

--hash bucket collision detectiong for more optimized and efficient

--Checks every enemy bullet (unoptimized)
function checkCollisions(enemies, bullets, death)
  for i, e in ipairs(enemies) do
    for k, b in ipairs (bullets) do
      if b.y <= e.y + e.height and b.x > e.x and b.x < e.x +e.width then
        --particle_system:spawn(e.x,e.y)
        table.remove(enemies, i)
        table.remove(bullets , k)
        love.audio.play(death)
      end
    end
  end
end


--Basically main function----------------
function love.load()-----------------------------------------------------------LOAD--------------------------------------------------------
  game_over = false
  
-------------MUSIC-----------------------------------------------------------
  local music = love.audio.newSource('Blip_Stream.mp3', 'stream')
  music:setLooping(true)
  love.audio.play(music)
      
  
      player = {} 
      player.x = 350
      player.y = 570
      player.bullets = {}
      player.speed = 5
      player.cooldown = 20
      player.fire_sound = love.audio.newSource('alien_hit.mp3', 'static')
      player.fire = function()
            if player.cooldown <= 0 then
              love.audio.play(player.fire_sound)
              player.cooldown = 20
              bullet = {}
              bullet.x = player.x + 45
              bullet.y = player.y
              table.insert(player.bullets, bullet)
            end
      end

      enemy_hit = love.audio.newSource('collide.wav', 'static')
      background = love.graphics.newImage('background.png')
      --Enemies Spawner--------------------------
      for i=0,7 do
        enemies_controller:spawnEnemy(0+i*100,0)
      end
      
    title = love.graphics.newImage('menu_title.png')
end
--End of Load-------------------------------



--":" passes value self which uses the function on the value that called it instead of all teh values--
function enemy:fire()
        if self.cooldown <= 0 then
              self.cooldown = 10
              bullet = {}
              bullet.x = self.x + 45  
              bullet.y = self.y
              table.insert(self.bullets, bullet)
        end
end

--spawn enemies---------------------------------------------
function enemies_controller:spawnEnemy(x, y)
        enemy = {}
        enemy.x = x
        enemy.y = y
        enemy.width = 70
        enemy.height = 45
        enemy.bullets = {}
        enemy.speed = 1
        enemy.cooldown = 20
        table.insert(self.enemies, enemy)
  end

function love.update(dt)----------------------------------------------------------UPDATE------------------------------------------

if level_counter >= 1 then
  
  end
-----Game Logic------------------------------------------------------
if #enemies_controller.enemies == 0 and level_counter == 2 then
  --win condition
  game_win = true
end
for _, e in pairs(enemies_controller.enemies) do
  
end

--Collision Detection------------------------------------------      
        checkCollisions(enemies_controller.enemies, player.bullets, enemy_hit)


--Movement-----------------------------------------------------
        if love.keyboard.isDown("left") and player.x ~=-50 then
          player.x = player.x - player.speed
        end
        if love.keyboard.isDown("right") and player.x ~=750 then
          player.x = player.x + player.speed
        end
        if love.keyboard.isDown("tab") then
          game_win = true
        end
        if love.keyboard.isDown("`") then
            level_counter = level_counter + 1
        end

--Shooting-----------------------------------------------------
        player.cooldown = player.cooldown - 1     
        if love.keyboard.isDown("space") then
          player.fire()
        end
        
        for i,v in ipairs(player.bullets) do
          if v.y < -20 then
            table.remove(player.bullets, 1)
          end
          v.y = v.y - 10
        end

--Enemy movement------------------------------------------------
        for _, e in pairs(enemies_controller.enemies) do
          --getHeight() is the height of the window--
          if e.y >= love.graphics.getHeight() then
            game_over = true
          end
          if e.y ~= 570 then
          
          --do 
          --dist = -1
          --if distance ~= 50 then  
            --e.x = e.x + 1*e.speed
            --distance = distance + 1
          --else if distance 
          --end
            
            e.y = e.y + 1*e.speed
          end
          
        end
  end
  
function love.draw()-----------------------------------------------------------------DRAW----------------------------------------------------
-------------------------------------------------Menu-------------------------------------------------
--if level_counter == 0 then
  --love.graphics.draw(menu_title.PNG, 0, 0, 0, 1)
  --end
  
-------------------Game Screen------------------------------------------------------------------
-------------------------------------Background---------------------------------------------------------------------------------
 if level_counter == 1 then
        love.graphics.draw(background,0,0,0,1.4)
        if game_over == true then
            love.graphics.print("game over")
            return
        elseif game_win == true then
            love.graphics.print("Victory", 340, 200,0,3)
        end
--------draw player-------------------
        love.graphics.setColor(0, 0, 255)
        love.graphics.rectangle("fill", player.x, player.y, 80, 30)

--------draw bullets---------------- 
        for _, v in pairs(player.bullets) do
          love.graphics.setColor(255, 255, 255)
          love.graphics.rectangle("fill", v.x-5, v.y-5, 10,20)
        end

--------draw enemies---------------
        love.graphics.setColor(255, 255, 255)
        for _, e in pairs(enemies_controller.enemies) do
-----------------------------------image----------------x-----y-rotation-----width/height         
          love.graphics.draw(enemies_controller.image, e.x, e.y)
        end

  end
end

