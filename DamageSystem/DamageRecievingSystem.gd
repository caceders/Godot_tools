class_name DamageReceivingSystem extends Node
## A node for reveiving damage from a DamageDealingNode.

## Can be used on entities to controll health, or durability on equipment etc.
## Usually made as a sibling of the resourcepool.

##SIGNALS-----------------------------------------------------------------------

## Emitted when damage is received.
signal DamageReceived(amount: float, from: DamageDealingSystem)
## Emitted when all the damage received was blocked.
signal AllReceivedDamageBlocked(amount: float, from: DamageDealingSystem)
## Emitted when health is depleted
signal HealthDepleted
## Emitted when damage is ignored
signal IgnoredDamage(amount: float, from: DamageDealingSystem)
##------------------------------------------------------------------------------

## The health node to modify.
@export var health: ResourcePool

## When no amount is given when dealt, this is dealt instead.
@export var base_damage_receive_amount: float = 10


## REDUCTION AND INCREASE OF DAMAGE---------------------------------------------

## Reduce incomming damage by flat amount
@export var reduce_damage_flat: float = 0
## Reduce incomming damage by percent
@export var reduce_damage_percent: float = 0
## Increase incomming damage by flat amount
@export var increace_damage_flat: float = 0
## Increase incomming damage by percent
@export var increace_damage_percent: float = 0
##------------------------------------------------------------------------------

## If object should ignore all damage - i.e indestructables or cutscene or similar
@export var ignore_all_damage: bool = false

## If all damage originally is blocked how much should still be dealt.
@export var all_blocked_damage_receive: float = 1

## Autoblock damage below this amount (not inclusive)
@export var ignore_damage_below: float = 0


func _ready():
	health.resource_reached_min.connect(_on_resource_reached_min)


## Reduces the resourcepool fittingly and returns the damage value
func receive_damage(dealt_amount: float, damage_dealing_system: DamageDealingSystem = null) -> float:
	# Apply the flat damage increase/reduction
	var amount: float = dealt_amount + increace_damage_flat - reduce_damage_flat
	# Apply the percent damage increase/reduction
	amount += amount * (increace_damage_percent/100 - reduce_damage_percent/100)
	
	## Check if the damage should be ignored
	if _check_if_should_ignore(amount):
		IgnoredDamage.emit(amount, damage_dealing_system)
		return 0
	
	## Check if the damaged should be blocked
	if _check_if_should_block(amount):
		return _block_damage(amount, damage_dealing_system)
		
	## If not blocked receive damage and return amount
	health.remove_from_amount(amount)
	DamageReceived.emit(amount, damage_dealing_system)
	return amount


func _check_if_should_ignore(amount: float) -> bool:
	if ignore_all_damage:
		return true
	if amount < ignore_damage_below:
		return true
	return false


func _check_if_should_block(amount: float) -> bool:
	if amount <= 0:
		return true
		
	return false


## Blocks the damage received and returns the damage value
func _block_damage(amount: float, damage_dealing_system: DamageDealingSystem = null) -> float:
	AllReceivedDamageBlocked.emit(amount, damage_dealing_system)
	if all_blocked_damage_receive > 0:
		health.remove_from_amount(all_blocked_damage_receive)
		DamageReceived.emit(all_blocked_damage_receive, damage_dealing_system)
		# Removed line below to let dealer know least amount of
		# damage was dealt
		#return all_blocked_damage_receive
	return 0


func _on_resource_reached_min() -> void:
	HealthDepleted.emit()
