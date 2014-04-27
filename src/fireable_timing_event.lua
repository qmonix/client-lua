local timing_event = require "qmonix.timing_event"

local fireable_timing_event = {}

local fireable_timing_event_mt = {
	["__index"] = timing_event
}
setmetatable(fireable_timing_event, fireable_timing_event_mt)


---
-- Creates new fireable timing event with the specified tag name and event
-- dispatcher assigned.
--
-- @param {string} tag event tag name.
-- @param {table} ev_dispatcher event dispatcher object used by
--	fireable_timing_event:dispatch().
-- @return {table} new fireable_timing_event object.
---
function fireable_timing_event.create(tag, ev_dispatcher)
	assert(type(tag) == "string")
	assert(type(ev_dispatcher) == "table")

	local retval = timing_event.create(tag)

	local mt = {
		["__index"] = fireable_timing_event
	}
	setmetatable(retval, mt)

	retval.dispatcher = ev_dispatcher

	return retval
end


---
-- Stops the timing event and submits it to the event dispatcher.
--
-- @param {table} self fireable_timing_event object.
---
function fireable_timing_event:fire()
	self:stop()
	self.dispatcher:submit(self)
end


---
-- Stops, fires and sends timing event data to Qmonix server.
--
-- @param {table} self fireable_timing_event object.
---
function fireable_timing_event:fire_dispatch()
	self:fire()
	self.dispatcher:dispatch()
end


return fireable_timing_event
