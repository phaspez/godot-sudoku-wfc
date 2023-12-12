extends Area2D

class_name TileDetector

signal tile_detected(tile:GridTile)


func _on_body_entered(body):
	if body is GridTile:
		print_debug(body)
		print("hey body entered")
		tile_detected.emit(body)


func _on_area_entered(area):
	tile_detected.emit(area.get_parent())
