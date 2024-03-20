-- -----------------------------------------------------------------------------
-- Scripts for calculating epoch time
-- -----------------------------------------------------------------------------

-- Imports my IOFile stuff
os.loadAPI("IOFile.lua") 

-- -----------------------------------------------------------------------------
-- Time Stuff
-- -----------------------------------------------------------------------------

-- Calculates the total time between players
function CalculateTotalPlayerTime()
    local playerTimes = {}  -- Table to store total time for each player
    
    -- For every line in the file
    for line in io.lines(IOFile.PATH) do
        local playerName, action, timestamp = line:match("([^:]+):([^:]+):([^:]+)")
    
        -- If not null
        if playerName and action and timestamp then
            -- Convert timestamp to milliseconds
            local timeInSeconds = tonumber(timestamp)/1000
            
            -- Initialize player entry if it doesn't exist
            if not playerTimes[playerName] then
                playerTimes[playerName] = {totalTime = 0, lastActionTimestamp = -1, sessions = {}}
            end
            
            if action == "joined" then
                playerTimes[playerName].sessions[timeInSeconds] = {startSess = timeInSeconds, endSess = -1}
            elseif action == "left" then
                if not (playerTimes[playerName].sessions[playerTimes[playerName].lastActionTimestamp] == nil) then
                    -- Calculate time difference since last action and update total time
                    local timeDifference = timeInSeconds - playerTimes[playerName].sessions[playerTimes[playerName].lastActionTimestamp].startSess
                    playerTimes[playerName].sessions[playerTimes[playerName].lastActionTimestamp].endSess = timeInSeconds
                    playerTimes[playerName].totalTime = playerTimes[playerName].totalTime + timeDifference
                end
            end
            playerTimes[playerName].lastActionTimestamp = timeInSeconds
        end
    end
    
    return playerTimes
end

-- Converts milliseconds to hrs and mins
function ConvertToHoursAndMinutes(ms)
    local seconds = ms
    --    Get hours and minutes from seconds
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    
    return hours, minutes
end

-- -----------------------------------------------------------------------------
-- Misc Stuff
-- -----------------------------------------------------------------------------

-- Gets current time in utc
function GetCurrentTime()
    return os.epoch("utc")
end

-- -----------------------------------------------------------------------------
-- Players With Largest Times
-- -----------------------------------------------------------------------------

-- Function to get the three players with the largest times
function GetPlayersLargestTimes(playerTimes)

    -- Convert the playerTimes table to a list of {player, time} pairs
    local playerTimeList = {}
    for player, time in pairs(playerTimes) do
        table.insert(playerTimeList, {player = player, time = time})
    end

    -- Sort the list based on time in descending order
    table.sort(playerTimeList, function(a, b) return a.time.totalTime > b.time.totalTime end)

    -- Extract the three players with the largest times
    local largestPlayers = {}
    for i = 1, 3 do
        if playerTimeList[i] then
            local playerInfo = playerTimeList[i]
            -- Convert total time to hours and minutes
            local hours, minutes = ConvertToHoursAndMinutes(playerInfo.time.totalTime)
            -- Add converted time to player info
            playerInfo.hours = hours
            playerInfo.minutes = minutes
            -- Add player info to largest players table
            table.insert(largestPlayers, playerInfo)
        end
    end

    return largestPlayers
end

-- -----------------------------------------------------------------------------
-- Init Stuff
-- -----------------------------------------------------------------------------

-- Gets the total player time
local time = CalculateTotalPlayerTime()
-- Gets the top three players times
topThree = GetPlayersLargestTimes(time)