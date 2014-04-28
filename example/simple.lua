---
-- To run the sample build Qmonix lua client libs with "make" in the root
-- project directory.
-- Then simple run this sample with lua interpreter: "lua simple.lua"
---

local qmonix = require "qmonix.qmonix"

local tracker = qmonix.new_http_tracker("http://localhost:8337/event/")

-- Timing event measuring for how long this sample is executed.
local sample_duration = tracker:start("qmonix/test/sample_duration")

-- Sends a single event to the server.
tracker:fire_dispatch("qmonix/test/single_event")

-- Sends event qith quantity - volume.
tracker:fire_dispatch("qmonix/test/vilume_event", 5)

print("Press ENTER to exit.")
io.read()

sample_duration:fire_dispatch()
