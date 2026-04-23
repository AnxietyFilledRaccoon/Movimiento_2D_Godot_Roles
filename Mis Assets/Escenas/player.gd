extends CharacterBody2D

var air_punch = false
var stop_speed = 20

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Añadir gravedad.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y < 0:
			if air_punch == true:
				$AnimatedSprite2D.play("attack")
			else:
				$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("jump_fall")
	else:
		air_punch = false

	# Ejecutar un salto.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor(): 
		velocity.y = JUMP_VELOCITY

	if (Input.is_action_just_pressed("attack") and not is_on_floor() and air_punch == false):
		# print("japish")
		air_punch = true
		velocity.y = JUMP_VELOCITY

	# Desde esta linea manejamos las interacciones del personaje
	# frente a los botones que presionamos en el teclado.
	
	# En este caso flechas direccionales para movernos, SHIFT para un dash y C para un ataque/segundo salto.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		$AnimatedSprite2D.scale.x = 1
	elif direction < 0:
		$AnimatedSprite2D.scale.x = -1
	
	if direction:
		if Input.is_action_pressed("dash"):
			velocity.x = direction * SPEED * 1.5
			if is_on_floor():
				$AnimatedSprite2D.play("dash")
		
		# El personaje deberia perder velocidad hasta llegar a cero por no puedo solucionarlo todavia
		# y solo dura un frame, no el tiempo suficiente.
		elif Input.is_action_just_released("dash"):
			stop_speed = 300
			while stop_speed > 0:
				velocity.x = direction * stop_speed
				stop_speed =- 2
				if is_on_floor():
					$AnimatedSprite2D.play("stop_dash")
			velocity.x = 0
		else:
			velocity.x = direction * SPEED
			if is_on_floor():
				$AnimatedSprite2D.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			$AnimatedSprite2D.play("idle")



	move_and_slide()
