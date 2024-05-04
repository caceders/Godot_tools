class_name TextResetter
extends Capability

func _init():
	_type = Type.PASSIVE
	_ID = 2
	_operand_string = "Coins"

func _utilize():
	begin_add_intervals_timer()

var timer: Timer

func begin_add_intervals_timer():
	timer = Timer.new()
	_operand.add_child(timer)
	timer.name = "Amount adder"
	timer.start(5)
	timer.timeout.connect(add_to_amount)

func add_to_amount():
	var coins = _operand as ResourcePool
	coins.add_to_amount(coins.max_amount - coins.amount)
	timer.start(5)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		timer.queue_free()
