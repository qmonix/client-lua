local http = require("socket.http")
local json = require "json"

---
-- This event dispatcher collects events, compiles json message and sends it
-- to Qmonix server over HTTP.
---

local http_event_dispatcher = {}


---
-- Creates new http event dispatcher object and assings the URI which accepts
-- events over HTTP, e.g. "http://demo.qmonix.com/event/"
--
-- @param {string} events_uri URI to which events are sent via HTTP.
-- @return {table} http event dispatcher object.
---
function http_event_dispatcher.create(events_uri)
	assert(type(events_uri) == "string")

	local retval = {}

	local mt = {
		["__index"] = http_event_dispatcher
	}
	setmetatable(retval, mt)

	retval.events_uri = events_uri
	retval.events = {}

	retval.json_message = {
		["version"] = "1.0",
		["events"] = retval.events
	}

	return retval
end


---
-- Adds the specified event object to event dispatcher.
--
-- @param {table} self http event dispatcher object.
-- @param {table} event event object.
---
function http_event_dispatcher:submit(event)
	table.insert(self.events, event:to_json())
end


---
-- Sends collected events to the server. On success, clears the event list.
--
-- @param {table} self http event dispatcher object.
-- @throws {string} exception on failure to send events over HTTP.
---
function http_event_dispatcher:dispatch()

	self.json_message["whenSent"] = os.time()
	local str_json_msg = json.encode(self.json_message)

	local http_resp, err_msg = http.request(self.events_uri, str_json_msg)
	if http_resp == nil then
		error("Failed to send events. Error: " .. tostring(err_msg))
	end

	-- Clear event list.
	for k, _ in pairs(self.events) do
		self.events[k] = nil
	end

	self.events = {}
	self.json_message = {
		["version"] = "1.0",
		["events"] = self.events
	}
end


return http_event_dispatcher
