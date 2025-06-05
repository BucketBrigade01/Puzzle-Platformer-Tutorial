extends CharacterBody2D
class_name Player
 
@export_category("Player Movment Variables")
@export var GRAVITY : float = 1100.0
@export var SPEED : float = 100.0
@export var JUMP_SPEED : float = 330.0
@export var BOOST_JUMP_SPEED : float = 350

@onready var animation_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var body_collider : CollisionShape2D = $CollisionShape2D
@onready var bottom_detection_collider : CollisionShape2D = $BottomDetectionBox/CollisionShape2D
@onready var head_target : Marker2D = $Marker2D

enum StackState { NORMAL, STACKED, CARRYING }
var current_state : StackState = StackState.NORMAL
var partner : Player = null

var direction : float
var can_launch : bool = false

func _ready():
	Global.connect("door_opened", fade_player)

func _physics_process(delta : float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	match current_state:
		StackState.NORMAL:
			process_normal_movement(delta)
		StackState.STACKED:
			process_stacked_movement(delta)
		StackState.CARRYING:
			process_carrying_movement(delta)
	
	move_and_slide()
	update_animation()

func process_normal_movement(delta : float) -> void:
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = SPEED * direction
	else:
		velocity.x = 0.0
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_SPEED

func process_stacked_movement(delta : float) -> void:
	velocity = Vector2.ZERO
	if partner:
		global_position = partner.head_target.global_position
		if partner.can_launch:
			launch()
		
func process_carrying_movement(delta : float) -> void:
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = SPEED * direction
	else:
		velocity.x = 0.0
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_SPEED
	elif Input.is_action_just_pressed("jump") and not is_on_floor():
		can_launch = true

func launch() -> void:
	disable_detection_collider(true)
	velocity.y = -JUMP_SPEED
	
	# Bottom Player
	if partner:
		partner.current_state = StackState.NORMAL
		partner.can_launch = false
		partner.partner = null
	
	# Top Player
	current_state = StackState.NORMAL
	partner = null
	disable_body_collider(false)
	
	# Activate detection collider
	await get_tree().create_timer(0.1).timeout
	disable_detection_collider(false)
	
func disable_body_collider(value : bool) -> void:
	body_collider.set_deferred("disabled", value)

func disable_detection_collider(value : bool) -> void:
	bottom_detection_collider.set_deferred("disabled", value)

func update_animation() -> void:
	if not is_on_floor():
		if velocity.y < 0.0:
			animation_sprite.play("jump")
		else:
			animation_sprite.play("fall")
	else:
		if velocity.x != 0.0:
			animation_sprite.play("walk")
		else:
			animation_sprite.play("idle")
	
	if direction != 0:
		animation_sprite.flip_h = direction == -1.0

func fade_player() -> void:
	set_physics_process(false)
	animation_sprite.play("fade")

func _on_animated_sprite_2d_animation_finished():
	if animation_sprite.animation == "fade":
		Global.emit_signal("player_faded")
