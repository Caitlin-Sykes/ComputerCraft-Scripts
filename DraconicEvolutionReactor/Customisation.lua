-- -----------------------------------------------------------------------------
--  Customisation
-- -----------------------------------------------------------------------------

-- Do not edit line 6
local Customisation = {} 

-- -----------------------------------------------------------------------------
-- Peripherals for the Reactor
-- -----------------------------------------------------------------------------

-- ENERGY_OUT -> Energy Leaving the Reactor
-- ENERGY_IN -> Energy entering the reactor
-- ENDER_MODEM -> Can be left blank if not using that feature, otherwise the side the ender modem is on
-- MAIN_MONITOR -> The monitor that your main display is on
-- ENDER_MODEM_MONITOR -> Monitor the ender modem will display on

Customisation.REACTOR = "draconic_reactor_1" 
Customisation.ENERGY_OUT = "flow_gate_3" 
Customisation.ENERGY_IN = "flow_gate_2"
Customisation.ENDER_MODEM_SENDER = "left"
Customisation.ENDER_MODEM_RECEIVER = "top"

Customisation.MAIN_MONITOR = "monitor_2"
Customisation.ENDER_MODEM_MONITOR = "monitor_4"


-- -----------------------------------------------------------------------------
-- Limits for the Reactor
-- -----------------------------------------------------------------------------

-- Max and Min Field Percent are the containment field
-- Max and Min temp are the reactor's temperature. Max for how hot. Min for how cold it should be before it restarts
-- KILL_FIELD_PERCENT - if it hits this level, terminates the reactor
-- Tolerance_Temp is for +- ideal temperature
-- Tolerance_Field is for +- ideal strength and when to turn it back on again
-- Low Fuel Kill - fuel percentage it kills the reactor at
-- Low fuel warning - sends a warning at this fuel
Customisation.MAX_FIELD_PERCENT = 70
Customisation.TARGET_FIELD_PERCENT = 50
Customisation.MIN_FIELD_PERCENT = 35
Customisation.KILL_FIELD_PERCENT = 30

Customisation.TOLERANCE_FIELD = 10

Customisation.MAX_TEMP = 8000
Customisation.MIN_TEMP = 4000
Customisation.TOLERANCE_TEMP = 400


Customisation.LOW_FUEL_WARNING = 40
Customisation.LOW_FUEL_KILL = 10

-- -----------------------------------------------------------------------------
-- Settings
-- -----------------------------------------------------------------------------

-- USE_ENDER_MODEM - ender modem toggle
-- USE_DISPLAY - display toggle
-- AUTOMATIC_MONITORING - does all the reactor managing for you
-- DISPLAY_REFRESH - how often does the display refresh (in seconds)
-- ENABLE_SAFETY - enables auto shutdown, etc
-- ENDER_MODEM_MESSAGE_TIMEOUT - how long the ender modems wait for a response
-- ENABLE_LOGGING - enables logging

Customisation.USE_ENDER_MODEM = true
Customisation.USE_DISPLAY = true
Customisation.AUTOMATIC_MONITORING = true
Customisation.DISPLAY_REFRESH = 5
Customisation.ENABLE_SAFETY = true
Customisation.ENDER_MODEM_MESSAGE_TIMEOUT = 5 
Customisation.ENABLE_LOGGING = true;

-- -----------------------------------------------------------------------------
-- Automatic Monitoring Settings
-- -----------------------------------------------------------------------------

-- RECOVERY_TIMEOUT - how long the reactor will attempt to wait for an auto recover, before it manually recovers
-- if after the timeout, its still dangerously low, takes emergency measures
-- INCREMENTS - the periods by which the output gate increases
-- WAIT_INTERVAL - how long it waits before increasing again
-- SAFETY_INTERVAL - how many seconds in the wait interval it checks the field generation. Ie, if this is five, and WAIT_INTERVAL is 2, every five seconds of the two minutes
-- ADJUST_INTERVAL - how long it waits before restarting the output cycle gate again
Customisation.RECOVERY_TIMEOUT = 120
Customisation.INPUT_INCREMENT = 1
Customisation.INCREMENTS = {1000, 10000, 1000000}
Customisation.WAIT_INTERVAL = 240 -- 4 mins
Customisation.SAFETY_INTERVAL = 5
Customisation.ADJUST_INTERVAL = 300 -- 5 mins

-- -----------------------------------------------------------------------------
-- Ender Modem Settings
-- -----------------------------------------------------------------------------

-- SEND_MESSAGE is the channel in which this computer is sending a message from
-- RECEIVE_MESSAGE is the channel in which this computer is expecting a response on
Customisation.SEND_MESSAGE = 1
Customisation.RECEIVE_MESSAGE = 2

-- -----------------------------------------------------------------------------
-- Logging Settings
-- -----------------------------------------------------------------------------
-- LOGGING_STATE - Debug, Error, info - Debug is everything, error is only errors and warnings, info is what things are changing to, etc
-- NAME_OF_FILE - Name of logging file
-- LOG_FILE_SIZE - how big it can be (in kb) before a new one is created
-- LOG_FILE_DIRECTORY - log location
-- NUMBER_TO_KEEP - number of logs to keep before the oldest gets deleted
Customisation.LOGGING_STATE = "debug"
Customisation.NAME_OF_FILE = "ReactorLog"
Customisation.LOG_FILE_SIZE = 1024 * 10
Customisation.LOG_FILE_DIRECTORY = "/ReactorLogs"
Customisation.NUMBER_TO_KEEP = 3

-- -----------------------------------------------------------------------------
-- Colour Customisation Settings
-- -----------------------------------------------------------------------------

-- Reactor Status Colours
Customisation.ACTIVE_COLOR_REACTOR = colors.green
Customisation.INACTIVE_COLOR_REACTOR = colors.orange
Customisation.CHARGE_COLOR_REACTOR = colors.red
Customisation.INVALID_COLOR_REACTOR = colors.red
Customisation.WARMING_UP_COLOR_REACTOR = colors.purple

-- Temperature Status Colours
Customisation.GOOD_COLOR_TEMP = colors.green
Customisation.MIDDLE_COLOR_TEMP = colors.orange
Customisation.DANGER_COLOR_TEMP = colors.red
Customisation.SORTA_COLOR_TEMP = colors.green

-- Energy Output Status
Customisation.GOOD_COLOR_ENERGY = colors.blue

-- GUI Background
Customisation.MAIN_FRAME_COLOR = colors.black

-- Main GUI Rows
Customisation.ROW_ONE_COLOR = colors.red
Customisation.REACTOR_STATUS_COLOR = colors.black --the bit that states "Reactor Status"

Customisation.ROW_TWO_COL_ONE_COLOR = colors.brown
Customisation.TEMP_STATUS_COLOR = colors.black -- the bit that states "Temperature"
Customisation.ROW_TWO_COL_TWO_COLOR = colors.cyan
Customisation.GEN_STATUS_COLOR = colors.black -- the bit that states "Generation"


Customisation.ROW_THREE_COL_ONE_COLOR = colors.purple
Customisation.INPUT_STATUS_COLOR = colors.black -- the bit that states "input gate"
Customisation.INPUT_VALUE_COLOR = colors.lime -- the actual value of input gate

Customisation.ROW_THREE_COL_TWO_COLOR = colors.pink
Customisation.OUTPUT_STATUS_COLOR = colors.black -- the bit that states "output gate"
Customisation.OUTPUT_VALUE_COLOR = colors.lime -- the actual value of output gate

Customisation.ROW_FOUR_COLOR = colors.red
Customisation.FUEL_STATUS_COLOR = colors.black --the bit that states "FUEL"
Customisation.GOOD_COLOR_FUEL = colors.green
Customisation.MIDDLE_COLOR_FUEL = colors.orange
Customisation.DANGER_COLOR_FUEL = colors.red

Customisation.ROW_FIVE_COLOR = colors.blue
Customisation.FIELD_STATUS_COLOR = colors.black --the bit that states "Containment Field"
Customisation.GOOD_COLOR_FIELD = colors.green
Customisation.MIDDLE_COLOR_FIELD = colors.orange
Customisation.DANGER_COLOR_FIELD = colors.red

return Customisation
