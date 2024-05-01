class_name DamageDealingSystem extends Node
## A node for dealing damage from a DamageReceivingNode.

## Can be used on entities to deplete health, or durability on equipment etc.

##SIGNALS-----------------------------------------------------------------------

## Emitted when damage is dealt.
signal DamageDealt(amount: float)
## Emitted when dealt no or minimum damage to damage receiver
signal DamageDealtMin()

##Variables---------------------------------------------------------------------
##Target damage receive system
@export var damage_receive_system : DamageReceivingSystem


##------------------------------------------------------------------------------

## When no amount is given when dealt, this is dealt instead.
@export var base_damage_deal_amount: float = 10


## REDUCTION AND INCREASE OF DAMAGE---------------------------------------------

## Increase dealt damage by flat amount
@export var increace_damage_flat: float = 0
## Increase dealt damage by percent
@export var increace_damage_percent: float = 0
## Reduce dealt damage by flat amount
@export var reduce_damage_flat: float = 0
## Reduce dealt damage by percent
@export var reduce_damage_percent: float = 0
##------------------------------------------------------------------------------

## If object should be able to deal damage
@export var enable_damage_dealing: bool = true


## Reduces the resourcepool fittingly and returns the damage value
func deal_damage(dealt_amount: float = base_damage_deal_amount, damage_dealing_system: DamageDealingSystem = self) -> float:
	# Stops the damage if damage dealing is disabled
	if not enable_damage_dealing or damage_receive_system == null:
		return 0
	
	# Apply the flat damage increase/reduction
	var amount: float = dealt_amount + increace_damage_flat - reduce_damage_flat
	# Apply the percent damage increase/reduction
	amount += amount * (increace_damage_percent/100 - reduce_damage_percent/100)
	
	# Deal the amount
	var damage_dealt = damage_receive_system.receive_damage(amount, damage_dealing_system)
	DamageDealt.emit(damage_dealt)
	if damage_dealt == 0:
		DamageDealtMin.emit()
	return damage_dealt


## Sets the damage receiver
func set_damage_receiver(damage_receiver: DamageReceivingSystem):
	damage_receive_system = damage_receiver


## Gets the damage receiver
func get_damage_receiver(damage_receiver: DamageReceivingSystem):
	damage_receive_system = damage_receiver


## Clears the damage receiver
func clear_damage_receiver():
	damage_receive_system = null

