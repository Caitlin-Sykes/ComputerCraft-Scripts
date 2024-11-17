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

        -- checks if reactor is in warming up state
        if ReactorCore:GetReactorInfo() == "warming_up" then
            InWarmingUpState()
        end

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

-- Controls for reactor in state "warming_up"
function InWarmingUpState()
    local inputFlux = Customisation.STARTING_REACTOR_VALUE_INPUT
    local outputFlux = Customisation.STARTING_REACTOR_VALUE_OUTPUT
    local waitTime = Customisation.STARTING_REACTOR_VALUE_WAIT

    -- Log and print the startup message
    local msg = "Starting Reactor Cycle. Setting input flux gate to " .. inputFlux .. " and output flux gate to " ..
                    outputFlux .. ". Waiting " .. waitTime .. " seconds before starting operations."
    print(msg)

    if Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error" then
        LogMessage(msg, "[INFO]")
    end

    -- Set starting values
    ReactorCore:SetInputFlux(inputFlux)
    ReactorCore:SetOutputFlux(outputFlux)
    ReactorCore:GetReactor().activateReactor()
    -- Start the timer
    print("Waiting for the start-up period to complete...")
    for remainingTime = waitTime, 1, -1 do
        print("Remaining time: " .. remainingTime .. " seconds...")
        sleep(1) -- Sleep for 1 second at a time
    end

    print("Start-up period complete. Reactor is ready for operations.")
end

-- -----------------------------------------------------------------------------
-- Automatic Monitoring Stuff
-- -----------------------------------------------------------------------------

-- Function to automatically adjust energy output
function AutomaticEnergyAdjustment()
    -- While automatic monitoring is enabled, field percentage is above the minimum, and the reactor isn't warming up
    while Customisation.AUTOMATIC_MONITORING and ReactorCore:GetFieldPercentageRemaining() >
        Customisation.MIN_FIELD_PERCENT and ReactorCore:GetReactorInfo() ~= "warming_up" and
        ReactorCore:GetOutputFluxVal() < Customisation.MAX_INCREASE_THRESHOLD do
        local reactorInfo = ReactorCore:GetReactorInfo()

        -- Factors
        local temp = ReactorCore:GetTemperaturePercentage() / 100
        local field = ReactorCore:GetFieldPercentageRemaining() / 100
        local saturation = ReactorCore:GetEnergyPercentage() / 100
        local conversion = ReactorCore:GetFuelPercentageRemaining() / 100

        -- Fetch weights
        local weight_temp = Customisation.WEIGHT_TEMP
        local weight_saturation = Customisation.WEIGHT_SATURATION
        local weight_field = Customisation.WEIGHT_FIELD
        local weight_conversion = Customisation.WEIGHT_CONVERSION_FIELD

        -- Adjust fIn (low is better)
        local inputFlux_contribution = ((1 - temp) * weight_temp + (1 - saturation) * weight_saturation + (1 - field) *
                                           weight_field) / (weight_temp + weight_saturation + weight_field)
        local fIn = math.max(0.0, math.min(1.0, inputFlux_contribution))

        -- Adjust fOut (high is better)
        local outputFlux_contribution = (field * weight_field + conversion * weight_conversion) /
                                            (weight_field + weight_conversion)
        local fOut = math.max(0.0, math.min(1.0, outputFlux_contribution))

        -- Convert to whole numbers (scale factor: Customisation.SCALE_FACTOR)
        local scale_factor = Customisation.SCALE_FACTOR or 100
        local scaled_fIn = math.floor(fIn * scale_factor + 0.5) -- Round to nearest integer
        local scaled_fOut = math.floor(fOut * scale_factor + 0.5)

        -- Apply adjusted flux values to the reactor
        ReactorCore:SetInputFlux(scaled_fIn)
        ReactorCore:SetOutputFlux(scaled_fOut)

        -- Debugging and Logging
        local inputDebugMsg = "Setting input flux gate to: " .. scaled_fIn
        local outputDebugMsg = "Setting output flux gate to: " .. scaled_fOut
        local cycleCompleteMsg = "Completed output gate cycle. Waiting " .. Customisation.ADJUST_INTERVAL ..
                                     " seconds before restarting."

        print(cycleCompleteMsg)
        print(inputDebugMsg)
        print(outputDebugMsg)

        if Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "error" then
            LogMessage(cycleCompleteMsg, "[INFO]")
            LogMessage(inputDebugMsg, "[DEBUG]")
            LogMessage(outputDebugMsg, "[DEBUG]")
        end

        -- Wait for the cycle reset interval before restarting
        os.sleep(Customisation.ADJUST_INTERVAL)
    end
end

-- Function to startup the reactor
function ReactorInit()
    if ReactorCore:GetReactorInfo().status == "warming_up" then
        -- Sets things
        InWarmingUpState()
    else
        print("Reactor is not in 'warming_up' state. Skipping warm-up procedure.")
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

-- ReactorInitSettings
ReactorInit()

-- Main loop
parallel.waitForAll(CheckReactorStatus, CheckTemperature, CheckPowerGen, CheckInputGate, CheckOutputGate, CheckFuel,
    CheckField, AutomaticEnergyAdjustment, RefreshScreen)
