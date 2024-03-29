extends Control


var max_half_hearts := 4 setget _set_max_half_hearts
var half_hearts := max_half_hearts setget _set_half_hearts


onready var textureHalfEmptyHeart = $TextureHalfEmptyHeart
onready var textureEmptyHeart = $TextureEmptyHeart
onready var textureHalfHeart = $TextureHalfHeart
onready var textureFullHeart = $TextureFullHeart
onready var heart_texture_x_size = textureFullHeart.texture.get_width()


func _set_half_hearts(value):
	half_hearts = value
	textureFullHeart.rect_size.x = (half_hearts / 2) * heart_texture_x_size
	textureHalfHeart.rect_size.x = ((half_hearts + 1) / 2) * heart_texture_x_size

func _set_max_half_hearts(value):
	max_half_hearts = value
	textureEmptyHeart.rect_size.x = (max_half_hearts / 2) * heart_texture_x_size
	textureHalfEmptyHeart.margin_left = (max_half_hearts / 2) * heart_texture_x_size
	if max_half_hearts % 2 == 0:
		textureHalfEmptyHeart.visible = false
	else:
		textureHalfEmptyHeart.visible = true
