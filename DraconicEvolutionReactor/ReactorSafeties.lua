-- -----------------------------------------------------------------------------
-- Draconic Evolution Logic Functions
-- -----------------------------------------------------------------------------
-- Imports the Customisation
local Customisation = require("/ReactorMonitoring/Customisation")
-- Imports the Reactor Core Class
local ReactorCore = require("/ReactorMonitoring/ReactorCore")

-- If the reactor has been restarted due to temp, will keep checking until it is cool enough and restart
local temp_restarted = false

-- -----------------------------------------------------------------------------
-- Safeties
-- -----------------------------------------------------------------------------

-- Controls the temperature kill switch
function TemperatureKillSwitch(temp)
    local msg = nil
    local reactor = ReactorCore:GetReactor()

    -- Over the maximum temperature set in the config
    -- If over the max temp and not restarted
    if temp >= Customisation.MAX_TEMP and not temp_restarted then
        reactor.stopReactor()
        temp_restarted = true
        msg = "Reactor has gotten too hot. Powering down..."

        print(msg)

    -- If over the max temp and already restarted, stays off
    elseif temp >= Customisation.MAX_TEMP and temp_restarted then
        msg = "Reactor has failed to cool. Remaining powered down..."
        print(msg)

    -- If temperature is within tolerance and reactor has been restarted, restart the reactor
    elseif (temp <= Customisation.MIN_TEMP - Customisation.TOLERANCE_TEMP) and temp_restarted then
        temp_restarted = false
        msg = "Reactor has cooled. Restarting..."
        print(msg)
        reactor.activateReactor()
    end

    -- Logs Errors and Info
    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info" and msg ~= nil) then
            LogMessage(msg, "[ERROR]")
    elseif (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info" and msg == nil) then
            LogMessage("Reactor Temperature is healthy", "[INFO]")
    end

    -- If using ender modem, send the message
    if Customisation.USE_ENDER_MODEM and msg ~= nil then
        ReactorCore:SendEnderModemMessage(msg)
        msg = nil
    end

    
end

-- Controls the field generation display
function ShieldKillSwitch(shield, reactorStatus)
    local msg = nil
    local reactor = ReactorCore:GetReactor()
    
    if shield <= Customisation.KILL_FIELD_PERCENT then
        msg = "WARNING: Reactor has too low of a containment field... Stopping the reactor..."
        print(msg)
        reactor.stopReactor()
        reactor.chargeReactor()
        
        -- Recovers Field Generation
        RecoverFieldGeneration(ReactorCore:GetFieldPercentageRemaining(), ReactorCore:GetInputFlux())

    elseif shield <= Customisation.MIN_FIELD_PERCENT then
        msg = "WARNING: Reactor generation field has hit the warning threshold..."
        print(msg)
    
    else
        msg = "Reactor Containment is healthy"
        print(msg)
    end
    

    -- Logs Errors and Info
    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info" and msg ~= nil) then
            LogMessage(msg, "[DEBUG]")
    end

    -- If using ender modem, send the message
    if Customisation.USE_ENDER_MODEM and msg ~= nil then
        ReactorCore:SendEnderModemMessage(msg)
    end

    msg = nil

end

-- Function to recover field generation by adjusting the input gate
function RecoverFieldGeneration(shield, inputFlux)  
    -- Store the original input flux if it's not already stored
    if not originalInputFlux then
        originalInputFlux = ReactorCore:GetInputFluxVal()
    end


    -- Check if field generation is still below the safe threshold
    if shield < Customisation.MIN_FIELD_PERCENT then
        -- Increase the input flux to recover field generation
        ReactorCore:SetInputFlux(9000000)
        msg = ("Increased input flux to 9000000")

        print(msg)

        -- Logs Errors and Info
        if (Customisation.ENABLE_LOGGING) then
                LogMessage(msg, "[INFO]")
        end

        -- Wait for the field to recover
        while shield < Customisation.MIN_FIELD_PERCENT do
            -- Keep checking the field generation until it recovers
            os.sleep(Customisation.FIELD_CHECK_INTERVAL)
            shield = ReactorCore:GetFieldPercentageRemaining()
        end

        -- Once recovered, reset the input flux to its original value
        ReactorCore:SetInputFlux(originalInputFlux)
        msg = ("Field recovered. Resetting input flux to original value: " .. originalInputFlux)
        print(msg)
         -- Logs Errors and Info
        if (Customisation.ENABLE_LOGGING) then
                LogMessage(msg, "[INFO]")
        end

    else
        -- If the field generation recovered during the wait, do nothing
        msg = ("Field generation recovered on its own. No input flux adjustment needed.")
         print(msg)
         -- Logs Errors and Info
        if (Customisation.ENABLE_LOGGING) then
                LogMessage(msg, "[INFO]")
        end
    end
end

-- Low Fuel Kill Switch
function FuelKillSwitch(fuel)
    local msg = nil
    local reactor = ReactorCore:GetReactor()

    -- Stop the reactor if fuel reaches the kill threshold
    if fuel <= Customisation.LOW_FUEL_KILL then
        msg = "Fuel has hit the termination value. Stopping the reactor..."
        print(msg)
        reactor.stopReactor()

    -- Warn if fuel is below the low fuel warning threshold
    elseif fuel <= Customisation.LOW_FUEL_WARNING then
        msg = "WARNING: Reactor is running low on fuel..."
        print(msg)
    end

    -- Logs Errors and Info
    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info" and msg ~= nil) then
            LogMessage(msg, "[ERROR]")
    elseif (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info" and msg == nil) then
            LogMessage("Reactor Fuel is good", "[INFO]")
    end

    -- If using ender modem, send the message
    if Customisation.USE_ENDER_MODEM and msg ~= nil then
        ReactorCore:SendEnderModemMessage(msg)
        msg = nil
    end
end


-- -----------------------------------------------------------------------------
-- Return the Safety Module
-- -----------------------------------------------------------------------------
return {
    TemperatureKillSwitch = TemperatureKillSwitch,
    FuelKillSwitch = FuelKillSwitch,
    ShieldKillSwitch = ShieldKillSwitch,
    RecoverFieldGeneration = RecoverFieldGeneration
}