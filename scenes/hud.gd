extends CanvasLayer
class_name Hud

@onready var live_symbols = [$Hud/Lives/L1, $Hud/Lives/L2, $Hud/Lives/L3]
signal start_game_pressed
signal respawn

func _ready():
	$Menu.visible = false

func update_lives(lives: int):
	for i in live_symbols.size():
		live_symbols[i].visible = lives > i
		
func update_items(double_jump: bool, dash: bool, pickaxe: bool, key: bool):
	$Hud/VBoxContainer/DoubleJump.visible = double_jump
	$Hud/VBoxContainer/Dash.visible = dash
	$Hud/VBoxContainer/Pickaxe.visible = pickaxe
	$Hud/VBoxContainer/Key.visible = key

func show_menu():
	$DimRect.color.a = 0.3
	$Menu.visible = true
	

func hide_menu():
	$DimRect.color.a = 0
	$Menu.visible = false
	
func start_game():
	$StartMenu.visible = false
	$DeathMenu.visible = false
	$Menu.visible = false
	$Hud.visible = true

func start_menu():
	$StartMenu.visible = true
	$DeathMenu.visible = false
	$Menu.visible = false
	$Hud.visible = false

func death_menu():
	$DimRect.color.a = 0.3
	$StartMenu.visible = false
	$Menu.visible = false
	$Hud.visible = false
	$DeathMenu.visible = true

func _on_button_pressed():
	hide_menu()
	get_tree().paused = false

func _on_start_game_pressed():
	start_game()
	get_tree().paused = false
	start_game_pressed.emit()


func _on_player_health_changed(new_health: int):
	update_lives(new_health)

func _on_player_died():
	death_menu()


func _on_respawn_button_pressed():
	$StartMenu.visible = false
	$Menu.visible = false
	$Hud.visible = true
	$DeathMenu.visible = false
	$DimRect.color.a = 0
	respawn.emit()
	
func _on_quit_button_pressed():
	get_tree().quit()
