extends Node

@onready var audio_player := AudioStreamPlayer.new()

func _ready():
	add_child(audio_player)
	audio_player.finished.connect(_on_music_finished)

# Now with a volume parameter (in decibels)
func play_music(music_stream: AudioStream, loop: bool = true, volume: float = 0.0):
	# If the same track is playing and you want to update the volume, you might omit the early return
	if audio_player.stream == music_stream:
		audio_player.volume_db = volume
		return

	audio_player.stream = music_stream
	audio_player.volume_db = volume

	# For streams that support a loop property, set it directly
	if music_stream is AudioStreamWAV or music_stream is AudioStreamOggVorbis:
		music_stream.loop = loop

	audio_player.play()

func _on_music_finished():
	# Restart playback if looping is enabled
	if audio_player.stream and ((audio_player.stream is AudioStreamWAV or audio_player.stream is AudioStreamOggVorbis) and audio_player.stream.loop):
		audio_player.play()
