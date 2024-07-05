extends FocusMenuButton

@export var bus_name: String

@onready var volume_label = $VolumeLabelContainer/VolumeLabel
@onready var slider = $SliderContainer/HSlider
@onready var bus_label = $BusLabelContainer/BusLabel

func _ready():
	super()
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
	
