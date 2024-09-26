extends Node

signal start_pressed
signal options_pressed
signal quit_pressed
signal escape_pressed
signal back_to_menu_pressed

signal ghost_caught(ghost : Ghost)
signal ghost_released(ghost : Ghost)
signal ghost_collected(ghost : Ghost)
signal pirate_collected

signal swung
signal moved

signal show_dialog(text: String)
signal new_note(note: String)
signal score_changed(score)
signal lives_changed(lives)

signal sfx_toggled(on)
signal bgm_toggled(on)
