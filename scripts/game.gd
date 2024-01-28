extends Node2D

@onready var bullets = $Bullets
@onready var player = $Player
@onready var asteroids = $Asteroids

var asteroid_large_scene = preload("res://scenes/asteroid_large.tscn")
var asteroid_medium_scene = preload("res://scenes/asteroid_med.tscn")
var asteroid_small_scene = preload("res://scenes/asteroid_small.tscn")


func _ready():
	player.connect("bullet_shot", _on_player_bullet_shot)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _on_player_bullet_shot(bullet):
	bullets.add_child(bullet)

func _spawn_large_asteroid(pos):
	var a = asteroid_large_scene.instantiate()
	a.global_position = pos
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)

func _spawn_medium_asteroid(pos):
	var a = asteroid_medium_scene.instantiate()
	a.global_position = pos
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)

func _spawn_small_asteroid(pos):
	var a = asteroid_small_scene.instantiate()
	a.global_position = pos
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)

func _on_asteroid_exploded(pos, size):
	#add two new smaller asteroids
	match size:
		Asteroid.AsteroidSize.LARGE:
			_spawn_medium_asteroid(pos)
			_spawn_medium_asteroid(pos)
		Asteroid.AsteroidSize.MEDIUM:
			_spawn_small_asteroid(pos)
			_spawn_small_asteroid(pos)
		Asteroid.AsteroidSize.SMALL:
			pass
		_:
			pass
