local event = require "qmonix.event"

---
-- Volume events have quantity assigned to them. E.g. how long page view lasted
-- that was opened at specific time. This 'how long' is event volume.
---
local volume_event = {}

local volume_event_mt = {
	["__index"] = event
}
setmetatable(volume_event, volume_event_mt)


---
-- Creates new volume event object with the specified tag name and volume
-- value.
--
-- @param {string} tag event tag name.
-- @param {number} volume event quantitative data. math.floor() value will
--	be used in case of non integer values.
---
function volume_event.create(tag, volume)
	assert(type(tag) == 'string')
	assert(type(volume) == 'number')

	local retval = event.create(tag)

	local mt = {
		["__index"] = volume_event
	}
	setmetatable(retval, mt)

	retval.volume = math.floor(volume)

	return retval
end


---
-- Returns lua table representing event json object.
-- E.g. '{"tag" : "sample/event", "whenArised" : 1398470753, "volume" : 10}'
--
-- @param {table} self volume event object.
-- @return {table} table ready to be encoded to json.
---
function volume_event:to_json()
	local retval = event.to_json(self)

	retval["volume"] = self.volume

	return retval
end


return volume_event
