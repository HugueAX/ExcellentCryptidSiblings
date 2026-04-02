extends Node2D
signal score_changed
var score



func set_score(value):
	score = value
	score_changed.emit(score)

func _ready():
	$FresnoNightCrawler.life_changed.connect($CanvasLayer/HUD.update_life)
	score_changed.connect($CanvasLayer/HUD.update_score)
	$FresnoNightCrawler.reset($SpawnPoint.position)
#	var level_num = str(GameState.current_level).pad_zeros(2)
	#var path = "res://levels/level_%s.tscn" % level_num
#	var level = load("res://level.tscn").instantiate()
#	add_child(level)


func _on_fresno_night_crawler_died() -> void:
	GameState.restart()
