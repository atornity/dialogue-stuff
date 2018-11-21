extends Control


onready var dialogueTextLabel = $Panel/DialogueText		### this is where the dialogue is displayed :)        it's over there --->

### put your commands in [] and seperate text from value with ":", examples: 
### [pause:10] - stop the dialogue for 10 seconds,
### [speed:0.01] - makes the text go all slow like this ... so slow ...
### make new ones at the botom of the script
var text = "[speed:0.2]the angry man was [pause:0.5][speed:0.1]busy being [pause:1.0][speed:0.05]angry all the [speed:0.03]time.[speed:0.15][pause:0.5] sometimes he was not that angry though[pause:0.5][speed:0.224], which was nice[pause:0.5] for him[pause:0.25] too[pause:0.3] but mostly for the rest of us."
### above me is the example text, probably replace it and write a system for like, actually advancing the story and stuff

### Index of the latest symbol being rendered to the text box :)
var currentLetter = 0
var isRenderingText = true

### this is the previous $Timer.wait_time, we need it for [pause:] to work properly :)
onready var lastWaitTime = $Timer.wait_time

func _on_Timer_timeout(): ### called whenever $Timer.wait_time have elapsed
	$Timer.wait_time = lastWaitTime
	
	if currentLetter < text.length() and isRenderingText:
		if text[currentLetter] == "[":		### if we see this symbol, that means a command is about to happen :)
			currentLetter = FindCommand(text, currentLetter)	### does commandy stuffs and skips to when the command is over for none commandy stuffs to continiue
			
		else:
			dialogueTextLabel.text += text[currentLetter]
		if currentLetter < text.length():
			currentLetter += 1		### adding another character to the text if that's possible
		else:
			isRenderingText = false		### i don't know why this is here but it's probably important
		
		
### seperate the command from the rest of the text and send it to the executioner for execution :)
func FindCommand(textString, textPositionInt):		### textString is the command like this [command:true], textPositionInt is the integer of the first symbol in the command. so like "I went to the store [speed:1000]fastly". textPositionInt would be 21 :)
	var commandString = ""
	var p = 0
	
	for c in textString:	### loops through all the letters in textString
		if p > textPositionInt:
			if c == "]" and p > textPositionInt:	### this means the command is over :)
				ExecuteCommand(commandString)
				return p
				break
			else:
				commandString += c
		p += 1
		
### this is where we execute all our commands and stuff, it's pretty easy to add new ones i think
func ExecuteCommand(commandString):
	
	var command = commandString.substr(0, commandString.find(":"))	### seperate cammand name from everything else so it looks like "coolpants" instead of "[coolpants:false]". makes things easier to work with i think
	print (command)
	var commandValue = commandString.substr(commandString.find(":") + 1, commandString.length() - 1)	### get's the value at the end of the command "[speed:10]" becomes "10" ... hopefully
	print (commandValue)
	
	if command == "speed":		### changes the speed of the text after this command
		$Timer.wait_time = 0.01 / float(commandValue)
		lastWaitTime = $Timer.wait_time
	
	if command == "pause":
		lastWaitTime = $Timer.wait_time		### i had to add this for things to work properly
		$Timer.wait_time = float(commandValue)
