local uf = {}

function uf.round(x, decimal_places)
	local mult = 10^decimal_places
	x = math.floor(x * mult + 0.5) / mult
	return x
end

return uf
