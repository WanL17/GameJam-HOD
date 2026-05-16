# Scenes

Create the following `.tscn` files in Godot editor:

## scenes/main_menu.tscn
- Root: Node2D + script: `scripts/main_menu.gd`
- Children:
  - TextureRect (background office art)
  - Sprite2D `CoffeeSprite` (coffee cup, hidden by default)
  - Label `NoCoffeeLabel` ("No coffee for you...", hidden by default)
  - Button `StartButton` ("Start Shift")
  - Button `QuitButton` ("Clock Out")

## scenes/rooms/room_00.tscn  (and room_01, room_02)
- Root: Node2D
- Children:
  - TileMapLayer (floor/walls)
  - Player (instance of player.tscn)
  - Spider (instance of spider.tscn) — add NavigationRegion2D for pathfinding
  - Multiple SwappableAsset nodes (Sprite2D + Area2D + script)
  - HidingSpot nodes (Area2D + script)
  - RoomInit (Node with inline script to call `RoomManager.init_room(N)`)

## scenes/rooms/room_coffee.tscn
- Same as above but replace bug-find objective with the CoffeeMachine interactable.
- No spider needed (reward room), or make the spider absent/slow.

## scenes/player.tscn
- Root: CharacterBody2D + script: `scripts/player.gd`
- Add to group: `player`
- Children: Sprite2D, CollisionShape2D, Camera2D (make current)

## scenes/spider.tscn
- Root: CharacterBody2D + script: `scripts/spider_ai.gd`
- Children: Sprite2D, CollisionShape2D, NavigationAgent2D
- Detection Area2D with CollisionShape (radius = 180)
