pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
 pc_x=20
 pc_y=40
	pc_spr=0
	delay=0
	pitmessage=""
	is_pit_confirmed = false
 
 function userinput()
	 if btn (0) then
		 pc_x-=1
		 pc_spr+=1
	 elseif btn(1) then
		 pc_x+=1
			pc_spr-=1
		elseif btn(2) then
		 pc_y-=1
		 pc_spr-=1
		elseif btn(3) then
		 pc_y+=1
		 pc_spr-=1
		elseif btn(4) then
			pitstop_initiate()
	 elseif btn(5) then
	 	pitstop_confirm()
	 end
 end
 
 function drawtrack()
 	map(1, 3, 20, 40, 12, 12)
 end
 
	
 function _update()
 	userinput()
 	animatecar()
 end
 
 function animatecar()
 	if(pc_x < 100 and pc_y == 40) 
 	then
 		pc_x += 1
	 end
	 
	if(pc_x >= 100 and pc_y >= 40) 
 	then
 		pc_y += 1
	end
	 
	if(pc_x > 0 and pc_y == 72) 
 	then
 		pc_x -= 1
	end

	 
	if(pc_x == 20 and pc_y <= 72) 
 	then
 		pc_y -= 1
	end

 end
 
 function pitstop_initiate()
 	pitmessage = "box box box!"
 end
 
 
 function pitstop_confirm()
		pitmessage = "understood"
		is_pit_confirmed = true
		delay = 0
 end	
 
 function update_pit_message()
 if(delay < 60) then 
 	delay += 1
 	end
 if(delay >= 60) then
 	if is_pit_confirmed == true then
			is_pit_confirmed = false 
			pitmessage = ""
 	end
 	 delay = 0
 	end
 end
 
 function _draw()
 	cls()
 	rectfill(0,0,128,128,3)
 	rectfill(20,40,107,79,0)
 	rectfill(28,48,100,71,3)
 	drawtrack()
 	spr(0, pc_x, pc_y)
 	print("x: " ..pc_x, 2, 2, 1)
 	print("y: "..pc_y, 2, 8, 1)
 	print("delay:"..delay, 2, 14, 1)
 	update_pit_message()
 	print(pitmessage, 2, 20, 1)
 end
__gfx__
007777000008800000aaaa0000000000787878788000000000000008878787878000000887878787878787870000000000000000000000000000000000000000
07000070008008000a0000a000000000800000007000000000000007000000087000000700000700000000000000000000000000000000000000000000000000
7000000708000080a000000a00000000700000008000000000000008000000078000000800000700000000000000000000000000000000000000000000000000
7007700780088008a00aa00a00000000800000007000000000000007000000087000000700000700000000000000000000000000000000000000000000000000
7007700780088008a00aa00a00000000700000008000000000000008000000078000000800000700000000000000000000000000000000000000000000000000
7000000708000080a000000a00000000800000007000000000000007000000087000000700000700000000000000000000000000000000000000000000000000
07000070008008000a0000a000000000700000008000000000000008000000078000000800000700000000000000000000000000000000000000000000000000
007777000008800000aaaa0087878787800000007878787887878787000000087000000787878787878787870000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
87887887887887888788788788788870000000787000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
87887887887887888788788788788780000008707870000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000007880000078000078000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000888000870000008700000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000088007800000000780000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000077087000000000087000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000088780000000000007800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000088700000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000007888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
87887887887887888788788788788780000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
87887887887887888788788788788870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000012121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040a0a0a0a0a090a0a0a070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050a0a0a0a0a0a0a0a0a060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
