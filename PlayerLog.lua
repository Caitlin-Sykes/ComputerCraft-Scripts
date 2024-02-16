-- Needs advanced peripherals' player detector

function PlayerJoin(username)
    SetColour(username)
    local txt = username .. " has joined the world at " .. GetCurrentTime()
    -- gets current time in utc
    PrintMonitor(txt)
    local file = fs.open("/cait/test.txt", "a")                                       -- Open file in append mode
    file.writeLine(username .. " has joined the world at " .. GetCurrentTime()) -- Write player's name to the file
    file.close()                                                                -- Close the file
end

function PlayerLeave(username)
    SetColour(username)
     local txt = username .. " has left the world at " .. GetCurrentTime()
    -- gets current time in utc
    PrintMonitor(txt)
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
    if (txtColor[username] == nil) then
       monitor.setTextColor(colors.blue)
    else
        monitor.setTextColor(txtColor[username])
    end
end

-- On player join
function OnPlayerJoin()
    while true do
        local event, username = os.pullEvent("playerJoin")

        -- Call function
        PlayerJoin(username)
    end
end

-- On Player leave event
function OnPlayerLeave()
    while true do
        local event, username = os.pullEvent("playerLeave")
        
        -- Call function
        PlayerLeave(username)
    end
end

-- A function to the draw the header
function DrawHeader()
    local txt = "-= Player Log =-"
    SetColour("menu")
    local mp = width / 2
    local wot = string.len(txt) / 2
    local dif = mp - wot

    
    monitor.setCursorPos(dif+1, 1)
    monitor.write(txt)
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
        DrawHeader()
        monitor.setCursorPos(1, height)
        monitor.write(v .. "\n")
        monitor.scroll(1)
    end
end


-- Gets the monitor that's adjacent
monitor = peripheral.find("monitor")
detector = peripheral.find("playerDetector")

txtColor = {
        ["Ridgey28"] = colors.purple,
        ["winer2222"] = colors.red, 
        ["menu"] = colors.orange,
        ["space928"] = colors.green, 
        ["PotatoNerdGames"] = colors.pink, 
    }

-- Fixes scaling
width, height = monitor.getSize()
-- Clears monitor (obviously)
monitor.clear()
DrawHeader()
-- Waits for any event
parallel.waitForAny(OnPlayerJoin, OnPlayerLeave)
