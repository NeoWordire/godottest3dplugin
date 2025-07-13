@tool
extends VBoxContainer

func _enter_tree() -> void:
	$HSplitContainer/SubViewportContainer.stretch = true
	
func _process(delta: float) -> void:
	#$SubViewport/pivot.rotate_y(delta*deg_to_rad(30))
	pass
	
	
func snap_to_plane(event):
	var camera3d = $HSplitContainer/SubViewportContainer/SubViewport/pivot/Camera3D
	var start = $HSplitContainer/SubViewportContainer/SubViewport/start
	#var from = camera3d.project_local_ray_normal(event.position)
	var ray = RayCast3D.new()
	camera3d.add_child(ray)		
	var to = camera3d.project_local_ray_normal(event.position) * 100
	ray.target_position = to
	ray.collide_with_areas = true
	ray.force_raycast_update()
	if ray.is_colliding():
		start.position = Vector3(Vector3i(round(ray.get_collision_point()*2))/2.0)
		#start.position = ray.get_collision_point()
		print("hit at", ray.get_collider())
		start.visible = true
		start.position.y = height
	else:
		start.visible = false
			
	camera3d.remove_child(ray)
	
var left_clickled = false
var middle_clickled = false
var drag_start = Vector2.ZERO
var rot_start = Vector3.ZERO
var height = 0.0
func _gui_input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		
		if middle_clickled:
			# tilt via middle mouse
			var moved = Vector3(drag_start.y - event.position.y,drag_start.x - event.position.x, 0)
			$HSplitContainer/SubViewportContainer/SubViewport/pivot.rotation = rot_start + moved*.005
		elif $HSplitContainer/PanelContainer/VBoxContainer/Button.button_pressed:
			snap_to_plane(event)
			
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("eventleft clicked")
			left_clickled = true
			if $HSplitContainer/PanelContainer/VBoxContainer/Button.button_pressed:
				$HSplitContainer/PanelContainer/VBoxContainer/Button.button_pressed = false
		var plane = $HSplitContainer/SubViewportContainer/SubViewport/worldplane
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if controlled:
				print("raise bar")
				height += 0.5
				snap_to_plane(event)
			else:
				$HSplitContainer/SubViewportContainer/SubViewport/pivot.scale -= $HSplitContainer/SubViewportContainer/SubViewport/pivot.scale * 0.05
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if controlled:
				print("raiselower bar")
				height -= 0.5
				print(plane.position)
				snap_to_plane(event)
			else:
				$HSplitContainer/SubViewportContainer/SubViewport/pivot.scale += $HSplitContainer/SubViewportContainer/SubViewport/pivot.scale * 0.05
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			middle_clickled = true
			rot_start = $HSplitContainer/SubViewportContainer/SubViewport/pivot.rotation
			drag_start = event.position
	if event is InputEventMouseButton and not event.pressed:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			middle_clickled = false
			drag_start = Vector2.ZERO
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("uneventleft clicked")
			left_clickled = false
			#rot_start = $SubViewport/pivot.rotation

var controlled = false
func _unhandled_key_input(event):
	if event is InputEventKey:
		if event.keycode == KEY_CTRL:
			if event.pressed:
				controlled = true
				print("CCONTRL")
			else:
				print("2CCONTRL")
				controlled = false


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print(event_position)
	pass # Replace with function body.
