extends Node2D

var grid3x3_scene = preload("res://components/3x_3_grid.tscn")

@onready var complete_grid = $CompleteGrid

var all_uninitialized_tiles:Array[GridTile]

func _ready():
	randomize()
	for position_node in $Positions.get_children():
		var new_grid3x3 = grid3x3_scene.instantiate()
		new_grid3x3.position = position_node.position
		complete_grid.add_child(new_grid3x3)
	
	# i have no idea what the fuck is this
	# but it doesnt't work without this so don't even try
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	get_all_tiles()
	
	all_uninitialized_tiles.shuffle()
	print("RESULT: ", all_uninitialized_tiles)
	await get_tree().physics_frame


func get_all_tiles():
	for grid3x3:Grid3x3 in complete_grid.get_children():
		for tile:GridTile in grid3x3.children:
			all_uninitialized_tiles.append(tile)


func make_sudoku():
	#all_uninitialized_tiles.shuffle()
	if all_uninitialized_tiles.size() > 0:
		var tile:GridTile = all_uninitialized_tiles.pop_back()
		tile.pick_random_value()
		all_uninitialized_tiles = filter_array(all_uninitialized_tiles)


func filter_array(al:Array[GridTile]):
	var result:Array[GridTile] = []
	for i in range(9, 0, -1):
		var f = all_uninitialized_tiles.filter(func(tile):
			return filter_count(tile, i)
		)
		f.shuffle()
		result.append_array(f)
	
	return result


func filter_count(tile:GridTile, target:int):
	return tile.possible_values.size() == target


func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		print(1)
		make_sudoku()
