extends Node2D

@onready var bullets = $Bullets
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var hud = $UI/HUD
@onready var game_over_screen = $UI/GameOverScreen

signal leech_spawn

var asteroid_large_scene = preload("res://scenes/asteroid_large.tscn")
var asteroid_medium_scene = preload("res://scenes/asteroid_med.tscn")
var asteroid_small_scene = preload("res://scenes/asteroid_small.tscn")

var score := 0:
	set(value):
		score = value
		hud.score = score
		
var lives: int:
	set(value):
		lives = value
		hud.init_lives(lives)

func _ready():
	game_over_screen.visible = false
	score = 0
	lives = 1
	player.connect("bullet_shot", _on_player_bullet_shot)
	player.connect("died", _on_player_died)
	
	
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
	leech_spawn.emit()
	var a = asteroid_small_scene.instantiate()
	a.global_position = pos
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)
	

func _on_asteroid_exploded(pos, size, points):
	# add score from exploding to current score
	score += points
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

func _on_player_died(pos):
	lives -=1
	print(lives)
	if lives <= 0:
		await get_tree().create_timer(1).timeout
		game_over_screen.visible = true
	else:
		await get_tree().create_timer(1).timeout
		player.respawn(pos)
