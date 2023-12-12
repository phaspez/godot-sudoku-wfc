extends StaticBody2D

## A single tile in a grid
class_name  GridTile

signal grid_3x3_clear_requested

var possible_values:Array[int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]

var up_neighbor:GridTile
var down_neighbor:GridTile
var left_neighbor:GridTile
var right_neighbor:GridTile

var current_value:int = -1

@onready var left_detector:TileDetector = $GridDetectorLeft
@onready var right_detector:TileDetector = $GridDetectorRight
@onready var up_detector:TileDetector = $GridDetectorUp
@onready var down_detector:TileDetector = $GridDetectorDown

@onready var label = $Label

func _ready():
	left_detector.tile_detected.connect(func(body:GridTile): 
		left_neighbor = body)
	right_detector.tile_detected.connect(func(body:GridTile): 
		right_neighbor = body)
	up_detector.tile_detected.connect(func(body:GridTile): 
		up_neighbor = body)
	down_detector.tile_detected.connect(func(body:GridTile): 
		down_neighbor = body)
		
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	print("this grid has L:", left_neighbor, "R: ", right_neighbor, "U: ", up_neighbor,"D: ", down_neighbor)
#region ultility functions
func remove_self(val:int) -> void:
	var idx = possible_values.find(val)
	if idx >= 0:
		possible_values.pop_at(idx)
	else:
		print_debug("value ", val, " is not in this tile ", self, ", is it aready removed?")
	update_possible_value_label()

func remove_left(val:int) -> void:
	remove_self(val)
	if left_neighbor:
		left_neighbor.remove_left(val)

func remove_right(val:int) -> void:
	remove_self(val)
	if right_neighbor:
		right_neighbor.remove_right(val)

func remove_up(val:int) -> void:
	remove_self(val)
	if up_neighbor:
		up_neighbor.remove_up(val)

func remove_down(val:int) -> void:
	remove_self(val)
	if down_neighbor:
		down_neighbor.remove_down(val)
#endregion

## remove all "val" element from possible_values of every tile column and row.
func remove_cross_neighbor_possible_values(val:int):
	remove_left(val)
	remove_right(val)
	remove_up(val)
	remove_down(val)


func remove_3x3_neightbor_possible_values(val:int):
	grid_3x3_clear_requested.emit(val)


func pick_random_value():
	current_value = possible_values.pick_random()
	remove_cross_neighbor_possible_values(current_value)
	remove_3x3_neightbor_possible_values(current_value)
	update_label()
	

func update_label():
	label.text = str(current_value)
	label.modulate = Color.WHITE
	$Hints/LabelHint.hide()

func update_possible_value_label():
	var str = ""
	for v in possible_values:
		str += str(v) + " "
	$Hints/LabelHint.text = str(possible_values)
