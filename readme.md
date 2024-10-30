# Computercraft Scripts Repository
## Table of Contents

- [Computercraft Scripts Repository](#computercraft-scripts-repository)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
  - [Scripts Overview](#scripts-overview)
  - [Installation](#installation)
  - [License](#license)

## Introduction

The following repository is a collection of small scripts that do various things. There are ReadMe's within each folder that describes what the scripts do.

## Features

- **Player Logging Script ¹**
- **An On/Off Switch using Monitors**
> [!note]  
> Scripts marked with a ¹ should be chunkloaded

## Scripts Overview

1. **Player Logger**:
    - **Description**: This script currently keeps a record of players log in times and log out times, and writes this to a file. It also calculates the top three players in terms of play times, and displays them at the top of the monitor.
    - **Usage**: Install this script on a Computercraft computer. Run the script to start logging player activities.
2. **An On/Off Switch using Monitors**:
    - **Description**: This script currently displays two buttons on a monitor, and whether it is currently enabled or disabled. The user can right click on the buttons to toggle factory states. Power is controlled by the computer emitting redstone signals.
    - **Usage**: Install this script on a Computercraft computer. Connect the computer to a monitor, and optionally, a resistive heater, to toggle the state of the factory.
3. **Potion Autobrewer:**
   - **Description:** This script uses recipes within your AE2 network to craft potions using the Create mixer. This is done by creating new versions of the potions that can be transferred back into the vanilla counterparts by filling them using Create.
   - **Usage**: Install this script to a computer. You will then have to follow the setup process within the ReadMe in order to have this work successfully. 


## Installation

To install the scripts to a computercraft computer, you can either connect your IDE to computercraft, and copy them across like that, or download the following [GitGet Version 2 Release](https://www.computercraft.info/forums2/index.php?/topic/17387-gitget-version-2-release/) to your computercraft computer, and run the following command

```bash
    gitget Caitlin-Sykes ComputerCraft-Scripts
```


## License

This project is licensed under the [MIT License](LICENSE).
