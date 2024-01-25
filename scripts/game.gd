extends Node2D

@onready var bullets = $Bullets
@onready var player = $Player

func _ready():
	player.connect("bullet_shot", _on_player_bullet_shot)
	
func _on_player_bullet_shot(bullet):
	bullets.add_child(bullet)
