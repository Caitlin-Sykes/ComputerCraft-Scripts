-- -----------------------------------------------------------------------------
-- GUI Drawing Stuff
-- -----------------------------------------------------------------------------

-- Function to Set Black Screen
local function ResetMonitor()
    monitor.setBackgroundColor(BACKGROUND_COLOUR)
    monitor.clear()
end

-- Function to draw buttons
local function DrawButtons()
    
    -- Center Points
    local buttonWidth = (width / 2 - 4)
    local startCentre = 3 + (buttonWidth - string.len("Start")) / 2
    local endCentre = width / 2 + 3 + (buttonWidth - string.len("Shutdown")) / 2

    -- Draw the buttons
    paintutils.drawFilledBox(2, height / 2 - 1, width / 2 - 2, height / 2 + 1, ON_BUTTON_COLOUR)  -- Button 1
    paintutils.drawFilledBox(width / 2 + 1, height / 2 - 1, width - 1, height / 2 + 1, OFF_BUTTON_COLOUR) -- Button 2
    
    -- Add labels to buttons
    monitor.setCursorPos(startCentre, height / 2)
    monitor.setBackgroundColor(ON_BUTTON_COLOUR)
    monitor.setTextColor(colors.white)
    monitor.write("Start")
    
    monitor.setCursorPos(endCentre, height / 2)
    monitor.setBackgroundColor(OFF_BUTTON_COLOUR)
    monitor.setTextColor(colors.white)
    monitor.write("Shutdown")

    -- Resets background colour to black
    monitor.setBackgroundColor(BACKGROUND_COLOUR)
end

-- A function to write the title
function WriteTitle()

    -- Gets centre of the title
    local title = "-=Factory Switch=-"
    local titleWidth = string.len(title)
    local x = math.floor((width - titleWidth) / 2)
    
    -- First row, centre
    monitor.setCursorPos(x, 1)
    monitor.setTextColor(TITLE_COLOUR)
    monitor.setBackgroundColor(BACKGROUND_COLOUR)
    monitor.write(title)
end

-- A function to get the current status of the factory
function FactoryStatus()
     -- Gets centre of the title
    local titleStart = "-=Factory Status: "
    local titleEnd = "=-"
    local title = "-=Factory Status: " .. FACTORY_STATUS .. "=-" 

    local titleWidth = string.len(title)
    
    local x = math.floor((width - titleWidth) / 2)
    
    -- First row, centre
    monitor.setCursorPos(x, height-2)
    monitor.setTextColor(FACTORY_STATUS_COLOUR)
    monitor.setBackgroundColor(BACKGROUND_COLOUR)
    
    -- Start Writing status
    monitor.write(titleStart)

    -- Colours for the factory status
    if (FACTORY_STATUS == "RUNNING") then
        monitor.setTextColor(colors.green)
    else
        monitor.setTextColor(colors.red)
    end

    monitor.write(FACTORY_STATUS)

    monitor.setTextColor(FACTORY_STATUS_COLOUR)
    monitor.write(" =-")    

end

-- For the blinky icon in the bottom right corner
function Blink()
    local yes = false
    -- Main loop
    while true do
        monitor.setTextColor(BLINK_COLOUR)
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
-- Event Clicking Stuff
-- -----------------------------------------------------------------------------

-- A function for the monitor click events
local function MonitorClick()
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")

        -- Start Button
        if ((x>= 2 and x <= 23) and (y == 8 or y == 9)) then
            FACTORY_STATUS = "RUNNING"
        elseif ((x>= 27 and x <= 49) and (y == 8 or y == 9)) then
            FACTORY_STATUS = "STOPPED"
        end
    end
end

-- -----------------------------------------------------------------------------
-- Init Function
-- -----------------------------------------------------------------------------

-- Function to setup GUI
local function SetupGUI()
        ResetMonitor()
        WriteTitle()
        DrawButtons()
        FactoryStatus()
    -- end
end

-- -----------------------------------------------------------------------------
-- Init Stuff
-- -----------------------------------------------------------------------------

-- Constants
ON_BUTTON_COLOUR = colors.green
OFF_BUTTON_COLOUR = colors.red
BACKGROUND_COLOUR = colors.black
TITLE_COLOUR = colors.purple
BLINK_COLOUR = colors.orange
FACTORY_STATUS_COLOUR = colors.white
FACTORY_STATUS = "RUNNING"
-- set energy usage
-- Used to burn energy and drain factory system
-- heater = peripheral.wrap("resistiveHeater"); 
-- monitor = peripheral.wrap("monitor_9")
monitor = peripheral.wrap("left")

-- Sets text scale
monitor.setTextScale(1)

-- Fixes scaling
width, height = monitor.getSize()

-- Redirects to monitor
term.redirect(monitor)

-- Clears monitor (obviously)
monitor.clear()

-- Sets up the GUI
SetupGUI()

-- Main loop
parallel.waitForAny(MonitorClick, Blink)