-- -----------------------------------------------------------------------------
-- Player Log In Detector
-- Uses advanced peripherals Player Detectors
-- -----------------------------------------------------------------------------

-- Imports my IOFile stuff
os.loadAPI("IOFile.lua") 
os.loadAPI("TimeCalculator.lua")

-- -----------------------------------------------------------------------------
-- On Events
-- -----------------------------------------------------------------------------

-- Pads the monitor
function Rpad(s, l, c)
    local res = s .. string.rep(c or ' ', l - #s)

    return res, res ~= s
end

-- Player join func
function PlayerJoin(username)
    -- Sets colour dependent on username
    SetColour(username)

    local txt = username .. " has joined the world"

    -- Writes messages to file and monitor
    PrintMonitor(txt)
    local txtLog = username .. ":joined:" .. TimeCalculator.GetCurrentTime()
    IOFile.WriteFile(txtLog)

    TopThreePrint()

end

-- Player leave func
function PlayerLeave(username)
    -- Sets colour dependent on username
    SetColour(username)

    local txt = username .. " has left the world"

    -- Writes messages to file and monitor
    PrintMonitor(txt)
    local txtLog = username .. ":left:" .. TimeCalculator.GetCurrentTime()
    IOFile.WriteFile(txtLog)
    TopThreePrint()
end

-- Refreshes every hour
function RefreshHourly()
    -- Define the duration of an hour in seconds
    local hourInSeconds = 3600

    -- Main loop
    while true do
        DrawHeader()
        TopThreePrint()
    -- Pause execution for one hour
    os.sleep(hourInSeconds)
    end
end

-- -----------------------------------------------------------------------------
-- Events
-- -----------------------------------------------------------------------------

-- On player join
function OnPlayerJoin()
    while true do
        local event, username = os.pullEvent("playerJoin")
        PlayerJoin(username)
    end
end

-- On Player leave event
function OnPlayerLeave()
    while true do
        local event, username = os.pullEvent("playerLeave")
        PlayerLeave(username)
    end
end

-- Waits for keypress to kill the program
function WaitForKeyPress()
    while true do
      local event, key = os.pullEvent("key")
      if key == keys.q then
        return key
      end
    end
end


-- ------------------------------------------------------------------------
-- Monitor Stuff
-- -----------------------------------------------------------------------------

-- A function to the draw the header of the monitor
function DrawHeader()
    local txt = "-=Player  Log=-"
    SetColour("menu")
    -- Calculates midpoint of monitor
    local mp = width / 2
    local wot = string.len(txt) / 2
    local dif = mp - wot
    
    -- Sets the cursor pos
    monitor.setCursorPos(dif+1, 1)
    -- Writes to monitor
    monitor.write(txt)
end

-- https://www.computercraft.info/forums2/index.php?/topic/15790-modifying-a-word-wrapping-function/
-- Makes the monitor text Wrap nicely
function Wrap(str, limit)
    local Lines, here, limit = {}, 1, limit or 72
    Lines[1] = string.sub(str, 1, str:find("(%s+)()(%S+)()") - 1) -- Put the first word of the string in the first index of the table.

    str:gsub("(%s+)()(%S+)()",
        function(sp, st, word, fi) -- Function gets called once for every space found.
            if fi - here > limit then
                here = st
                Lines[#Lines + 1] =
                word                                        -- If at the end of a line, start a new table index...
            else
                Lines[#Lines] = Lines[#Lines] .. " " .. word
            end                                             -- ... otherwise add to the current table index.
        end)

    return Lines
end

-- A function to print stuff to the monitor
function PrintMonitor(text)
    local text_to_wrap = Wrap(text, width)
    for k, v in pairs(text_to_wrap) do
        monitor.setTextColor(before_header)
        monitor.setCursorPos(width, height)
        monitor.write(" ")
        monitor.setCursorPos(1, height)
        monitor.scroll(1)
        monitor.write(Rpad(v, width))
    end
end

-- A function to print stuff to the monitor
function PrintTopThree(text, pos)
    local text_to_wrap = Wrap(text, width)
    for k, v in pairs(text_to_wrap) do
        monitor.setTextColor(before_header)
        monitor.setCursorPos(1, k + pos)
        monitor.write(Rpad(v, width))
        DrawHeader()
    end

    monitor.setCursorPos(1, (height))
    return #text_to_wrap
end

-- A function to set colour depending on username
function SetColour(username)
    -- Default to blue if nil
    if (txtColor[username] == nil) then
        monitor.setTextColor(colors.blue)
        before_header = colors.blue

    -- If username menu, look up the menu colour
    elseif (username == "menu") then
        monitor.setTextColor(txtColor[username])
    -- Else, look up the colour, and set before header 
    else
        monitor.setTextColor(txtColor[username])
        before_header = txtColor[username]
    end
end

-- Prints the top three to a function
function TopThreePrint()
    pos = 1
    for i, playerInfo in ipairs(TimeCalculator.topThree) do

    -- Text to be displayed
    local txt = i .. ": " .. playerInfo.player .. " - " .. playerInfo.hours .. "hrs and " .. playerInfo.minutes .. "mins"

    -- Sets colour for each player
    SetColour(playerInfo.player)
    
    -- Writes to monitor
    pos = pos + PrintTopThree(txt, pos)
    end
end

-- For the blinky icon in the bottom right corner
function Blink()
    local yes = false
    -- Main loop
    while true do
        monitor.setCursorPos(width, height)
        if yes then
            monitor.write("\131")
            yes = false
        else
            monitor.write("\140")
            yes = true
        end
        os.sleep(1)
    end
end

-- -----------------------------------------------------------------------------
-- DEBUG Stuff
-- -----------------------------------------------------------------------------

-- DEBUGGING
function PickRandomString(strings)
    local index = math.random(1, #strings)
    return strings[index]
end


-- Refreshes every hour
function LoginPlayer()
    -- Define the duration of an hour in seconds
    local hourInSeconds = 5

    -- Main loop
    while true do
    os.sleep(hourInSeconds)
    PlayerJoin(PickRandomString({"TEST_User1", "TEST_User2", "TEST_User3", "TEST_User4"}))
    end
end

-- -----------------------------------------------------------------------------
-- Init Stuff
-- -----------------------------------------------------------------------------

-- Gets the monitor that's adjacent
monitor = peripheral.Wrap("monitor_4")
detector = peripheral.find("playerDetector")

-- Dict for colours
txtColor = {
        ["Ridgey28"] = colors.purple,
        ["winer2222"] = colors.red, 
        ["menu"] = colors.orange,
        ["space928"] = colors.green, 
        ["PotatoNerdGames"] = colors.pink, 
    }

-- Sets default colour
before_header = colors.orange

-- Sets text scale
monitor.setTextScale(0.5)
-- Fixes scaling
width, height = monitor.getSize()

-- Clears monitor (obviously)
monitor.clear()
TopThreePrint()


-- Waits for any event
parallel.waitForAny(OnPlayerJoin, OnPlayerLeave, RefreshHourly, WaitForKeyPress, Blink)
