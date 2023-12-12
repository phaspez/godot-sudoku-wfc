extends Node2D

# this class must only contain grid tile as children
class_name Grid3x3

@export var tile:PackedScene = preload("res://components/grid_tile.tscn")
var children:Array[GridTile]


func _ready():
	for position_node in $Positions.get_children():
		var new_tile:GridTile = tile.instantiate()
		new_tile.position = position_node.position
		$TilesContainer.add_child(new_tile)
		await get_tree().process_frame
	
	for child:GridTile in $TilesContainer.get_children():
		child.grid_3x3_clear_requested.connect(clear_value_from_grid)
		children.append(child)
	

func clear_value_from_grid(val:int):
	for child:GridTile in children:
		child.remove_self(val)
