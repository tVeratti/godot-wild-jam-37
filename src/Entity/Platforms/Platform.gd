extends Entity

export(float) var size = 300

func _ready():
	EntitySprite.rect_size.x = size


func _process(delta):
	._process(delta)
	
	if is_instance_valid(Collision) and is_instance_valid(EntitySprite) \
		and State.timeline.timestamp > (enter_timestamp - 1) \
		and State.timeline.timestamp < (exit_timestamp + 1):
			
		var pos = EntitySprite.rect_position
		var width = EntitySprite.rect_size.x
		var height = EntitySprite.rect_size.y
		var pivot_offset = Vector2(width / 2, height / 2)
		
		Collision.polygon = PoolVector2Array([
			Vector2(pos.x - pivot_offset.x, pos.y - pivot_offset.y),
			Vector2(pos.x + width - pivot_offset.x, pos.y - pivot_offset.y),
			Vector2(pos.x + width - pivot_offset.x, pos.y + height - pivot_offset.y),
			Vector2(pos.x - pivot_offset.x, pos.y + height - pivot_offset.y)
		])
		
		
		Collision.position = pivot_offset
		EntitySprite.rect_pivot_offset = pivot_offset
		
