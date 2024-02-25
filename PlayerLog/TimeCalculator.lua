-- -----------------------------------------------------------------------------
-- Time Stuff
-- -----------------------------------------------------------------------------

-- Calculates the total utc time between players
function CalculateTotalPlayerTime()

end

-- Converts epoch to hrs and mins
function ConvertToHoursAndMinutes(epoch)
    local seconds = epoch / 1000
    
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

-- Gets the date
function GetDate()
    return os.date("%d.%m.%Y")
end

-- Gets the year
function GetYear()
    return os.date("%Y")
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



-- -- Converts milliseconds since Unix epoch to hours and minutes


-- -- Get current time in UTC
-- local currentTime = GetCurrentTime()

-- -- Convert current time to hours and minutes
-- local hours, minutes = ConvertToHoursAndMinutes(currentTime)

-- -- Output the result
-- print("Current time in UTC:")
-- print("Hours:", hours)
-- print("Minutes:", minutes)

