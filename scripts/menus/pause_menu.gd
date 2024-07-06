extends CanvasLayer

# TODO change store button to retry button

signal resume_pressed
signal store_pressed
signal main_menu_pressed

func _on_resume_btn_pressed():
	resume_pressed.emit()


func _on_store_btn_pressed():
	store_pressed.emit()

func _on_main_menu_btn_pressed():
	main_menu_pressed.emit()
