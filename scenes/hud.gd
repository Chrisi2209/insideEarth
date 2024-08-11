extends CanvasLayer
class_name Hud

@onready var live_symbols = [$MarginContainer/Lives/L1, $MarginContainer/Lives/L2, $MarginContainer/Lives/L3]
signal start_game_pressed

func _ready():
	$Menu.visible = false

func update_lives(lives: int):
	for i in live_symbols.size():
		live_symbols[i].visible = lives > i
		
func update_items(double_jump: bool, dash: bool, pickaxe: bool, key: bool):
	$MarginContainer/VBoxContainer/DoubleJump.visible = double_jump
	$MarginContainer/VBoxContainer/Dash.visible = dash
	$MarginContainer/VBoxContainer/Pickaxe.visible = pickaxe
	$MarginContainer/VBoxContainer/Key.visible = key

func show_menu():
	$DimRect.color.a = 0.3
	$Menu.visible = true
	

func hide_menu():
	$DimRect.color.a = 0
	$Menu.visible = false
	
func start_game():
	$StartMenu.visible = false
	$Menu.visible = false
	$Hud.visible = true

func start_menu():
	$StartMenu.visible = true
	$Menu.visible = false
	$Hud.visible = false



func _on_button_pressed():
	hide_menu()
	get_tree().paused = false


func _on_start_game_pressed():
	start_game()
	get_tree().paused = false
	start_game_pressed.emit()
