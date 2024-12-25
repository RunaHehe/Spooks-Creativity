function onCreatePost()
    for i = 0, getProperty('unspawnNotes.length')-1 do
        setPropertyFromGroup("unspawnNotes", i, 'singData', getRandomInt(1, 4)-1)
    end
    setGlobalFromScript("stages/discordStage", "opponentCaps", true)
end