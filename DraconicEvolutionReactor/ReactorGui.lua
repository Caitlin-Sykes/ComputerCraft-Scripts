-- -----------------------------------------------------------------------------
-- Draconic Evolution Reactor GUI Script
-- -----------------------------------------------------------------------------
-- Imports the Customisation
local Customisation = require("/ReactorMonitoring/Customisation")
-- Imports the Reactor Core Class
local ReactorCore = require("/ReactorMonitoring/ReactorCore")

-- -----------------------------------------------------------------------------
-- Dependency and Init Stuff
-- -----------------------------------------------------------------------------

-- Declare 'sub' in a broader scope so it's accessible to both functions
local sub = {}

-- A function to install basalt
local function DownloadBasalt()
    -- Check if Basalt is already installed in the current directory
    local scriptDir = fs.getDir(shell.getRunningProgram())
    local basaltFilePath = fs.combine(scriptDir, "basalt.lua")

    -- Check if Basalt is already installed
    if fs.exists(basaltFilePath) then
        print("Basalt is already installed in the script's directory.")
    else
        -- Install Basalt using wget run (this installs Basalt to the root folder by default)
        print("Downloading and installing Basalt...")
        if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
            LogMessage("Downloading and installing Basalt...", "[INFO]")
        end

        local result = shell.run("wget run https://basalt.madefor.cc/install.lua release latest.lua")
        
        -- Check if the download command was successful
        if result then
            print("Basalt installation command executed successfully.")
            if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
                LogMessage("Basalt installation command executed successfully.", "[INFO]")
            end
        else
            print("Basalt installation command failed.")
            if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info") then
                LogMessage("Basalt installation failed.", "[ERROR]")
            end
            return -- Exit if the download fails
        end

        -- Check if the basalt.lua was downloaded into the root directory
        if fs.exists("basalt.lua") then
            -- Move basalt.lua to the same directory as the script
            fs.move("basalt.lua", basaltFilePath)
            print("Moved Basalt to the script's directory.")
            if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
                LogMessage("Basalt installation succeeded.", "[INFO]")
            end
        else
            if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info") then
                LogMessage("Basalt installation failed.", "[ERROR]")
            end
            error("Failed to download Basalt. File not found.")
        end
    end

    -- Try to require Basalt and catch any errors
    local success, err = pcall(function()
        basalt = require("basalt") -- Updated to just require("basalt") since it's in the same directory now
    end)

    if not success then
        if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info") then
                LogMessage("Basalt loading failed.", "[ERROR]")
        end
        error("Failed to load Basalt: " .. err)
    end

    print("Basalt loaded successfully!")
end


-- Does Pre-Initialisation Stuffs
function PreInit()
    -- Downloads Basalt Dependency
    DownloadBasalt()

    -- Initialises the main monitor
    print("Initialising the main monitor...")
    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
                LogMessage("Initialising the main monitor.", "[INFO]")
    end
    
    mainFrame = basalt.addMonitor()
    BasaltThread = mainFrame:addThread()
    BasaltThread:start(Init)    

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
                LogMessage("Finished initialising the main monitor.", "[INFO]")
    end
end


-- Switches the active frame
local function openSubFrame(id)
    if(sub[id]~=nil)then
        for k,v in pairs(sub)do
            v:hide()
        end
        sub[id]:show()
    end
end

-- Sets up the multi panel nav
-- Following lines are from Basalt's example
-- https://basalt.madefor.cc/#/objects/Frame
local function LayoutNav()

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
                LogMessage("Initialising the main monitor nav.", "[INFO]")
    end

    sub = {
    mainFrame:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"),
    mainFrame:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
    mainFrame:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h - 1"):hide(),
    }

    -- Creates Main Nav
    menubar = mainFrame:addMenubar():setScrollable()
    :setSize("parent.w")
    :onChange(function(self, val)
        openSubFrame(self:getItemIndex())
    end)
    :addItem("Reactor Health")
    :addItem("Reactor Controls")
    :addItem("Reactor Stats")

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
                LogMessage("Finished initialising the main monitor nav.", "[INFO]")
    end
end

-- Does the threaded init stuffs
function Init()
    mainFrame:setMonitor(ReactorCore:GetMonitor())
    :setBackground(Customisation.MAIN_FRAME_COLOR)

    -- Lays out the nav
    LayoutNav()

    -- Does The Layout Initialisation
    LayoutDisplay()


    -- Starts Basalt Listening For Updates
    basalt.autoUpdate() 

    os.sleep(Customisation.DISPLAY_REFRESH)
end

-- -----------------------------------------------------------------------------
-- Layout Init
-- Hierarchy
-- Panel 1 (LayoutPanelOne)
--  -- Row One (LayoutPanelOneRowOne)
--      Row One Content
--  -- Row Two (LayoutPanelOneRowTwo)
--      Row Two Content
--      etc..
-- -----------------------------------------------------------------------------
function LayoutDisplay()
    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
                LogMessage("Laying out the main panels for the display", "[INFO]")
    end
    LayoutPanelOne()
    -- LayoutPanelTwo()
    -- LayoutPanelThree()

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
                LogMessage("Finished laying out the main panels for the display", "[INFO]")
    end
end

-- Lays Out The Rows for Panel One
function LayoutPanelOne()
    LayoutPanelOneRowOne()
    LayoutPanelOneRowTwo()
    LayoutPanelOneRowThree()
    LayoutPanelOneRowFour()
    LayoutPanelOneRowFive()
end

 -- Row 1: Full-width row (Reactor Status)
function LayoutPanelOneRowOne()
    rowOne = sub[1]:addFrame()
        :setSize("parent.w", 3)
        :setBackground(Customisation.ROW_ONE_COLOR)
        :setPosition(1, 1)

    -- Add content for row 1
    local rsLbl = rowOne:addLabel()
        :setPosition(10, 1)
        :setText("Reactor Status: ")
        :setForeground(Customisation.REACTOR_STATUS_COLOR)
        :setTextAlign("left")

    -- Center the label text vertically
    rsLbl:setPosition(rsLbl:getX(), CentreText(rsLbl, rowOne))

    -- Status label for the reactor status
    statusLabel = rowOne:addLabel()
    :setPosition(27, 1)
    :setForeground(colors.black)
    :setTextAlign("right")

    statusLabel:setPosition(statusLabel:getX(), CentreText(statusLabel, rowOne))
end

-- Row 2: Full-width row with two columns (Temperature and Generation)
function LayoutPanelOneRowTwo()
    rowTwo = sub[1]:addFrame()
        :setSize("parent.w", 3)  -- Increased height to 5
        :setPosition(1, 4)  -- Start row 2 below row 1

    -- Row 2 Col 1: Left column for Temperature
    rowTwoColOne = rowTwo:addFrame()
        :setSize("parent.w / 2", "parent.h")
        :setBackground(Customisation.ROW_TWO_COL_ONE_COLOR)
        :setPosition(1, 1)

    -- Add label for Temperature
    local tmpLbl = rowTwoColOne:addLabel()
        tmpLbl:setPosition(1, 1)
        tmpLbl:setText("Temperature: ")
        tmpLbl:setForeground(Customisation.TEMP_STATUS_COLOR)
        tmpLbl:setTextAlign("left")
        
    -- Center the label text vertically
    tmpLbl:setPosition(tmpLbl:getX(), CentreText(tmpLbl, rowTwoColOne))

    -- Dynamic temperature status label
    tempLabel = rowTwoColOne:addLabel()
    tempLabel:setPosition(18, 1)
    tempLabel:setForeground(colors.white)
    tempLabel:setTextAlign("right")

    -- Center the label text vertically
    tempLabel:setPosition(tempLabel:getX(), CentreText(tempLabel, rowTwoColOne))

    -- Row 2 Col 2: Right column for Generation
    rowTwoColTwo = rowTwo:addFrame()
        :setSize("parent.w / 2", "parent.h")
        :setBackground(Customisation.ROW_TWO_COL_TWO_COLOR)
        :setPosition("parent.w / 2 + 1", 1)

    -- Add label for Generation
    local genLbl = rowTwoColTwo:addLabel()
        :setPosition(2, 1)
        :setText("Generation: ")
        :setForeground(Customisation.GEN_STATUS_COLOR)
        :setTextAlign("left")

     -- Center the label text vertically
    genLbl:setPosition(genLbl:getX(), CentreText(genLbl, rowTwoColTwo))

    -- Dynamic generation status label
    energyLabel = rowTwoColTwo:addLabel()
    :setPosition(14, 1)
    :setForeground(colors.white)
    :setTextAlign("right")

    -- Center the label text vertically
    energyLabel:setPosition(energyLabel:getX(), CentreText(energyLabel, rowTwoColTwo))
end

-- Row 3: Full-width row with two columns (Input and Output Gates)
function LayoutPanelOneRowThree()
    rowThree = sub[1]:addFrame()
        :setSize("parent.w", 3)  -- Increased height to 5
        :setBackground(colors.lime)
        :setPosition(1, 7)  -- Start row 2 below row 1

    -- Row 3 Col 1: Left column for Input Gate
    rowThreeColOne = rowThree:addFrame()
        :setSize("parent.w / 2", "parent.h")
        :setBackground(Customisation.ROW_THREE_COL_ONE_COLOR)
        :setPosition(1, 1)

    -- Add label for Input Gate
    local inptLbl = rowThreeColOne:addLabel()
        :setPosition(1, 1)
        :setText("Input Gate: ")
        :setForeground(Customisation.INPUT_STATUS_COLOR)
        :setTextAlign("left")
        
    -- Center the label text vertically
    inptLbl:setPosition(inptLbl:getX(), CentreText(inptLbl, rowThreeColOne))

    -- Dynamic Input Gate status label
    inputLabel = rowThreeColOne:addLabel()
    :setPosition(14, 1)
    :setForeground(Customisation.INPUT_VALUE_COLOR)
    :setTextAlign("right")

    -- Center the label text vertically
    inputLabel:setPosition(inputLabel:getX(), CentreText(inputLabel, rowThreeColOne))

    -- Row 2 Col 2: Right column for Output Gate
    rowThreeColTwo = rowThree:addFrame()
        :setSize("parent.w / 2", "parent.h")
        :setBackground(Customisation.ROW_THREE_COL_TWO_COLOR)
        :setPosition("parent.w / 2 + 1", 1)

    -- Add label for Output Gate
    local otptLbl = rowThreeColTwo:addLabel()
        :setPosition(2, 1)
        :setText("Output Gate: ")
        :setForeground(Customisation.OUTPUT_STATUS_COLOR)
        :setTextAlign("left")

     -- Center the label text vertically
    otptLbl:setPosition(otptLbl:getX(), CentreText(otptLbl, rowThreeColTwo))


    -- Dynamic Output Gate status label
    outputLabel = rowThreeColTwo:addLabel()
    :setPosition(14, 1)
    :setForeground(Customisation.OUTPUT_VALUE_COLOR)
    :setTextAlign("right")

    -- Center the label text vertically
    outputLabel:setPosition(outputLabel:getX(), CentreText(outputLabel, rowThreeColTwo))
end

-- Row 4: Full-width row (Fuel)
function LayoutPanelOneRowFour()
     rowFour = sub[1]:addFrame()
        :setSize("parent.w", 3)
        :setBackground(Customisation.ROW_FOUR_COLOR)
        :setPosition(1, 10)  

    -- Add content for row 4
    local fsLbl = rowFour:addLabel()
        :setText("Fuel Remaining: ")
        :setForeground(Customisation.FUEL_STATUS_COLOR)
        :setTextAlign("left")

    -- Center the label text vertically
    fsLbl:setPosition(fsLbl:getX(), CentreText(fsLbl, rowFour))

    -- Fuel Progress Bar
    fuelBar = rowFour:addProgressbar()
        :setDirection("left")
        :setSize("parent.w * 2 / 4", 1)
        :setPosition("parent.w * 2 / 4", 2) 
        :setProgress(100)

    -- Percentage Label for Fuel
    percentageLabel = rowFour:addLabel()
        :setPosition(17, 2) 
    :setTextAlign("right")
    :setForeground(colors.black)

    -- Center the label text vertically
    percentageLabel:setPosition(percentageLabel:getX(), CentreText(percentageLabel, rowFour))
end

-- Row 5: Full-width row (Containment Field)
function LayoutPanelOneRowFive()
     rowFive = sub[1]:addFrame()
        :setSize("parent.w", 3) 
        :setBackground(Customisation.ROW_FIVE_COLOR)
        :setPosition(1, 13)

    -- Add content for row 5
    local fdLbl = rowFive:addLabel()
        :setText("Contain Field: ")
        :setForeground(Customisation.FIELD_STATUS_COLOR)
        :setTextAlign("left")

    -- Center the label text vertically
    fdLbl:setPosition(fdLbl:getX(), CentreText(fdLbl, rowFive))

    -- Field Progress Bar
    fieldBar = rowFive:addProgressbar()
        :setDirection("left")
        :setSize("parent.w * 2 / 4", 1)
        :setPosition("parent.w * 2 / 4", 2) 
        :setProgress(100)

    -- Percentage Label for Field
    fieldLabel = rowFive:addLabel()
        :setPosition(17, 2) 
    :setTextAlign("right")
    :setForeground(colors.black)

    -- Center the label text vertically
    fieldLabel:setPosition(fieldLabel:getX(), CentreText(fieldLabel, rowFive))
end

-- -----------------------------------------------------------------------------
-- Reactor Status Display Stuff
-- -----------------------------------------------------------------------------

-- A Function For Displaying the Reactor status
function UpdateReactorStatusDisplay(status) 

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error") then
    --             -- todo finish adding debug: 
                    -- todo add state warming up
                    -- todo make it so it doesnt auto kill
                    -- todo sass mode cant be on when starting
        local msg = "Reactor Status: " .. status
        LogMessage(msg, "[INFO]")
    end

    -- Changes The Status of the Reactor depending on its status
    if (status == "online" or status == "running") then
        statusLabel:setText("Active")
        statusLabel:setForeground(Customisation.ACTIVE_COLOR_REACTOR) 
    elseif status == "offline" then
        statusLabel:setText("Inactive")
        statusLabel:setForeground(Customisation.INACTIVE_COLOR_REACTOR)
    elseif status == "charging" then
        statusLabel:setText("Charging")
        statusLabel:setForeground(Customisation.CHARGE_COLOR_REACTOR)  
    elseif status == "nil" then
        statusLabel:setText("Invalid")
        statusLabel:setForeground(Customisation.INVALID_COLOR_REACTOR)  
    elseif status == "stopping" then
        statusLabel:setText("Stopping")
        statusLabel:setForeground(Customisation.INACTIVE_COLOR_REACTOR)  
    elseif status == "warming_up" then
        statusLabel:setText("Warming Up")
        statusLabel:setForeground(Customisation.WARMING_UP_COLOR_REACTOR) 
    else
        statusLabel:setText("Confused")
        statusLabel:setForeground(Customisation.INVALID_COLOR_REACTOR)  
    end
end


-- A Function For Displaying the Temperature status
local function UpdateTemperatureDisplay(status) 
    local mid_temp = (Customisation.MAX_TEMP + Customisation.MIN_TEMP) / 2

    tempLabel:setText(status .. "C")

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error") then
        local msg = "Temperature Status: " .. status .. "C"
        LogMessage(msg, "[INFO]")
    end


    -- Changes the color of the temp depending on where it is
    if status <= Customisation.MIN_TEMP then
        tempLabel:setForeground(Customisation.DANGER_COLOR_TEMP) 
    elseif status >= Customisation.MAX_TEMP then
        tempLabel:setForeground(Customisation.DANGER_COLOR_TEMP)
    
    -- If the temperature is within the range around mid_temp (+-400)
    elseif status >= (mid_temp - Customisation.TOLERANCE_TEMP) and status <= (mid_temp + Customisation.TOLERANCE_TEMP) then
        tempLabel:setForeground(Customisation.MID_COLOR_TEMP)
    
    elseif status > Customisation.MIN_TEMP and status < (mid_temp - Customisation.TOLERANCE_TEMP) then
        tempLabel:setForeground(Customisation.SORTA_COLOR_TEMP)
    
    elseif status > (mid_temp + Customisation.TOLERANCE_TEMP) and status < Customisation.MAX_TEMP then
        tempLabel:setForeground(Customisation.SORTA_COLOR_TEMP)
    end
end

-- A Function for Displaying the Power Gen
local function UpdatePowerGenDisplay(gen) 
    
    energyLabel:setForeground(Customisation.GOOD_COLOR_ENERGY)
    energyLabel:setText(gen .. " RF/t")

      if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error") then
        local msg = "Power Generation: " .. gen .. " RF/t"
        LogMessage(msg, "[INFO]")
    end
end

-- A Function for Displaying the Input Flux Gate
local function UpdateInputGateDisplay(flow) 
    
    inputLabel:setText(flow .. " RF/t")

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error") then
        local msg = "Input Gate: " .. flow .. " RF/t"
        LogMessage(msg, "[INFO]")
    end
end

-- A Function for Displaying the Output Flux Gate
local function UpdateOutputGateDisplay(flow) 
    
    outputLabel:setText(flow .. " RF/t")

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error") then
        local msg = "Output Gate: " .. flow .. " RF/t"
        LogMessage(msg, "[INFO]")
    end
end

-- A Function For Displaying the Fuel status
local function UpdateFuelDisplay(percent) 

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error") then
        local msg = "Fuel Used: " .. percent .. "%"
        LogMessage(msg, "[INFO]")
    end

    -- Changes The Status of the Fuel depending on its status
    if percent >= 70 then
        fuelBar:setProgress(percent)
        :setProgressBar(Customisation.GOOD_COLOR_FUEL)

        percentageLabel:setForeground(Customisation.GOOD_COLOR_FUEL)

    elseif percent >= 25 then
        fuelBar:setProgress(percent)
        :setProgressBar(Customisation.MIDDLE_COLOR_FUEL)

        percentageLabel:setForeground(Customisation.MIDDLE_COLOR_FUEL)
    else
        fuelBar:setProgress(percent)
        :setProgressBar(Customisation.DANGER_COLOR_FUEL)

        percentageLabel:setForeground(Customisation.DANGER_COLOR_FUEL)
        
    end

    -- Sets label to percentage
    percentageLabel:setText(percent .. "%")
end

-- A Function For Displaying the Containment field status
local function UpdateFieldDisplay(percent) 

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error") then
        local msg = "Field Generation Percent: " .. percent .. "%"
        LogMessage(msg, "[INFO]")
    end

    -- Changes The color of the containment field depending on its status
    -- If percent is above the max threshold
    if percent >= Customisation.MAX_FIELD_PERCENT then
        fieldBar:setProgress(percent)
        fieldBar:setProgressBar(Customisation.DANGER_COLOR_FIELD)  
        fieldLabel:setForeground(Customisation.DANGER_COLOR_FIELD) 

    -- If percent is within the tolerance of the target field percent
    elseif percent >= (Customisation.TARGET_FIELD_PERCENT - Customisation.TOLERANCE_FIELD) and percent < Customisation.MAX_FIELD_PERCENT then
        fieldBar:setProgress(percent)
        fieldBar:setProgressBar(Customisation.MIDDLE_COLOR_FIELD)  
        fieldLabel:setForeground(Customisation.MIDDLE_COLOR_FIELD)  

    -- If percent is below the minimum threshold
    elseif percent < Customisation.MIN_FIELD_PERCENT then
        fieldBar:setProgress(percent)
        fieldBar:setProgressBar(Customisation.DANGER_COLOR_FIELD)  
        fieldLabel:setForeground(Customisation.DANGER_COLOR_FIELD) 

    -- If percent is between the minimum and target thresholds
    elseif percent < Customisation.TARGET_FIELD_PERCENT then
        fieldBar:setProgress(percent)
        fieldBar:setProgressBar(Customisation.MIDDLE_COLOR_FIELD) 
        fieldLabel:setForeground(Customisation.MIDDLE_COLOR_FIELD) 
    end


    -- Sets label to percentage
    fieldLabel:setText(percent .. "%")
end

-- -----------------------------------------------------------------------------
-- Display Utilities
-- -----------------------------------------------------------------------------

-- Center the label both vertically and horizontally within a parent frame
function CentreText(label, frame)
    local frameWidth = frame:getWidth()
    local frameHeight = frame:getHeight()

    -- Get label text width
    local labelText = label:getText() or ""
    local labelWidth = string.len(labelText)

    -- Calculate horizontal centering
    local centeredXPos = math.floor((frameWidth - labelWidth) / 2) + 1

    -- Calculate vertical centering
    local centeredYPos = math.floor((frameHeight - 1) / 2) + 1

    -- Set new position to the label
    label:setPosition(centeredXPos, centeredYPos)
end

-- Centres text just vertically
function CentreTextVertically(objectToCentre, parent)
    -- Get the height of the parent element
    local parentHeight = parent:getHeight()
    
    -- Get the height of the object to be centered
    local objectHeight = objectToCentre:getHeight()
    
    -- Calculate the centered Y position
    local centeredYPos = math.floor((parentHeight - objectHeight) / 2) + 1
    
    return centeredYPos
end

-- Refresh Screen
function RefreshScreen()
    BasaltThread:start(RefreshDisplay())
    BasaltThread.stop()
end

-- Auto Update Function
-- Needed because I can't just thread itself
function RefreshDisplay()
    basalt.autoUpdate() 
end

-- -----------------------------------------------------------------------------
-- Return the GUI Module
-- -----------------------------------------------------------------------------
return {
    PreInit = PreInit,
    UpdateReactorStatusDisplay = UpdateReactorStatusDisplay,
    UpdateTemperatureDisplay = UpdateTemperatureDisplay,
    UpdatePowerGenDisplay = UpdatePowerGenDisplay,
    UpdateInputGateDisplay = UpdateInputGateDisplay,
    UpdateOutputGateDisplay = UpdateOutputGateDisplay,
    UpdateFuelDisplay = UpdateFuelDisplay,
    UpdateFieldDisplay = UpdateFieldDisplay,
    RefreshScreen = RefreshScreen,
}