return function(enums)

	local names = {}
	for name, i in pairs(enums) do
		local other = names[i]
		local message = 'Enumeration conflict: %s, %s'
		assert(not other, string.format(message, other, name))
		names[i] = name
	end

	return setmetatable(enums, {
		__call = function(self, i)
			return names[i]
		end,
		__index = function(self, name)
			error('Unidentified enumeration: ' .. name)
		end
	})

end