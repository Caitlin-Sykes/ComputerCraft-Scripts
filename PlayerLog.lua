-- Needs advanced peripherals' player detector

function PlayerJoin(username)
    SetColour(username)
    -- gets current time in utc
    monitor.write(username .. " has joined the world at " .. GetCurrentTime())
    local file = fs.open("/cait/test.txt", "a")                                       -- Open file in append mode
    file.writeLine(username .. " has joined the world at " .. GetCurrentTime()) -- Write player's name to the file
    file.close()                                                                -- Close the file
end

function PlayerLeave(username)
    SetColour(username)
    monitor.write(username .. " has joined the world at " .. GetCurrentTime())
    local file = fs.open("/cait/test.txt", "a")                                       -- Open file in append mode
    file.writeLine(username .. " has joined the world at " .. GetCurrentTime()) -- Write player's name to the file
    file.close()                                                                -- Close the file
end

-- Gets current time in utc
function GetCurrentTime()
    return os.epoch("utc")
end

-- A function to set colour depending on username
function SetColour(username)
    if username == "Ridgey28" then
        return monitor.setTextColor(colors.purple)
    elseif username == "winer2222" then
        return monitor.setTextColor(colors.red)
    else
        return monitor.setTextColor(colors.green)
    end
end

-- On player join
function OnPlayerJoin()
    while true do
        local event, username = os.pullEvent("playerJoin")
        -- Write to monitor
        monitor.write("evnt" .. event .. " usr " .. username)

        -- Call function
        PlayerJoin(username)
    end
end

-- On Player leave event
function OnPlayerLeave()
    while true do
        local event, username = os.pullEvent("playerLeave")
        -- Write to monitor
        monitor.write("evnt" .. event .. " usr " .. username)

        -- Call function
        PlayerLeave(username)
    end
end


-- https://www.computercraft.info/forums2/index.php?/topic/15790-modifying-a-word-wrapping-function/
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
        -- print(v) 
        monitor.setCursorPos(1, k)
        monitor.write(v .. "\n")
    end
end


-- Gets the monitor that's adjacent
monitor = peripheral.find("monitor")
detector = peripheral.find("playerDetector")
-- Fixes scaling
width, height = monitor.getSize()
-- Clears monitor (obviously)
monitor.clear()
SetColour("winer2222")
PrintMonitor("Hi monsieur rouge, je ne suis mange pas.")

-- While playerJoin event is true
parallel.waitForAny(OnPlayerJoin, OnPlayerLeave)
