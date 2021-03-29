pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
 scene=0
 fuel=5
 lap=0
 first=true
 timer=0
  
 function _init()
  shake=0
  last_x= 0
  last_y = 0
  make_player()
  display = false
  is_generated = false
 end
 
 function _update()
  if(scene == 0) then
   title_update()
  elseif (scene == 1) then
   move_player()
   if (fuel != 0) then 
    pathfinding()
   end
  elseif(scene == 2) then
   finish_update()
  elseif(scene == 3) then
   pitstop_update()
  end
 end
 
 function _draw()
  cls()
  if(scene==0) then
   title_draw()
  elseif(scene==1) then
   camera_follow()
   drawtrack()
   spr(0,p.x*8,p.y*8)
   update_fuel()
   display_fuel()
   metrics()
   out_of_fuel()
   display_textwindow()
  elseif(scene==2) then 
   finish_draw()
  elseif(scene==3) then
   pitstop_draw()
  end
end
-->8
--utility functions
c={}
c.x=0
c.y=0

--camera follows the player
function camera_follow()
 c.x=p.x-10
 c.y=p.y-10

 c.x=mid(0,c.x,128)
 c.y=mid(0,c.y,128)

 camera(c.x*8,c.y*8)
end

function camera_shake()
 local shakex=16-rnd(32)
 local shakey=16-rnd(32)
 shakex*=shake
 shakey*=shake
 
 camera(shakex,shakey)
 shake = shake*0.95

 if (shake<0.05) shake=0
end

--collision detection
function can_move(x,y)
 local map_sprite=mget(x,y)
 local flag=fget(map_sprite)
 
 if(flag==4)then 
  scene=3
 end
 if(flag==2) then
  lap+=1 
  if(lap==4 and flag==2) then
    scene=2
  end
 end
 return flag!=1
end

--update fuel
function update_fuel()
 local delay=0
 if(delay<60) then 
  delay+=1
 end
 if(delay>=60) then
  delay=0
  if (fuel!=0) then
   fuel-=1
  end
 end
end

--pathfinding for the player
function pathfinding()
 local up = {}
 local down = {}
 local left = {}
 local right = {}
 local neighbours = {}
 local candidates = {}
 local next_step = {}

 local new_x = p.x 
 local new_y = p.y
 if(first) then 
  last_x -= 1 
  last_y = p.y
  first = false
 end

function set_neighbours()
  left[1] = new_x - 1
  left[2] = new_y
  right[1] = new_x + 1
  right[2] = new_y
  up[1] = new_x
  up[2] = new_y + 1
  down[1] = new_x
  down[2] = new_y - 1
  neighbours = {left,right,up,down}
 end
 
 set_neighbours()
 
  for k, v in ipairs(neighbours) do
   for j, m in ipairs(v) do
     candidates[j] = m 
   end
   if (candidates[1]!=last_x or candidates[2]!=last_y) then
    -- sfx(0) 
     if(can_move(candidates[1], candidates[2])) then
      next_step[1] = candidates[1]
      next_step[2] = candidates[2]
     end
   end
  end
  
 last_x = p.x
 last_y = p.y
  
 p.x = next_step[1]
 p.y = next_step[2]
end
-->8
-- display 
function metrics()
 local x = c.x*8
 local y = c.y*8
 rectfill(x,y+42,x+42,y+2,8)
 rectfill(x,y+40,x+40,y+0,9)
 print("fuel:"..fuel,x+1,y+8,8)
 print("map:"..x..","..y,x+1,y+16,8)
 print("lap:"..lap,x+1,y+24,8)
 print("cam:"..c.x ..","..c.y,x+1,y+32,8)
end

function display_pit_message()
 print(pitmessage,p.x-10,p.y-10,14)
end 

function display_fuel()
 local x = c.x*8
 local y = c.y*8

  rectfill(x+122,y+30,x+128,y+30-fuel,11)
  rect(x+122,y+5,x+127,y+30,13)
end

function out_of_fuel()
 local text="you are out of fuel!"
 if (fuel == 0) then
  display = true
  set_textwindow(text, 8, 9, 8)
 end
end

function set_textwindow(text, bg, fg, t_colour, x, y)
 textlabel=text
 text_colour=t_colour
 fg_colour=fg
 bg_colour=bg
end

function display_textwindow()
local x = c.x*8
local y = c.y*8
 if (display) then  
  rectfill(x+12,y+42,x+122,y+82,bg_colour)
  rectfill(x+10,y+40,x+120,y+80,fg_colour)
  print(textlabel,hcenter(textlabel)+x,y+60,text_colour)
 end
end

function hcenter(s)
 return (screenwidth / 2)-flr((#s*4)/2)
end

function vcenter(s)
 return (screenheight /2)-flr(5/2)
end

function drawtrack()
  map(0,0,0,0,128,128)
end
-->8
--player functions
function make_player()
 p={}
 p.x=7
 p.y=5
 p.sprite=5
end

function move_player()
 local new_x,new_y=p.x,p.y
 local text = "box box box!"
 
 if (btnp(⬇️)) then 
  if(fuel != 0) then 
   pathfinding()
  end
 end
 if(btnp(❎)) then 
   display = true
   set_textwindow(text, 8, 7, 8)
 end
  if(btnp(🅾️)) then 
    display = false
    fuel = 10
    scene = 3
 end
  
end
-->8
--title screen
screenwidth = 127
screenheight = 127

function title_draw()
 local titletxt = "grandprix"
 local starttxt = "press x to start"
 rectfill(0,0,screenwidth, screenheight, 9)
 print(titletxt, hcenter(titletxt), screenheight/4, 8)
 print(starttxt, hcenter(starttxt), (screenheight/4)+(screenheight/2),8)
end

function title_update()
  if (btnp(❎)) then 
   scene = 1
  end
end

-->8
--pitstop
 s={{v=0,c=8},{v=0,c=8},{v=0,c=8},{v=0,c=8}}
 k=0
 s_count=1
 s_finished=false

function pitstop_draw()
 camera_shake()
 local titletxt = "pitstop!"
 local starttxt = "x to release!"
 rectfill(0,0,screenwidth, screenheight, 7)
 print(titletxt, hcenter(titletxt), screenheight/4, 8)
 print(starttxt, hcenter(starttxt), (screenheight/4)+(screenheight/2),8)
 generate_sequence()
end

function pitstop_update()
 pit_timer()
 if (btnp(❎)) then
  is_generated=false
  reset_values()
 end
 if(is_generated) then 
  if(btnp(⬆️))then
   check_sequence("⬆️")
  end
  if(btnp(➡️))then
   check_sequence("➡️")
  end
  if(btnp(⬇️))then
   check_sequence("⬇️")
  end
  if(btnp(⬅️))then
   check_sequence("⬅️")
  end
 end   
end

function generate_sequence()
 if(is_generated==false) then
  for i=1,4 do
   k=flr(rnd(4))
   if k==0 then
    k="⬆️"
   elseif k==1 then
    k="➡️"
   elseif k==2 then
    k="⬇️"
   elseif k==3 then
    k="⬅️"
  end
 s[i]["v"]=k
 end
end
  
 print(s[1]["v"],45,65,s[1]["c"])
 print(s[2]["v"],55,65,s[2]["c"])
 print(s[3]["v"],65,65,s[3]["c"])
 print(s[4]["v"],75,65,s[4]["c"])
 print("timer: "..timer/30,45,25,s[4]["c"])
 is_generated=true
end

function check_sequence(button)
 if(s_finished==false) then
  if (shake<0.1000) then
   if(s[s_count]["v"] == button) then 
    s[s_count]["c"]=9
    s_count+=1
    if(s_count==5) then
     s_finished=true
     s_count=1
    end
   else
    shake+=1
   end
  end
 end
end

function reset_values()
 for i=1,4 do 
  s[i]["c"]=8
 end
 s_count=1 
 scene=1
 s_finished=false
 timer=0
end

function pit_timer()
 if(s_finished==false) then
  timer+=1
 end
end 
-->8
--finish state
function finish_draw()
 camera()
 local titletxt = "finish!"
 local starttxt = "x to start again!"
 rectfill(0,0,screenwidth, screenheight, 8)
 print(titletxt, hcenter(titletxt), screenheight/4, 9)
 print(starttxt, hcenter(starttxt), (screenheight/4)+(screenheight/2),9)
end

function finish_update()
  if (btnp(❎)) then 
   scene = 1
  end
end
__gfx__
005555000008800000aaaa0067777776e888888e677777767700770000000000e888888e0cccccc066d666d60000000000000000000000000000000000000000
05777750008ee8000a9999a067777776e888888e677777767700770000000000e888888ec000000cdddddddd0000000000000000000000000000000000000000
5777777508eeee80a999999a67777776e888888e677777760077007700000000e888888ec000000cd666d6660000000000000000000000000000000000000000
577557758ee88ee8a99aa99a567777652e8888e25677776500770077000000002e8888e27cccccc7d666d666aa77aa7700000000000000000000000000000000
577557758ee88ee8a99aa99a0566665002eeee2077666600770077000000000072eeee00c777777cddddddddaa77aa7700000000000000000000000000000000
5777777508eeee80a999999a0000000000000000770077007700770000000000770077007cccccc766d666d60000000000000000000000000000000000000000
05777750008ee8000a9999a0000000000000000000770077007700770000000000770077c777777c66d666d60000000000000000000000000000000000000000
005555000008800000aaaa00000000000000000000770077007700770000000000770077ccccccccdddddddd0000000000000000000000000000000000000000
00bbbb00000000000000000000000000000000007700770000000000000000007700770003333330000000000000000000000000000000000000000000000000
0b0000b0000000000000000000000000000000007700770000000000000000007700770030000003000000000000000000000000000000000000000000000000
b000000b000000000000000000000000000000000077007700000000000000000000007730000003000000000000000000000000000000000000000000000000
b000000b00000000000000000566665002eeee200566665702eeee200566665002eeee2773333337000000000000000000000000000000000000000000000000
b000000b0000000000000000567777652e8888e2567777652e8888e2e67777652e8888e237777773000000000000000000000000000000000000000000000000
b000000b000000000000000067777776e888888e67777776e888888ee7777776e888888e33333333000000000000000000000000000000000000000000000000
0b0000b0000000000000000067777776e888888e67777776e888888ee7777776e888888e73333337000000000000000000000000000000000000000000000000
00bbbb00000000000000000067777776e888888e67777776e888888ee7777776e888888e37777773000000000000000000000000000000000000000000000000
eee2000000002eee000007760000088e000008e2000002e22e8000002e2000008888e00000000000000000000000000000000000000000000000000000000000
888e20000002e888000077760000888e0000888e00002e8ee8880000e8e200008888e00000000000000000000000000000000000000000000000000000000000
8888e000000e8888000777760008888e0008888e0002e8888888e000888e20008888e00000000000000000000000000000000000000000000000000000000000
8888e000000e8888007777760088888e0088888e002e8888e8888e008888e200888e200000000000000000000000000000000000000000000000000000000000
8888e000000e8888077777760888888e088888e202e888882e88888088888e20eee2000000000000000000000000000000000000000000000000000000000000
8888e000000e888877777766888888ee88888e202e88888002e888880e8888e20000000000000000000000000000000000000000000000000000000000000000
888e20000002e8887777766588888ee2e888e200e8888800002e888e00e8888e0000000000000000000000000000000700000000000000000000000000000000
eee2000000002eee66666650eeeeee202e8e20002e8e20000002eee200088ee20000000000000000000000000000008e00000000000000000000000000000000
66650000000056660000000000000000000007650000056556700000565000000000000000000000000000007665000000000000000000000000000000000000
7776500000056777000000000000000000007776000056766777000067650000000000000000000000000000e000000000000000000000000000000000000000
7777600000067777000000000000000000077776000567767777700077765000000000000000000000000000e000000000000000000000000000000000000000
777760000006777700002eee00005666007777760056777767777700777765000000000000000000000000002000000000000000000000000000000000000000
77776000000677770002e88800056777077777650567777756777770777776500000000000000000000000000000000000000000000000000000000000000000
7777600000067777000e888800067777777776505677777005677777067777650000000000000000000000000000000000000000000000000000000000000000
7776500000056777000e888800067777677765006777770000567776006777760000000000000000000000000000000000000000000000000000000000000000
6665000000005666000e888800067777567650005666600000056665000776650000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000200120000000000000000000000000000000000000000000000000000000000000000000000000000730000620000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000300130000000000000000000000000000000000000000000000000000000000000000000000000000007200006200000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000200120000000000000000000000000000000000000000000000000000000000000000000000000000000003001300000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000300130000000000000000000000000000000000000000000000000000000000000000000000000000000002001200000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000007200006200000000000000000000000000000000000000000000000000000000000000000000000000000003001300000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000073000030303030303030303030303030303030303030303030303030303030303030303030303030303003001200000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000070011300000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000030012313131313131313131313131313131313131313131313131313131313131313131313131313103001200000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000020012000000000000000000000000000000000000000000000000000000000000000000000000000003001300000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000030013000000000000000000000000000000000000000042304030403040304030403040304030403002001200000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000020012000000000000000000000000000000000043403000000000000000000000000000000000000000001300000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000030013000000000000000000000000423040304000000000314131413141314131413141314131413141315200000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000030000403040304030403040504030000000000000413152000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000020000000000000000000000600000003141314153000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000734131413141314131413141514131520000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000020101010201010001040000000004000001010101010100000000000000010101010101010101000000000000000101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000024030403043600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000030000000000004030403040304030403040304360000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000020002113140000000000000000000000000000000403040326000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000037000036003714131413141314131413141314000000000000030403040326000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000270000260000000000000000000000000000371413141300000000000031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000003700003600000000000000000000000000000000000027131413200021000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000020002100000000000000000000000000000000000000000000300031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000037000036000000000000000000000000000000000000000000200021000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000200021000000000000000000000000000000003404030403000025000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000370000360000000000000000000000000000240000000000003500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000002000210000000000340403040304030403000014131413250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000003000310000000024000000000000000000003500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000002700002600003400001413141314131413250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000030003100002000310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000020002100003000310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000030003100002000210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000020002100003000310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000030003100002000210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000020002100003700003600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000030003100000027000026000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000020002100000000300031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000030003100000000200021000000000000000000000024030403040304030403040304030436000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000020002100000000300031000000000000000034040300000000000000000000000000000000040304032600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000030003100000000200021000000000000002400000000131413141314131413141314131400000000000036000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000027000026000000300031000000000024030000141325000000000000000000000000000037141314130000260000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000300031000000270000030403040300000035000000000000000000000000000000000000000000002700003600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000200021000000003700000000000000132500000000000000000000000000000000000000000000000030002100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000300031000000000027131413141325000000000000000000000000000000000000000000000000000020003100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000700001201000000070000f0000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
