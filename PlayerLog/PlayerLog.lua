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


-- Player join func
function PlayerJoin(username)
    -- Sets colour dependent on username
    SetColour(username)

    local txt = username .. " has joined the world"

    -- Writes messages to file and monitor
    PrintMonitor(txt)
    local txtLog = username .. ":joined:" .. TimeCalculator.GetCurrentTime()
    IOFile.WriteFile(txtLog)
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
-- Makes the monitor text wrap nicely
function wrap(str, limit)
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
    local text_to_wrap = wrap(text, width)
    for k, v in pairs(text_to_wrap) do
        monitor.setTextColor(before_header)
        monitor.setCursorPos(1, height)
        monitor.write(v .. "\n")
        monitor.scroll(1)
        DrawHeader()
    end
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

-- -----------------------------------------------------------------------------
-- Init Stuff
-- -----------------------------------------------------------------------------

-- Gets the monitor that's adjacent
monitor = peripheral.wrap("monitor_4")
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
DrawHeader()
-- Waits for any event
parallel.waitForAny(OnPlayerJoin, OnPlayerLeave)