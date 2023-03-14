pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

function _init()
	init_entities()
	simple_table = {4,9,3,1,78,10}
end

function _update()
	cls()
	print('unsorted table' ..'\n' ..'*********')
	display_table(simple_table)
	bubbleSort(simple_table)
	print('sorted table' ..'\n' ..'*********')
	display_table(simple_table)
	print('position')
	print('--------')
	display_leaderboard(leaderboard)
	bubbleSortComplexTable(leaderboard)
end

function _draw()
end

function init_entities()
	leaderboard = {}
	add(leaderboard, {name='ratson',moves=10})
	add(leaderboard, {name='pennyroyal',moves=12})
	add(leaderboard, {name='mellilot',moves=7})
	add(leaderboard, {name='amaryllis',moves=16})
end


function display_leaderboard(leaderboard)
	for k, v in ipairs (leaderboard) do
		print(v['name'])
		print(v['moves'])
	end
end

function display_table(simple_table)
	for v in all(simple_table) do
		print('table contents: ' ..v)
	end
end


function bubbleSort(simple_table)
  local itemCount = count(simple_table)
  local hasChanged
  repeat
    hasChanged = false
    itemCount=itemCount - 1
    for i = 1, itemCount do
      if simple_table[i] < simple_table[i + 1] then
        simple_table[i], simple_table[i + 1] = simple_table[i + 1], simple_table[i]
        hasChanged = true
      end
    end
  until hasChanged == false
end


function bubbleSortComplexTable(complex_table)
  local itemCount = count(complex_table)
  local hasChanged
  repeat
    hasChanged = false
    itemCount=itemCount - 1
   for i = 1, itemCount do
   	if(complex_table[i]['moves'] < complex_table[i+1]['moves']) then
   		complex_table[i], complex_table[i+1] = complex_table[i+1], complex_table[i]
   		hasChanged = true
   	end
   end
  until hasChanged == false
end
