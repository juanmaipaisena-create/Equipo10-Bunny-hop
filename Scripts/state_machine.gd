class_name StateMachine extends Node

##referencia al nodo que vamos a controlar
@onready var controlled_node = self.owner

##estado por defecto
#@export var default_state:StateBase
@export var default_state_path: NodePath

##estado de ejecucion al momento
var current_state:StateBase = null

func _ready():
	call_deferred("_state_default_start")

func _state_default_start():
	#current_state = default_state
	current_state = get_node(default_state_path)
	_state_start()

#funcion que prepara las variables para el nuevo estado y lanza start
func _state_start() -> void:
	current_state.controlled_node = controlled_node
	current_state.state_machine = self
	current_state.start()

#metodo para cambiar el estado
func _change_to(new_state:String) -> void:
	if current_state and current_state.has_method("end"): current_state.end()
	
	var next_state = get_node_or_null(new_state)
	if next_state == null:
		push_error("Estado no encontrado: " + new_state)
		return

	current_state = next_state
	_state_start()

#region metodos que se ejecutan solos
func _process(delta:float) -> void:
	if current_state and current_state.has_method("on_process"):
		current_state.on_process(delta)
	
func _physics_process(delta: float) -> void:
	if current_state and current_state.has_method("on_physics_process"):
		current_state.on_physics_process(delta)
	
func _input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_input"):
		current_state.on_input(event)
	
func _unhandled_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_input"):
		current_state.on_unhandled_input(event)

func _unhandled_key_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_key_input"):
		current_state.on_unhandled_key_input(event)
#endregion
