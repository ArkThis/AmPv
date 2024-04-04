mp.register_event('file-loaded', function()
    local count = 0

    -- Show audio waveform underneith the video:
    mp.set_property('lavfi-complex', '[aid1]asplit[ao][a1],[a1]showwaves=size=720x120:rate=25:mode=line:colors=white:scale=sqrt:split_channels=1[vida],[vid1][vida]vstack=inputs=2[vo]')

    --{filter = {'[aid1]asplit[ao][a1],[a1]showwaves=size=720x120:rate=25:mode=line:colors=white:scale=sqrt:split_channels=1[vida],[vid1][vida]vstack=inputs=2[vo]'}}, --0 audio waveform
end)

mp.register_event('end-file', function ()
    mp.set_property('lavfi-complex', '')
end)
