---
-- Qmonix event representing class. It has a tag and time stamp when it
-- was fired.
---
local event = {}


---
-- Creates new event object with the specified tag name. Event creation time
-- is it's fire time.
--
-- @param {string} tag event name.
-- @return {table} event object.
---
function event.create(tag)
	assert(type(tag) == "string")

	local retval = {}

	local mt = {
		["__index"] = event
	}
	setmetatable(retval, mt)

	retval.tag = tag
	local time_now = os.time()
	retval.time_arised = time_now

	return retval
end


---
-- Returns lua table representing event json object.
-- E.g. '{"tag" : "sample/event", "whenArised" : 1398470753}'
--
-- @param {table} self event object
-- @return {table} table ready to be encoded to json.
---
function event:to_json()
	local event_obj = {
		["tag"] = self.tag,
		["whenArised"] = self.time_arised
	}

	return event_obj
end


return event
