-- -----------------------------------------------------------------------------
-- Draconic Evolution Reactor Monitoring Script
-- -----------------------------------------------------------------------------
-- Imports the Customisation
local Customisation = require("/ReactorMonitoring/Customisation")
-- Imports the Reactor GUI Class
local ReactorGui = require("/ReactorMonitoring/ReactorGui")
-- Gets Reactor Core
local ReactorCore = require("/ReactorMonitoring/ReactorCore")
-- Gets Reactor Core
local ReactorSafeties = require("/ReactorMonitoring/ReactorSafeties")


-- -----------------------------------------------------------------------------
-- Update Functions
-- -----------------------------------------------------------------------------

-- Function to check reactor status
function CheckReactorStatus()
    while true do
        local reactorInfo = ReactorCore:GetReactorInfo()

        if (Customisation.USE_DISPLAY) then
            -- Update the GUI with reactor status
            ReactorGui.UpdateReactorStatusDisplay(reactorInfo.status)
        end

        -- Log to Computer
        print("Reactor Info: " .. reactorInfo.status)

        -- Sleeps for custom amount of seconds
        os.sleep(Customisation.DISPLAY_REFRESH) -- Update this as needed
    end
end

-- Function to check temperature
function CheckTemperature()
    while true do
        local reactorInfo = ReactorCore:GetReactorInfo()

        if (Customisation.USE_DISPLAY) then
            -- Update the GUI with temperature
            ReactorGui.UpdateTemperatureDisplay(reactorInfo.temperature)
        end

        -- If Safety Enabled
        if (Customisation.ENABLE_SAFETY) then
            -- Check the Temperature against the safeties
            ReactorSafeties.TemperatureKillSwitch(reactorInfo.temperature)
        end

        -- Log to Computer
        print("Temperature Info: " .. reactorInfo.temperature)

        -- Sleeps for custom amount of seconds
        os.sleep(Customisation.DISPLAY_REFRESH)
    end
end

-- Function to check power gen
function CheckPowerGen()
    while true do
        local reactorInfo = ReactorCore:GetReactorInfo()

        if (Customisation.USE_DISPLAY) then
            -- Update the GUI with temperature
            ReactorGui.UpdatePowerGenDisplay(reactorInfo.generationRate)
        end
        

        -- Log to Computer
        print("Power Generation: " .. reactorInfo.generationRate)

        -- Sleeps for custom amount of seconds
        os.sleep(Customisation.DISPLAY_REFRESH)
    end
end

-- Function to check input gate
function CheckInputGate()
    while true do
        local iFluxGate = ReactorCore:GetInputFlux()

        if (Customisation.USE_DISPLAY) then
            -- Update the GUI with temperature
            ReactorGui.UpdateInputGateDisplay(iFluxGate.getSignalLowFlow())
        end
        

        -- Log to Computer
        print("Input Gate: " .. iFluxGate.getSignalLowFlow())

        -- Sleeps for custom amount of seconds
        os.sleep(Customisation.DISPLAY_REFRESH)
    end
end

-- Function to check output gate
function CheckOutputGate()
    while true do
        local oFluxGate = ReactorCore:GetOutputFlux()

        if (Customisation.USE_DISPLAY) then
            -- Update the GUI with temperature
            ReactorGui.UpdateOutputGateDisplay(oFluxGate.getSignalLowFlow())
        end
        

        -- Log to Computer
        print("Output Gate: " .. oFluxGate.getSignalLowFlow())

        -- Sleeps for custom amount of seconds
        os.sleep(Customisation.DISPLAY_REFRESH)
    end
end

-- Function to check fuel remaining
function CheckFuel()
    while true do
        local fuelRemaining = ReactorCore:GetFuelPercentageRemaining()

        if (Customisation.USE_DISPLAY) then
            -- Update the GUI with temperature
            ReactorGui.UpdateFuelDisplay(fuelRemaining)
        end

       
         -- If Safety Enabled
        if (Customisation.ENABLE_SAFETY) then
            -- Check the Temperature against the safeties
            ReactorSafeties.FuelKillSwitch(fuelRemaining)
        end

        -- Log to Computer
        print("Fuel Remaining: " .. fuelRemaining)

        -- Sleeps for custom amount of seconds
        os.sleep(Customisation.DISPLAY_REFRESH)
    end
end

-- Function to check containment field
function CheckField()
    while true do
        local fieldRemaining = ReactorCore:GetFieldPercentageRemaining()
        local reactorInfo = ReactorCore:GetReactor()

        if (Customisation.USE_DISPLAY) then
            -- Update the GUI with temperature
            ReactorGui.UpdateFieldDisplay(fieldRemaining)
        end

        -- Calls the safeties
        ReactorSafeties.ShieldKillSwitch(fieldRemaining, reactorInfo.status)

        -- Log to Computer
        print("Field Remaining: " .. fieldRemaining)
        
        -- Sleeps for custom amount of seconds
        os.sleep(Customisation.DISPLAY_REFRESH)
    end
end

-- To Refresh The Screen
function RefreshScreen()
    while true do
        ReactorGui.RefreshScreen()
        os.sleep(Customisation.DISPLAY_REFRESH)
    end
end

-- -----------------------------------------------------------------------------
-- Init Stuff
-- -----------------------------------------------------------------------------

-- Sets up Basalt if Display is enabled
-- Also runs initial display setup
if (Customisation.USE_DISPLAY) then
    ReactorCore:SetupPeripherals()
    ReactorGui.PreInit()
end

-- On boot, create new header
if Customisation.ENABLE_LOGGING then
    ReactorCore:LogMessageHeader()


    -- Makes log file directory if it doesn't exist and logging is enabled
    if not fs.exists(Customisation.LOG_FILE_DIRECTORY) then
        fs.makeDir(Customisation.LOG_FILE_DIRECTORY)
    end
end

-- Main loop
parallel.waitForAll(CheckReactorStatus, CheckTemperature, CheckPowerGen, CheckInputGate, CheckOutputGate, CheckFuel, CheckField, RefreshScreen)
