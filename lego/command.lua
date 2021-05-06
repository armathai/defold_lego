local M = {}

M.__guards__ = {}
M.__payloads__ = {}

function M.on(event_name, command)
	Lego.event.on(event_name, command, nil, false)
end

function M.once(event_name, command)
	Lego.event.once(event_name, command, nil, true)
end

function M.off(event_name, command)
	Lego.event.off(event_name, command)
end

function M.payload(...)
	M.__payloads__ = {...}

	return M
end

function M.guard(...)
	M.__guards__ = {...}

	return M
end

function M.execute(command)
	local payloads = M.__payloads__
	local guards = M.__guards__

	local passed = (function() 
		for _, v in pairs(guards) do
			if (not v(unpack(payloads))) then
				return false
			end	
		end

		return true
	end)()

	if passed then 
		command(unpack(payloads))
	else
		M._reset_gurads_and_payloads()
	end

	return M
end

function M._reset_gurads_and_payloads()
	M._reset_gurads()
	M._reset_payloads()
end

function M._reset_gurads()
	M.guard()
end

function M._reset_payloads()
	M.payload()
end


return M