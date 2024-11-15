# Draconic Evolution Reactor
## Table of Contents

- [Draconic Evolution Reactor](#draconic-evolution-reactor)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
  - [Requirements](#requirements)
    - [Base Requirements](#base-requirements)
    - [Additional Modules](#additional-modules)
  - [Instructions](#instructions)
      - [Base:](#base)
      - [Ender Modem:](#ender-modem)
      - [Display:](#display)
      - [Logging:](#logging)
  - [Example Display](#example-display)
  - [Customisation](#customisation)
    - [Disable Ender Modems](#disable-ender-modems)
    - [Disable Display](#disable-display)
    - [Disable Ender Modems](#disable-ender-modems-1)
    - [Customise Display Colours](#customise-display-colours)
    - [Display Refresh](#display-refresh)
    - [Disable Logging](#disable-logging)
    - [Ender Modem Configuration](#ender-modem-configuration)
    - [Reactor Limits Configuration](#reactor-limits-configuration)
  - [Disclaimer](#disclaimer)
  - [Credits](#credits)


## Introduction

This script is used to monitor the reactor from Draconic Evolution, and has several features.

## Features
- **GUI Display using Basalt to monitor the health and other statistics of your reactor.**
- **Automatic shutdown mode when configurable limits are hit**
- **Inter-dimension warning system for when the reactor is at dangerous levels**
- **Customisable Display**
- **Configurable Logging System**

## Requirements
  ### Base Requirements
    - Four modems
    - A computer
    - Whatever is needed for a standard Draconic Reactor setup

  ### Additional Modules
    #### Ender Modems:
    - 2 Ender Modems
    - Additional computer
    #### Display:
    - Monitors

## Instructions

> [!NOTE]   
> At the top of each script, remember to change the path. Ie, any `require` will need to be changed unless your code is within a folder called `ReactorMonitoring`. An example of a line to change is below:  
> 
> ```lua
> local Customisation = require("/ReactorMonitoring/Customisation")
> ```

#### Base:
1. Connect two modems to the two flux gates going into your reactor. Connect them to the computer you are using. In ```Customisation.lua```, edit the ```Peripherals for the Reactor``` to whatever name appears.
2. Do the same, but for the Reactor Energy Injector.
3. If so desired, configure any required limits within ```Customisation.lua```.
4. Run the script.

#### Ender Modem:
1. Enable the ```USE_DISPLAY``` setting within  ```Customisation.lua```
2. Connect a ender modem to your computer that the reactor is connected to. Make sure to update the peripheral name within ```Customisation.lua```. This will be your ```Sender``` computer, so update the ```ENDER_MODEM_SENDER``` variable.
3. Update the ```ENDER_MODEM_RECEIVER``` variable, and if required, the ```ENDER_MODEM_MONITOR``` variable to the name of the display.
4. Wherever you want your "Receiver" computer to be, connect an ender modem to that, and if so desired, a display. Add another copy of the ```Customisation.lua``` script, as well as the ```EnderModemReceiverScript```
5. If so desired, update the configuration that appears within ```Customisation.lua``` underneath the ```Ender Modem Settings```
6. Add the ```EnderModemReceiverScript``` to your startup on the receiver computer, and run it.

#### Display:
1. Enable the ```USE_DISPLAY``` setting within the ```Customisation.lua``` file.
2. Connect the display to your computer with a modem
3. Change the variable ```MAIN_MONITOR``` in ```Customisation.lua``` to the name of your monitor 

#### Logging:
1. Enable the ```ENABLE_LOGGING``` setting within the ```Customisation.lua``` file.
2. Configure any settings within ```Customisation.lua```
   
## Example Display

## Customisation
### Disable Ender Modems
To disable the ender modem functionality, simply change the variables located in ```Customisation.lua```.
```lua
  USE_ENDER_MODEM = false
```

### Disable Display

### Disable Ender Modems
To disable the GUI functionality, simply change the variables located in ```Customisation.lua```. This will also stop Basalt from being downloaded if it hasn't already.
```lua
  USE_DISPLAY = false
```

### Customise Display Colours
All customisable colours can be found in ```Customisation.lua``` under the ```Colour Customisation Settings``` heading.

### Display Refresh
The display refresh can be changed in ```Customisation.lua``` under the ```DISPLAY_REFRESH``` heading.

```lua
DISPLAY_REFRESH = [VALUE]
```

### Disable Logging
The logging can be disabled in ```Customisation.lua``` under the ```ENABLE_LOGGING``` heading.

Similarly, the logging level can be changed under the ```LOGGING_STATE``` heading.

### Ender Modem Configuration

To changes the settings for the Ender Modem part, you can change the values in ```Customisation.lua``` under the ```Ender Modem Settings``` heading. 

### Reactor Limits Configuration

To changes the reactor limits, you can change the values in ```Customisation.lua``` under the ```Limits for the Reactor``` heading. 

## Disclaimer

I take no responsability for nuclear detonations caused by the failure of this script. Please use responsably and ~~only on your worst enemies~~ and be cautious of changing the values.

## Credits
Some code was used from the following source:
[AcidJazz's Reactor Script](https://raw.githubusercontent.com/acidjazz/drmon/master/drmon.lua)

Thanks to Pyroxenium for Basalt:
[Pyroxenium's Basalt](https://github.com/Pyroxenium/Basalt/tree/master/Basalt)
