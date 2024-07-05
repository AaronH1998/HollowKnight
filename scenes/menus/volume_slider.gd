extends FocusMenuButton

@export var bus_name: String

@onready var volume_label = $VolumeLabelContainer/VolumeLabel
@onready var slider = $SliderContainer/HSlider
@onready var bus_label = $BusLabelContainer/BusLabel
@onready var auto_slide_timer = $Timers/AutoSlideTimer

var can_auto_slide: bool = true

func _input(_event):
	if focussed and can_auto_slide and Input.is_action_pressed("ui_left"):
		Settings.down_volume(bus_name)
		can_auto_slide = false
		auto_slide_timer.start()
		
	if focussed and can_auto_slide and Input.is_action_pressed("ui_right"):
		Settings.up_volume(bus_name)
		can_auto_slide = false
		auto_slide_timer.start()


func _ready():
	super()
	confirm_audio.volume_db = -100
	var volume = Settings.get_volume(bus_name)
	slider.value = volume
	volume_label.text = str(volume * 10)
	bus_label.text = bus_name + " Volume: "
	Settings.connect("volume_update", _update_visual)


func _on_h_slider_value_changed(value):
	Settings.update_volume(bus_name, value)
	volume_label.text = str(value * 10)


func _update_visual(updated_bus_name, value):
	if updated_bus_name == bus_name:
		slider.value = value
		volume_label.text = str(value * 10)
	


func _on_h_slider_mouse_entered():
	focus()


func _on_auto_slide_timer_timeout():
	can_auto_slide = true
