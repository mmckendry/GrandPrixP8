pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

-- library for when you need to trigger a funtion after a certain amount of time elapses
-- example includes functions with and without parameters 
function _init()
	time_value = 0.3
	timer={
		elapsed=0,
		delay = 0
	} 
	
end

function _draw()
end

function _update()
	-- delay_in_seconds(time_value, method_triggered)
	delay_in_seconds(time_value, method_passed_with_arg, "test")
end


function delay_in_seconds(time_value, method, arg)
	local seconds = time_value * 30
		print("time elapsed "..timer.elapsed/30)
		if (timer.delay >= seconds) then
			method(arg)
			timer.elapsed = 0
			timer.delay = 0
		end
	timer.delay += 1
	timer.elapsed += 1
end


function method_triggered() 
	print("i have been triggered")
end 

function method_passed_with_arg(arg)
	print("i have been passed to a function " .."\n".."with an argument of: " ..arg)
end
