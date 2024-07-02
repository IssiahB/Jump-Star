extends Resource
class_name World

enum LockState {
	LOCKED,
	UNLOCKED
}

@export var name: StringName
@export var status: LockState
@export var world_scene: PackedScene
