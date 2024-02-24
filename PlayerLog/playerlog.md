# Player Logger
## Table of Contents

- [Player Logger](#player-logger)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Customisation](#customisation)
    - [Custom Player Colours](#custom-player-colours)

## Introduction

This script monitors players logging in and out, as well as keeping a written log at ```/logger/log.txt```

## Features

- **Player Logging Script**
- **Custom Colours for different players**

## Requirements

- **Advanced Peripherals - Player Detector**
- **Monitor**

## Customisation

### Custom Player Colours

To add more custom player colours, simply follow the template below:

```lua
["player_name"] = colors.here,
```

...and append it to the txtColor dictionary
shown below.

```lua
txtColor = {
    ["Ridgey28"] = colors.purple,
    ["winer2222"] = colors.red, 
    ["menu"] = colors.orange,
}
```
