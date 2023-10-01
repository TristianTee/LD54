extends Node

signal rng_seed_changed

var holding := false
var rng = RandomNumberGenerator.new()

var rng_seed:
	get:
		return rng_seed
	set(value):
		rng.seed = hash(value)
		rng_seed = value
		rng.state = 42
		rng_seed_changed.emit()
