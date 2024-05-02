# Factory On-Off Switch
## Table of Contents

- [Factory On-Off Switch](#factory-on-off-switch)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Example Display](#example-display)
  - [Customisation](#customisation)
    - [Custom GUI Colours](#custom-gui-colours)
    - [Removing the Blinking Indicator](#removing-the-blinking-indicator)
    - [Drain the Power from the circuit using a resistive heater](#drain-the-power-from-the-circuit-using-a-resistive-heater)

## Introduction

This script is used to enable or disable a power source by emitting a redstone signal when a button on a monitor is pressed.

## Features

- **On/Off Switch**
- **Customisation**
- **Optional Power Drain Circuit**

## Requirements

- **1x2 Monitor**

## Example Display
![Screenshot of the monitor, showing top three players and recent logins.](assets/monitor.png)

## Customisation

### Custom GUI Colours

To add more custom colours, simply change the variables located in ```FactoryGui.lua```, located under the ```Constants```:

```lua
ON_BUTTON_COLOUR = colors.green
OFF_BUTTON_COLOUR = colors.red
BACKGROUND_COLOUR = colors.black
```

### Removing the Blinking Indicator

To remove the blinking indicator at the bottom right of the screen, go
to the bottom of ```FactoryGUI.Lua``` and remove "Blink" from
```parallel.waitForAny```

### Drain the Power from the circuit using a resistive heater

To disable this, change "RESISTIVE_HEATER" in ```RedstoneController.lua``` under ```Constants``` to ```false```

