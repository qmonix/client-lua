local event = require "qmonix.event"
local volume_event = require "qmonix.volume_event"
local timing_event = require "qmonix.timing_event"
local fireable_timing_event = require "qmonix.fireable_timing_event"

local tracker = {}


---
-- Creates new event tracker and assigns the specified event dispatcher object
-- to it.
--
-- @param {table} ev_dispatcher event dispatcher object that tracker uses
--	to send events.
-- @return {table} tracker object
---
function tracker.create(ev_dispatcher)
	assert(type(ev_dispatcher) == "table")

	local retval = {}

	local mt = {
		["__index"] = tracker
	}
	setmetatable(retval, mt)

	retval.dispatcher = ev_dispatcher

	return retval
end


---
-- Fires new event which is passed to the event dispatcher. If event volume
-- is not specified then regular event will be created and submited to the
-- dispatcher. Otherwise, volume event is fired.
--
-- math.floor(volume) is used for event volume.
--
-- @param {table} self tracker object.
-- @param {string} tag event tag name.
-- @param {number} volume event volume. Optional.
---
function tracker:fire(tag, volume)
	assert(type(tag) == "string")

	t_volume = type(volume)
	assert(t_volume == "nil" or t_volume == "number")

	local new_event = nil

	if volume == nil then
		new_event = event.create(tag)
	else
		new_event = volume_event.create(tag, volume)
	end

	self.dispatcher:submit(new_event)
end


---
-- Invokes tracker:fire() and also dispatcher:dispatch().
--
-- @param {table} self tracker object.
-- @param {string} tag event tag name.
-- @param {number} volume event volume. Optional.
---
function tracker:fire_dispatch(tag, volume)
	self:fire(tag, volume)
	self.dispatcher:dispatch()
end


---
-- Creates and starts new fireable timing event and returns it's object.
--
-- @param {table} self tracker object.
-- @param {string} tag new event tag name.
-- @return {table} fireable timing event object.
---
function tracker:start(tag)
	local new_event = fireable_timing_event.create(tag, self.dispatcher)
	return new_event
end


---
-- Invokes event dispatcher dispatch() method.
--
-- @param {table} self tracker object.
---
function tracker:dispatch()
	self.dispatcher:dispatch()
end


return tracker
