extends Node


static func create_collision_polygon(position:Vector2, texture:Texture):
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture.get_data())
	
	var rect = Rect2(position.x, position.y, texture.get_width(), texture.get_height())
	var points = bitmap.opaque_to_polygons(rect)
	var polygon = Polygon2D.new()
	polygon.set_polygons(points)
	
	return polygon
#	get_parent().get_node("CollisionPolygon2D").set_polygon(my_polygon.polygons[0])
