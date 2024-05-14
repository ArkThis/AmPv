-- Individual audio filter building blocks:
local f_asplit2 = "[aid${audio_track}]asplit[ao][a1]"
local f_asplit3 = "[aid${audio_track}]asplit=3[ao][a1][a2]"
local f_showwaves = "[a1]showwaves=size=${video_width}x180:rate=25:mode=line:colors=white:scale=sqrt:split_channels=1[v1]"

local f_showvolume = "[a2]showvolume=c=CHANNEL:p=0.5:dm=1:w=${video_width}[v2]"
local f_stack1 = "[vid1][v1]vstack=inputs=2[vidb]"
local f_overlay1 = "[vidb][v2]overlay[vo]"


mp.register_event('file-loaded', function()
    local audio_track = 1
    local video_width = mp.get_property("width")

    local waveform_filter = f_asplit3 ..','.. f_showwaves ..','.. f_showvolume ..','.. f_stack1 ..','.. f_overlay1
    local filter = waveform_filter:gsub("${audio_track}", audio_track):gsub("${video_width}", video_width) 

    -- Show audio waveform underneith the video:
    mp.set_property('lavfi-complex', filter)
end)

mp.register_event('end-file', function ()
    mp.set_property('lavfi-complex', '')
end)
