local utils = {}

function utils.make_registration_func(obj, registry)
    return function(signal, method)
        registry:register(signal, function(...) method(obj, ...) end)
    end
end


local Direction = {}
utils.Direction = Direction
Direction.FORWARD      = 1
Direction.BACKWARD     = 2
Direction.STRAFE_LEFT  = 3 
Direction.STRAFE_RIGHT = 4 


return utils