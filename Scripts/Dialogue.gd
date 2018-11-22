extends Control


onready var dialogueTextLabel = $Panel/DialogueText		### this is where the dialogue is displayed :)     it's over there --->

### put your commands in [] and seperate text from value with ":", examples: 
### [pause:10] - stop the dialogue for 10 seconds,
### [speed:0.01] - makes the text go all slow like this ... so ... slow ...
### make new ones at the botom of the script, if you want to :)
var text = "[speed:0.2]the angry man was [pause:0.5][speed:0.1]busy being [pause:1.0][speed:0.05]angry all the [speed:0.03]time.[speed:0.15][pause:0.5] sometimes he was not that angry though[pause:0.5][speed:0.224], which was nice[pause:0.5] for him[pause:0.25] too[pause:0.3] but mostly for the rest of us.[pause:3] yay.[pause:0.4] actually,[pause:0.3] there is a secret code at the end[pause:0.3], it's[speed:0.045] 008492[speed:0.224][pause:0.2], you can use it for[pause:0.25] secret doors[pause:0.2] and[pause:0.5] other[0.45] secret[pause:0.4] things.[pause:3][speed:0.234] you know.[pause:0.7] safes[pause:0.185] and stuff."
### you actually HAVE to write it like
### THIS: "hello[pause:1] there!". 
### NOT: "hello [pause:1]there".    it seems like a small change but it's a big deal!
var book = ["[speed:0.2]hello[pause:0.5] there.", "welcome to the place[pause:1.05] of dreams.", "take a seat.", "now[pause:0.5], what brings you here?"]
var page = 0

### Index of the latest symbol being rendered to the text box :)
var currentLetter = 0
var isRenderingText = true		### this one is true if isRenderingText == true

### this is the previous $Timer.wait_time, we need it for [pause:] to work properly :)				[pause:] pauses things if you havent seen that, up there, it's up there. on the top of the thing
onready var lastWaitTime = $Timer.wait_time


func _process(delta):
	
	if Input.is_action_just_pressed("ui_click") and currentLetter >= text.length() and page < book.size() - 1:
		dialogueTextLabel.text = ""
		page += 1
		print("next page")
		currentLetter = 0
	text = book[page]


func _on_Timer_timeout(): ### called whenever $Timer.wait_time have elapsed
	$Timer.wait_time = lastWaitTime
	
	if currentLetter < text.length() and isRenderingText:
		if text[currentLetter] == "[":		### if we see this symbol, that means a command is about to happen :)
			currentLetter = FindCommand(text, currentLetter)	### does commandy stuffs and skips to when the command is over for none commandy stuffs to continiue
			
		else:
			dialogueTextLabel.text += text[currentLetter]
		if currentLetter < text.length():
			currentLetter += 1		### adding another character to the text if that's possible
		#else:
			#isRenderingText = false		### i don't know why this is here but it's probably important
		
		
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
	
	if command == "pause" or "delay":
		lastWaitTime = $Timer.wait_time		### i had to add this for things to work properly
		$Timer.wait_time = float(commandValue)
