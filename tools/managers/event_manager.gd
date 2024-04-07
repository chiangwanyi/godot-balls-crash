extends Node

static var subscribers : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

static func add_listener(topic: String, listener: Node):
	if not subscribers.has(topic):
		subscribers[topic] = []
	
	if not subscription_exists(topic, listener):
		(subscribers[topic] as Array[Node]).append(listener) 

static func subscription_exists(topic: String, receiver: Node):
	var receivers : Array[Node] = subscribers[topic]
	if receivers == null or receivers.size() == 0:
		return false
		
	var exists = false
	
	for listener in receivers:
		if listener != receiver:
			continue
		exists = true
		break
	
	return exists

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

class EventListener:
	func on_event() -> void :
		pass
