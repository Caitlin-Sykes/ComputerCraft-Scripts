-- -----------------------------------------------------------------------------
-- Draconic Evolution Receiver Ender Modem
-- -----------------------------------------------------------------------------
local Customisation = require("/ReactorMonitoring/Customisation")

-- Ensure modem is attached to the correct side
local modem = peripheral.wrap(Customisation.ENDER_MODEM_RECEIVER)
if not modem then
    print("No modem found on the specified side.")
    return
end

-- Ensure monitor is attached to the correct side
local monitor = peripheral.wrap(Customisation.ENDER_MODEM_MONITOR)
if not monitor and Customisation.USE_DISPLAY then
    print("No monitor found on the specified side.")
    return
end


-- Opens inverse port for receiving   
modem.open(Customisation.SEND_MESSAGE)

print("Waiting for a message on channel " .. Customisation.SEND_MESSAGE)

-- Continuously listen for messages
while true do
    local event, side, receivedChannel, replyChannel, message, distance = os.pullEvent("modem_message")

    -- Check if the message is on the correct channel
    if receivedChannel == Customisation.SEND_MESSAGE then
        print("Received message: " .. message)
        
        -- If uses display, in the future, display big flashy thing
        if (Customisation.USE_DISPLAY) then
            monitor.clear()
            monitor.setTextColor(colors.red)
            monitor.write(message)
        end
    
            
        -- Send acknowledgment back to sender
        local acknowledgment = "Message received."
        -- Sends message back
        modem.transmit(Customisation.RECEIVE_MESSAGE, Customisation.SEND_MESSAGE,  acknowledgment)

        -- Acknowledged
        print("Acknowledgment sent: " .. acknowledgment)
    end
end