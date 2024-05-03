-- -----------------------------------------------------------------------------
-- Factory On/Off Switch
-- Can use a resisitive heater
-- -----------------------------------------------------------------------------
-- Imports the Customisation
os.loadAPI("/FactoryOffSwitch/Customisation.lua")

-- Imports the redstone controller
os.loadAPI("/FactoryOffSwitch/RedstoneController.lua")

-- -----------------------------------------------------------------------------
-- GUI Drawing Stuff
-- -----------------------------------------------------------------------------

-- Function to Set Black Screen
local function ResetMonitor()
    monitor.setBackgroundColor(Customisation.BACKGROUND_COLOUR)
    monitor.clear()
end

-- Function to draw buttons
local function DrawButtons()
    
    -- Center Points
    local buttonWidth = (width / 2 - 4)
    local startCentre = 3 + (buttonWidth - string.len("Start")) / 2
    local endCentre = width / 2 + 3 + (buttonWidth - string.len("Shutdown")) / 2

    -- Draw the buttons
    paintutils.drawFilledBox(2, height / 2 - 1, width / 2 - 2, height / 2 + 1, Customisation.ON_BUTTON_COLOUR)  -- Button 1
    paintutils.drawFilledBox(width / 2 + 1, height / 2 - 1, width - 1, height / 2 + 1, Customisation.OFF_BUTTON_COLOUR) -- Button 2
    
    -- Add labels to buttons
    monitor.setCursorPos(startCentre, height / 2)
    monitor.setBackgroundColor(Customisation.ON_BUTTON_COLOUR)
    monitor.setTextColor(Customisation.BUTTON_LABEL_COLOUR)
    monitor.write("Start")
    
    monitor.setCursorPos(endCentre, height / 2)
    monitor.setBackgroundColor(Customisation.OFF_BUTTON_COLOUR)
    monitor.setTextColor(Customisation.BUTTON_LABEL_COLOUR)
    monitor.write("Shutdown")

    -- Resets background colour to black
    monitor.setBackgroundColor(Customisation.BACKGROUND_COLOUR)
end

-- A function to write the title
function WriteTitle()

    -- Gets centre of the title
    local title = "-=Factory Switch=-"
    local titleWidth = string.len(title)
    local x = math.floor((width - titleWidth) / 2)
    
    -- First row, centre
    monitor.setCursorPos(x, 1)
    monitor.setTextColor(Customisation.TITLE_COLOUR)
    monitor.setBackgroundColor(Customisation.BACKGROUND_COLOUR)
    monitor.write(title)
end

-- A function to write the title for smaller screens
function WriteTitleSmol()

    -- Gets centre of the title
    local title = "Factory Switch"
    local titleWidth = string.len(title)
    local x = math.floor((width - titleWidth) / 2)
    
    -- First row, centre
    monitor.setCursorPos(x, 1)
    monitor.setTextColor(Customisation.TITLE_COLOUR)
    monitor.setBackgroundColor(Customisation.BACKGROUND_COLOUR)
    monitor.write(title)
end

-- A function to get the current status of the factory
function FactoryStatus()
     -- Gets centre of the title
    local titleStart = "-=Factory Status: "
    local titleEnd = "=-"
    local title = "-=Factory Status: " .. Customisation.FACTORY_STATUS .. "=-" 

    local titleWidth = string.len(title)
    
    local x = math.floor((width - titleWidth) / 2)
    
    -- If monitor 3x1
    if (height == 5) then
        y =  height
    else
        y = height - 2
    end

    monitor.setCursorPos(x, y)
    monitor.setTextColor(Customisation.FACTORY_STATUS_COLOUR)
    monitor.setBackgroundColor(Customisation.BACKGROUND_COLOUR)
    
    -- Start Writing status
    monitor.write(titleStart)

    -- Colours for the factory status
    if (Customisation.FACTORY_STATUS == "RUNNING") then
        monitor.setTextColor(colors.green)
    else
        monitor.setTextColor(colors.red)
    end

    -- Writes rest of the title
    monitor.write(Customisation.FACTORY_STATUS)
    monitor.setTextColor(Customisation.FACTORY_STATUS_COLOUR)
    monitor.write("=-")    

end

-- For smaller screens
function FactoryStatusSmol()
 -- Gets centre of the title
    local titleStart = "Status: "
    local title = "Status: " .. Customisation.FACTORY_STATUS

    local titleWidth = string.len(title)
    
    local x = math.floor((width - titleWidth) / 2)
    
    -- If monitor 3x1
    if (height == 5) then
        y =  height
    else
        y = height - 2
    end

    monitor.setCursorPos(x, y)
    monitor.setTextColor(Customisation.FACTORY_STATUS_COLOUR)
    monitor.setBackgroundColor(Customisation.BACKGROUND_COLOUR)
    
    -- Start Writing status
    monitor.write(titleStart)

    -- Colours for the factory status
    if (Customisation.FACTORY_STATUS == "RUNNING") then
        monitor.setTextColor(colors.green)
    else
        monitor.setTextColor(colors.red)
    end

    -- Writes rest of the title
    monitor.write(Customisation.FACTORY_STATUS)
    monitor.setTextColor(Customisation.FACTORY_STATUS_COLOUR)
end

-- For the blinky icon in the bottom right corner
function Blink()
    local yes = false
    -- Main loop
    while true do
        monitor.setTextColor(Customisation.BLINK_COLOUR)
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
function MonitorClick()
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")

        -- 3x3
        if (width == 29 and height == 19) then
            -- Start Button
            if ((x>= 2 and x <= 23) and (y == 8 or y == 9)) then
                Customisation.FACTORY_STATUS = "RUNNING"
                RedstoneController.OnFactoryStart()
                FactoryStatus()
            elseif ((x>= 27 and x <= 49) and (y == 8 or y == 9)) then
                Customisation.FACTORY_STATUS = "STOPPED"
                RedstoneController.OnFactoryShutdown()
                FactoryStatus()
            end 
        -- 3x2
        elseif (width == 29 and height == 12) then
            -- Start Button
            if ((x>= 2 and x <= 12) and (y == 5 or y == 7)) then
                Customisation.FACTORY_STATUS = "RUNNING"
                RedstoneController.OnFactoryStart()
                FactoryStatus()
            elseif ((x>= 15 and x <= 28) and (y == 5 or y == 7)) then
                Customisation.FACTORY_STATUS = "STOPPED"
                RedstoneController.OnFactoryShutdown()
                FactoryStatus()
            end 
        -- 2x2
        elseif (width == 18 and height == 12) then
            -- Start Button
            if ((x>= 2 and x <= 7) and (y == 5 or y == 7)) then
                Customisation.FACTORY_STATUS = "RUNNING"
                RedstoneController.OnFactoryStart()
                FactoryStatusSmol()            
            elseif ((x>= 10 and x <= 17) and (y == 5 or y == 7)) then
                Customisation.FACTORY_STATUS = "STOPPED"
                RedstoneController.OnFactoryShutdown()
                FactoryStatusSmol()            
            end 
        -- 4x3
         elseif (width == 39 and height == 19) then
            -- Start Button
            if ((x>= 2 and x <= 17) and (y == 8 or y == 10)) then
                Customisation.FACTORY_STATUS = "RUNNING"
                RedstoneController.OnFactoryStart()
                FactoryStatus()
            elseif ((x>= 20 and x <= 38) and (y == 8 or y == 10)) then
                Customisation.FACTORY_STATUS = "STOPPED"
                RedstoneController.OnFactoryShutdown()
                FactoryStatus()
            end 
        end
    end
end

-- -----------------------------------------------------------------------------
-- Init Function
-- -----------------------------------------------------------------------------

-- Function to setup GUI
function SetupGUI()
        ResetMonitor()
        RedstoneController.CheckOnOff()

        -- If monitor is 
        if (height == 12) then
            WriteTitleSmol()
        elseif (height ~= 5) then
            WriteTitle()
        end

        DrawButtons()

        -- If 2x2
        if (width == 18) then
            FactoryStatusSmol()            
        else
            FactoryStatus()
        end
end

-- -----------------------------------------------------------------------------
-- Init Stuff
-- -----------------------------------------------------------------------------

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