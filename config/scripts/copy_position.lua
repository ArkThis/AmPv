-- Author: Peter B. (pb@das-werkstatt.com)
-- Date: 2024-03-21
-- Based on 

function formatTimecode(time_pos)
    local time_sec = time_pos % 60
    time_pos = time_pos - time_sec

    local time_hours = math.floor(time_pos / 3600)
    time_pos = time_pos - (time_hours * 3600)

    local time_minutes = time_pos/60
    time_sec, time_msec = string.format("%.03f", time_sec):match"([^.]*).(.*)"

	timecode = string.format("%02d:%02d:%02d.%02d", time_hours, time_minutes, time_sec, time_msec)

	return timecode
end

function copyTimecode()
	local pos = mp.get_property_number("time-pos/full")
	local timecode = formatTimecode(pos)
	local pipe = io.popen("xclip -silent -in -selection clipboard", "w")

	pipe:write(timecode)
	pipe:close()
	mp.osd_message("Link to position copied to clipboard")
end

mp.add_key_binding("ctrl+SPACE", "copy-timecode", copyTimecode)
