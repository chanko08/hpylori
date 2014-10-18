local utils = {}

local function make_registration_func(obj, registry)
    return function(signal, method)
        registry:register(signal, function(...) method(obj, ...) end)
    end
end



utils.make_registration_func = make_registration_func

return utils