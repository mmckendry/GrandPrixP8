local player_movement =function ()
    for i=1,50 do
      print("coroutine 1 " ..i)
      coroutine.yield()
    end
  end

  local opponent_movement = function ()
    for i = 1,10 do
      print("coroutine 2: " ..i)
      coroutine.yield()
    end
  end

  PLAYER = coroutine.create(player_movement)
  OPPONENT = coroutine.create(opponent_movement)

  for i = 1, 100 do
    if (coroutine.status(OPPONENT) == "suspended" or coroutine.status(OPPONENT) == "dead") then
      coroutine.resume(PLAYER)
    end
    if (coroutine.status(PLAYER) == "suspended") then
      coroutine.resume(OPPONENT)
    end
  end
