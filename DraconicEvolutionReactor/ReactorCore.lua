-- -----------------------------------------------------------------------------
-- Draconic Evolution Core Functions
-- -----------------------------------------------------------------------------

local ReactorCore = {}
local Customisation = require("/ReactorMonitoring/Customisation")

-- Private variables to store peripherals
local outputFlux
local inputFlux
local reactor
local reactorInfo
local monitor
local enderModem
local fuelPercent

-- Used to make sure messages aren't spammed
local messageTable = {
    ["Reactor has gotten too hot. Powering down..."] = false,
    ["Reactor has failed to cool. Remaining powered down..."] = false,
    ["Reactor has cooled. Restarting..."] = false,
    ["WARNING: Reactor is running low on fuel..."] = false,
    ["Fuel has hit the termination value. Stopping the reactor..."] = false,
}

-- -----------------------------------------------------------------------------
-- Peripheral Things
-- -----------------------------------------------------------------------------

-- Private method to check for peripheral validity
local function ValidatePeripheral(peripheral, name)
    if peripheral == nil then
        if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info") then
            local msg = "PERIPHERAL ERROR: Cannot find a connected " .. name .. "."
            LogMessage(msg, "[ERROR]")
        end
        error(msg)
    end
    return peripheral
end

-- Initialises and sets up peripherals
function ReactorCore:SetupPeripherals()
    -- Setup the reactor peripheral
    reactor = ValidatePeripheral(peripheral.wrap(Customisation.REACTOR), "reactor")

    -- Optionally setup other peripherals
    if Customisation.USE_DISPLAY then
        monitor = ValidatePeripheral(peripheral.wrap(Customisation.MAIN_MONITOR), "monitor")
    end

    if Customisation.USE_ENDER_MODEM then
        enderModem = ValidatePeripheral(peripheral.wrap(Customisation.ENDER_MODEM_SENDER), "ender modem")
    end

    outputFlux = peripheral.wrap(Customisation.ENERGY_OUT)
    inputFlux = peripheral.wrap(Customisation.ENERGY_IN)

    if outputFlux == nil then
        if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info") then
            LogMessage("PERIPHERAL ERROR: Cannot find a connected output flux gate", "[ERROR]")
        end
        error("Cannot find a connected output flux gate.")
    end
    if inputFlux == nil then
         if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE ~= "info") then
            LogMessage("PERIPHERAL ERROR: Cannot find a connected input flux gate", "[ERROR]")
        end
        error("Cannot find a connected input flux gate.")
    end
end

-- -----------------------------------------------------------------------------
-- Calculations
-- -----------------------------------------------------------------------------

-- Method to return the fuel percentage remaining
function ReactorCore:GetFuelPercentageRemaining()
    local reactorInfo = reactor.getReactorInfo()
    fuelPercent = 100 - math.ceil(reactorInfo.fuelConversion / reactorInfo.maxFuelConversion * 10000)*.01
    return fuelPercent
end

-- Method to return the field percentage remaining
function ReactorCore:GetFieldPercentageRemaining()
    local reactorInfo = reactor.getReactorInfo()
    fieldPercent = math.ceil(reactorInfo.fieldStrength / reactorInfo.maxFieldStrength * 10000)*.01
    return fieldPercent
end

-- Function to get the current time in a readable format
function GetCurrentTime()
    return os.date("%Y-%m-%d %H:%M:%S")
end

-- -----------------------------------------------------------------------------
-- Ender Modem
-- -----------------------------------------------------------------------------

-- Sends the message
function ReactorCore:SendEnderModemMessage(msg)

    -- If the message has been sent before, don't send again
    if (messageTable[msg] == false) then

    -- Sets that message to true
    messageTable[msg] = true

    local modem = reactor.getReactorInfo()

    -- Opens channels for receiving
    enderModem.open(Customisation.RECEIVE_MESSAGE)

    -- Sends message
    enderModem.transmit(Customisation.SEND_MESSAGE, Customisation.RECEIVE_MESSAGE, msg)

    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
            local logMsg = "Sending message to ender modem: " .. msg .. " on port: " .. Customisation.SEND_MESSAGE
            LogMessage(logMsg, "[INFO]")
    end

    -- Wait for acknowledgment
    print("Waiting for acknowledgment...")
    local timeout = Customisation.ENDER_MODEM_MESSAGE_TIMEOUT

    local event, side, channel, replyChannel, message, distance
    repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == Customisation.RECEIVE_MESSAGE

    print("Received a reply. Closing Channels..")
    if (Customisation.ENABLE_LOGGING and Customisation.LOGGING_STATE == "info") then
            local logMsg = "Received acknowledgement message from ender modem on port: " .. Customisation.RECEIVE_MESSAGE
            LogMessage(logMsg, "[INFO]")
    end

    -- Close channels
    enderModem.close(Customisation.RECEIVE_MESSAGE)
    enderModem.close(Customisation.SEND_MESSAGE)

    end
end

-- -----------------------------------------------------------------------------
-- Logging
-- -----------------------------------------------------------------------------


-- Function to get the next log file name, creating a new one if none exists
function GetNextLogFile()

    -- Ensure the log directory exists, create if it doesn't
    if not fs.exists(Customisation.LOG_FILE_DIRECTORY) then
        fs.makeDir(Customisation.LOG_FILE_DIRECTORY)
    end

    -- Get all the log files in the directory
    local logs = fs.list(Customisation.LOG_FILE_DIRECTORY)

    -- Filter only log files matching the base log file name (ReactorLog)
    local logFiles = {}
    for _, file in ipairs(logs) do
        if string.find(file, Customisation.NAME_OF_FILE) then
            table.insert(logFiles, file)
        end
    end

    -- Sort log files based on their names (oldest first)
    table.sort(logFiles)

    -- If no log files exist, create the first one
    if #logFiles == 0 then
        local firstLogFile = Customisation.NAME_OF_FILE .. "1.txt"
        return fs.combine(Customisation.LOG_FILE_DIRECTORY, firstLogFile)
    end

    -- Determine the current log file to write to
    local currentLogFile = logFiles[#logFiles]  -- Get the last log file in the list
    local currentLogFilePath = fs.combine(Customisation.LOG_FILE_DIRECTORY, currentLogFile)

    -- Check if the current log file exceeds the size limit
    if fs.exists(currentLogFilePath) and fs.getSize(currentLogFilePath) >= Customisation.LOG_FILE_SIZE then
        -- Rotate the log: increment the log number and create a new file
        local logNumber = tonumber(currentLogFile:match("%d+")) or 0
        currentLogFile = Customisation.NAME_OF_FILE .. (logNumber + 1) .. ".txt"

        -- Delete the oldest log if the number exceeds the allowed limit
        if #logFiles >= Customisation.NUMBER_TO_KEEP then
            local oldestLog = logFiles[1]  -- Get the oldest log file
            fs.delete(fs.combine(Customisation.LOG_FILE_DIRECTORY, oldestLog))
            print("Deleted oldest log file: " .. oldestLog)
        end
    end

    -- Return the full path to the current log file
    return fs.combine(Customisation.LOG_FILE_DIRECTORY, currentLogFile)
end

-- Function to write the log file header
function ReactorCore:LogMessageHeader()
    
    -- Get the appropriate log file (rotate if necessary)
    local logFileName = GetNextLogFile()

     -- Open the file for appending the log message
    local logFile = fs.open(logFileName, "a")

    logFile.writeLine("-----------------------------------------------------------------------------")
    logFile.writeLine("Log created on: " .. GetCurrentTime())
    logFile.writeLine("-----------------------------------------------------------------------------")
end

-- Function to write a log entry
function LogMessage(message, messageLevel)

    -- Get the appropriate log file (rotate if necessary)
    local logFileName = GetNextLogFile()

     -- Open the file for appending the log message
    local logFile = fs.open(logFileName, "a")

    -- Append the log message with a timestamp
    logFile.writeLine(messageLevel .. " " .. GetCurrentTime() .. ": " .. message)

    -- Close the file to save the changes
    logFile.close()
end




-- -----------------------------------------------------------------------------
-- Getters
-- -----------------------------------------------------------------------------

-- Method to return reactor info
function ReactorCore:GetReactorInfo()
    if reactor then
        return reactor.getReactorInfo()
    else
        error("Reactor modem is not connected.")
    end
end

-- Getter methods to provide access to the peripherals from outside
function ReactorCore:GetReactor()
    return reactor
end

function ReactorCore:GetMonitor()
    return monitor
end

function ReactorCore:GetEnderModem()
    return enderModem
end

function ReactorCore:GetOutputFlux()
    return outputFlux
end

function ReactorCore:GetInputFlux()
    return inputFlux
end

return ReactorCore
