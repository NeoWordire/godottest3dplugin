@tool
extends SubViewportContainer
func _enter_tree() -> void:
	stretch = true
	
func _process(delta: float) -> void:
	#$SubViewport/pivot.rotate_y(delta*deg_to_rad(30))
	pass
	
var left_clickled = false
var middle_clickled = false
var drag_start = Vector2.ZERO
var rot_start = Vector3.ZERO
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if middle_clickled:
			var moved = Vector3(drag_start.y - event.position.y,drag_start.x - event.position.x, 0)
			$SubViewport/pivot.rotation = rot_start + moved*.005
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("eventleft clicked")
			left_clickled = true
			
			
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$SubViewport/pivot.scale -= $SubViewport/pivot.scale * 0.05
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			$SubViewport/pivot.scale += $SubViewport/pivot.scale * 0.05
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			middle_clickled = true
			rot_start = $SubViewport/pivot.rotation
			drag_start = event.position
	if event is InputEventMouseButton and not event.pressed:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			middle_clickled = false
			drag_start = Vector2.ZERO
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("uneventleft clicked")
			left_clickled = false
			#rot_start = $SubViewport/pivot.rotation
			
