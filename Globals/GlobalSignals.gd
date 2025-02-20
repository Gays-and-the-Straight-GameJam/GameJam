extends Node

signal interact(state, objectID)

signal playerIDSignal(playerID)

signal objectIDSignal(objectID)

signal inMiniGame(state)

signal clicked(state)

signal wireGameCompleted(state)

signal batteryGameCompleted(state)

signal MainMenu(state)

<<<<<<< Updated upstream
signal batteryPickedUp(state)

signal batteryCount(num)
=======
signal LevelComplete()

signal DragNDropCompleted(state)

signal droppped(object: Node2D, hole: Area2D)
>>>>>>> Stashed changes
