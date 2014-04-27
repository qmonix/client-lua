local volume_event = require "qmonix.volume_event"

---
-- Timing events are volume events where volume is time duration in seconds.
-- When you create a timing event it is running. Then you can pause, resume
-- or stop it.
---
local timing_event = {}

local timing_event_mt = {
	["__index"] = volume_event
}
setmetatable(timing_event, timing_event_mt)


---
-- Creates and starts new timing event.
--
-- @param {string} tag event tag name.
-- @return {table} timing event object.
---
function timing_event.create(tag)
	assert(type(tag) == 'string')

	local retval = volume_event.create(tag, 0)

	local mt = {
		["__index"] = timing_event
	}
	setmetatable(retval, mt)

	retval.state = "STARTED"
	retval.time_started = retval.time_arised

	return retval
end


---
-- Pauses timing event if it was started. Otherwise does nothing.
--
-- @param {table} self timing event object.
---
function timing_event:pause()
	if self.state == "STARTED" then
		self.volume = self.volume + os.time() - self.time_started
		self.state = "PAUSED"
	end
end


---
-- Resumes timing event which was paused. Otherwise does nothing.
--
-- @param {table} self timing event object.
---
function timing_event:resume()
	if self.state == "PAUSED" then
		self.time_started = os.time()
		self.state = "STARTED"
	end
end


---
-- Stops started or paused timing event. If event was already stopped, does
-- nothing.
--
-- @param {table} self timing event object.
---
function timing_event:stop()
	if self.state ~= "STOPPED" then
		self.volume = self.volume + os.time() - self.time_started
		self.state = "STOPPED"
	end
end


return timing_event
