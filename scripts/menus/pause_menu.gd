extends CanvasLayer

signal resume_pressed
signal retry_pressed
signal main_menu_pressed

func _on_resume_btn_pressed():
	resume_pressed.emit()
	
func _on_retry_btn_pressed():
	retry_pressed.emit()

func _on_main_menu_btn_pressed():
	main_menu_pressed.emit()
