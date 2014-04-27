local http_event_dispatcher = require "qmonix.http_event_dispatcher"
local tracker = require "qmonix.tracker"

local qmonix = {}

---
-- Library version number according to semantic versioning 2.0.0.
---
qmonix.version = "0.1.0"


---
-- Creates new tracker with http event dispatcher.
--
-- @param {string} events_uri URI to which events are sent via HTTP.
-- @return {table} tracker object.
---
function qmonix.new_http_tracker(events_uri)
	local dispatcher = http_event_dispatcher.create(events_uri)
	local http_tracker = tracker.create(dispatcher)
	return http_tracker
end


return qmonix
