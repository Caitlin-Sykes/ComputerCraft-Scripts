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

        if (Customisation.ENABLE_SAFETY) then
            -- Check the Temperature against the safeties
            ReactorSafeties.ShieldKillSwitch(fieldRemaining, reactorInfo.status)
        end
  

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
-- Automatic Monitoring Stuff
-- -----------------------------------------------------------------------------

-- Function to automatically adjust energy output
function AutomaticEnergyAdjustment()

    -- Continuously monitor the reactor
    while Customisation.AUTOMATIC_MONITORING and ReactorCore:GetOutputFluxVal() < Customisation.MAX_INCREASE_THRESHOLD do

        -- Get the reactor's current field generation and output flux
        local reactorInfo = ReactorCore:GetReactorInfo()
        local outputFluxObj = ReactorCore:GetOutputFlux()
        local fieldGeneration = reactorInfo.fieldStrength

        -- Iterate through the defined increments
        for _, increment in ipairs(Customisation.INCREMENTS) do

            -- Fetch the current output flux before each adjustment
            outputFluxObj = ReactorCore:GetOutputFlux()
            local currentOutputFlux = outputFluxObj.getSignalLowFlow()

            -- Increase the output gate by the current increment
            local newOutputFlux = currentOutputFlux + increment
            ReactorCore:SetOutputFlux(newOutputFlux)
            local msg = "Increased output gate by " .. increment .. ". New output flux: " .. newOutputFlux
            
            print(msg)
            if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error") then
                LogMessage(msg, "[INFO]")
            end

            -- Wait for the defined interval, checking safety every couple of seconds
            local elapsedTime = 0
            while elapsedTime < Customisation.WAIT_INTERVAL do
                -- Check the current field generation after the increase
                print(elapsedTime)
                reactorInfo = ReactorCore:GetReactorInfo()
                fieldGeneration = reactorInfo.fieldStrength

                -- If the field generation is not safe, stop increasing the output gate
                if fieldGeneration < Customisation.KILL_FIELD_PERCENT then
                    local errorMsg = "Field generation below safe threshold! Output gate increase halted."
                    print(errorMsg)
                    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "error") then
                        LogMessage(errorMsg, "[ERROR]")
                        -- Attempts to recover it
                        RecoverFieldGeneration(ReactorCore:GetFieldPercentageRemaining(), ReactorCore:GetInputFlux().getSignalLowFlow())
                    end
                    return -- Stop the adjustment process if field is unsafe
                end

                -- Wait for the safety check interval before checking again
                os.sleep(Customisation.SAFETY_INTERVAL)
                elapsedTime = elapsedTime + Customisation.SAFETY_INTERVAL
            end
        end

        -- After completing all increments, wait before starting the cycle again
        local cycleCompleteMsg = "Completed output gate cycle. Waiting .. " .. Customisation.ADJUST_INTERVAL .. "before restarting."
        print(cycleCompleteMsg)
        if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error") then
            LogMessage(cycleCompleteMsg, "[INFO]")
        end

        -- Wait for the cycle reset interval before restarting
        os.sleep(Customisation.ADJUST_INTERVAL)
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
parallel.waitForAll(CheckReactorStatus, CheckTemperature, CheckPowerGen, CheckInputGate, CheckOutputGate, CheckFuel, CheckField, AutomaticEnergyAdjustment, RefreshScreen)
