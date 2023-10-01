extends RigidBody2D

signal ouch

func _integrate_forces(state):
	var count = state.get_contact_count()
	for i in count:
		var impulse = state.get_contact_impulse(i)
		var linear = sqrt((impulse.x * impulse.x) + (impulse.y * impulse.y))
		if linear > 500:
			ouch.emit(linear)
