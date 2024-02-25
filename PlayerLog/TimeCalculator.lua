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
            local timeInMilliseconds = tonumber(timestamp)
            
            -- Initialize player entry if it doesn't exist
            if not playerTimes[playerName] then
                playerTimes[playerName] = {totalTime = 0, lastActionTimestamp = timeInMilliseconds}
            else
                -- Calculate time difference since last action and update total time
                local timeDifference = timeInMilliseconds - playerTimes[playerName].lastActionTimestamp
                playerTimes[playerName].totalTime = playerTimes[playerName].totalTime + timeDifference
                playerTimes[playerName].lastActionTimestamp = timeInMilliseconds
            end
        end
    end

    return playerTimes
end

-- Converts milliseconds to hrs and mins
function ConvertToHoursAndMinutes(ms)
    local seconds = ms / 1000
    
    --    Get hours and minutes from seconds
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    
    return hours, minutes
end

-- -----------------------------------------------------------------------------
-- Dict Handling Stuff
-- -----------------------------------------------------------------------------
function CheckIfLeap()
    -- Changes day to leap year.
    if (((GetYear() % 4 == 0) and (GetYear() % 100 ~= 0)) or (GetYear() % 400 == 0)) then
        calendarMD["February"] = 29
    end
end

-- -----------------------------------------------------------------------------
-- Misc Stuff
-- -----------------------------------------------------------------------------

-- Gets current time in utc
function GetCurrentTime()
    return os.epoch("utc")
end

-- Gets the year
function GetYear()
    return os.date("%Y")
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
    table.sort(playerTimeList, function(a, b) return a.time > b.time end)

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

-- A lookup table containing number of days in a month
calendarMD = {
    ["January"] = 31,
    ["February"] = 28,
    ["March"] = 31,
    ["April"] = 30,
    ["May"] = 31,
    ["June"] = 30,
    ["July"] = 31,
    ["August"] = 31,
    ["September"] = 30,
    ["October"] = 31,
    ["November"] = 30,
    ["December"] = 31
}

-- Changes lookup table if leap year
CheckIfLeap()

-- Gets the total player time
local time = CalculateTotalPlayerTime()
-- Gets the top three players times
topThree = GetPlayersLargestTimes(time)

for i, playerInfo in ipairs(topThree) do
    print(i .. ": " .. playerInfo.player .. " - " .. playerInfo.hours .. "hrs and " .. playerInfo.minutes .. "mins")
end


-- every hour update
-- print top three to monitor