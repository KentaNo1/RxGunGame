## Ace Permissions
- `gungame.admin` - Allows access to all GunGame Admin commands

## Dependencies
- `PolyZone`

## Optional Dependencies
- `RxGamesBridge` ***Note:*** *RxGamesBridge handles the lobby and swapping of maps.*
- `killfeed` ***Note:*** *Create a lobby called 'gungame'.*

## Exports
- `StartGame(random, map)`: Starts a Game with specified Map, if random is true then it uses a random map.
- `IsGameFinishing()`: Returns whether the game is finishing or not.

**Example**
```lua
exports['RxGunGame']:StartGame(true, nil)
```

## States 
***Note:*** *These states all configurable.*

### Server States
- `RX:GunGame:ActiveGame`
- `RX:GunGame:CurrentMap`
- `RX:GunGame:PlayersInGame`
- `RX:GunGame:RoundTimeLeft`

### Client States
- `RX:GunGame:InGame`
- `RX:GunGame:CurrentLevel`
- `RX:GunGame:OutsideZone`
- `RX:GunGame:Kills`
- `RX:GunGame:Deaths`