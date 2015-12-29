#!/usr/bin/env ruby
#encoding: UTF-8
=begin
Game created by Daniel Hernandez Cassel
Version 1.00
=end
require 'tk'
require_relative 'Theme'
require_relative 'Win'
require_relative 'Play'
class BombFinder
	def initialize
		$t = Theme.new
		$w = Win.new
		$p = Play.new
		$fields = $rows = 0
		$menu = []
		$buttons2 = []
		$auxAux = []
		$auxArray = []
		$buttons = []
	end
	def resetAuxArrays
		$p.setBombs(-1)
		$p.setLabelRemainingBombs
		$buttons = []
		$auxArray = []
		$auxAux = []
	end
	def resetVariables(v=0)
		if v == 1 || v == 2
			resetArray($buttons2)
			if v == 2
				resetArray($buttons)
			end
		end
		resetAuxArrays
		$p.setLabelWinTime
		$w.setTimePlayed(-1)
		$p.setLabelWinAdvice
	end
	def changeThemeButton(theme)
		for s in 0...$buttons2.length do
			if $buttons2[s].text.start_with?"Theme: " 
				$buttons2[s].text "Theme: #{theme}"
			end
		end
	end
end

def resetArray(array)
	for i in 0...array.length do
		TkGrid.forget([array[i]])
	end
	array = []
end
def viewRecords
	$p.removeRestart
	texts = ["Records\n8x8\nStandard Mode", "Records\n12x12\nStandard Mode", "Records\n12x12\nHard Mode", "Records\n8x8\nEasy Mode"]
	rows = [1,2,2,1]
	columns = [1,0,1,0]
	bombs = [15,27,35,10]
	for n in 0..3
		$buttons2 << TkButton.new do
		text texts[n]
		width 15
		height 6
		@bombs = bombs[n]
		grid('row'=>rows[n], 'column'=>columns[n])
			command do
				resetArray($buttons2)
				$w.recordMenu(@bombs)
			end
		end
	end
end
def menuCommand
	$p.setLabelWinTime
	selectGame
end
def aboutCommand
	$p.setLabelWinTime("BombFinder Version 1.00\nCreated by Daniel Hernandez Cassel\nCoded 100% in Ruby")
	$p.getLabelWinImage
end
def recordsCommand
	$p.setLabelWinImage
	viewRecords
end
#load Menu
def selectGame
	resetArray($menu)
	$p.setLabelWinAdvice
	$p.setLabelWinImage
	#menu buttons (menu, about, records)
	texts = ["Menu", "About", "Records"]
	columns = [0,5,6]
	commands = [:menuCommand, :aboutCommand, :recordsCommand]
	for n in 0..2
		$menu << TkButton.new do
		text texts[n]
		width 6
		height 1
		font $p.getFont2 
		@commands = commands[n]
		grid('row'=>0, 'column'=>columns[n], 'sticky'=>"W")
			command do
				$b.resetVariables(2)
				send(@commands)
			end
		end
	end
	#button games 
	texts = ["8x8\nStandard Mode", "12x12\nStandard Mode", "12x12\nHard Mode", "8x8\nEasy Mode"]
	rows = [1,2,2,1]
	columns = [1,0,1,0]
	bombs = [15,27,35,10]
	gameRows = [8,12,12,8]
	for n in 0..3
		$buttons2 << TkButton.new do
		text texts[n]
		width 18
		height 9
		@bombs = bombs[n]
		@rows = gameRows[n]
		grid('row'=>rows[n], 'column'=>columns[n])
			command do
				$fields = $rows = @rows
				$p.setBombs(@bombs)
				$p.setBombs2(@bombs)
				resetArray($buttons2)
				letsPlay(@bombs)
			end
		end
	end
	$buttons2 << TkLabel.new do
		text "Theme: #{ $t.getTheme}"
		grid('row'=>3, 'column'=>0, 'sticky'=>"W")
	end
	#Theme buttons
	texts = ["Change Theme", "Create new Theme", "Modify selected Theme"]
	rows = [3,4,4]
	columns = [1,0,1]
	commands = ['changeTheme', 'createTheme', 'modifyTheme']
	for n in 0..2
		$buttons2 << TkButton.new do
			text texts[n]
			@commands = commands[n]
			command {$t.send(@commands)}
			grid('row'=>rows[n], 'column'=>columns[n], 'sticky'=>"W")
		end	
	end
end
#loadGame
def letsPlay(bombs)
	$p.setLabelWinAdvice
	$p.setLabelWinImage
	$p.setLabelRemainingBombs
	#restart button
	$menu << TkButton.new do
		text "Restart"
		width 6
		height 1
		font $p.getFont2 
		@bombs = bombs
		command do
			$p.setBombs(@bombs)
			$p.setBombs2(@bombs)
			$auxArray = []
			$auxAux = []
			if $w.getTimePlayed!=-1
				for n in 0...$buttons.length
					$buttons[n].resetValue
					$buttons[n].state="normal"
					$buttons[n].image=""
					$buttons[n].resetMarked
					$buttons[n].text @value.to_s
					$buttons[n].background "white"
					$buttons[n].foreground "black"
					$buttons[n].width 3
					$buttons[n].height 1
				end
				setFieldBombs
				$w.setTimePlayed(-1)
			else
				resetArray($buttons)
				resetArray($buttons2)
				letsPlay(@bombs)
			end
			$p.setLabelRemainingBombs
			$p.setLabelWinTime
		end
		grid('row'=>0, 'column'=>1, 'sticky'=>"W")
	end
	for i in 0...$rows
		for j in 0...$fields
			x=j+($fields*i)
			y="button"+x.to_s
			$buttons << y = TkButton.new do
				@name = y
				@pos = x
				@value =" "
				@bombs = bombs
				@marked =" "
				state="normal"
				background "white"
				foreground "black"
				text @value.to_s
				font $p.getFont
				width 3
				height 1
				def getName
					return @name
				end
				def getPos
					return @pos
				end
				def getValue
					return @value
				end
				def setValue(newValue)
					@value=newValue
					$auxAux[@pos]=@value
					if newValue==0
						background "grey"
						$buttons[@pos].state="disabled"
					else
						background "white"
						text @value
						foreground "blue"
					end
				end
				def getMarked
					return @marked
				end
				def resetMarked
					@marked=" "
				end
				def resetValue
					@value=" "
				end				
				def setImage(newImage)
					image newImage
					height 0
					width 0
				end
				def makeBomb
					@value="B"
				end
				def isBomb
					if @value=="B"
						return 1
					else
						return 0
					end
				end
				def calculate
					if @marked==" "
						if @value!="B" && @value!=" "
							return -1
						elsif @value=="B"
							turno_bomb
							return -2 
						else
							turno_normal
							return @pos
						end
					else
						return -1
					end
				end
				def turno_bomb
					for i in 0...$buttons.length
						if $buttons[i].getValue=="B"
							if $buttons[i].getMarked!="M"
								$buttons[i].setImage($t.getBombImage)
							end
						end
					end
					for i in 0...$buttons.length
						if $buttons[i].getMarked=="M"
							if $buttons[i].getValue!="B"
								$buttons[i].setImage($t.getFailImage)
							end
						end
					end
					$buttons.each { |x| x.state="disabled"  }
				end
				def turno_normal
					setValue($auxArray[@pos])
					$auxAux[@pos]=$auxArray[@pos]
					if @value == 0
						expand(@pos)
					end
					$w.checkWin(@bombs, $p.getBombs2, $auxAux, $buttons)
				end
				def markBomb
					if (@value ==" " || @value =="B") && @marked==" " && $p.getBombs2>0
						setImage($t.getFlagImage)
						@marked="M"
						$p.setBombs2($p.getBombs2-1)
						$p.setLabelRemainingBombs
						$w.checkWin(@bombs, $p.getBombs2, $auxAux, $buttons)
					elsif @marked =="M"
						image ""
						width 3
						height 1
						text " "
						font $p.getFont
						@marked=" "
						$p.setBombs2($p.getBombs2+1)			
						$p.setLabelRemainingBombs
					end
				end
				#checks if a field need to be expanded
				def checkValid(result,valid)
					if valid=="B" || valid==" "
						result.each do
							|x| if $buttons[x].getValue==" " && $buttons[x].getMarked!="M"
								i = closeBy(x)
								$buttons[x].setValue(i)
								if i == 0 
									expand(x)
								end
							end
						end
					end
				end
				#method to expand in there are no bombs near
				def expand(current)
					results =[]
					if current ==-1
						puts "Error in expand #{current}" #should never happen
					#first row
					elsif 0<=current && current<=$fields-1
						if current!=$fields-1
							results << $buttons[current+1].getPos
							results << $buttons[current+$fields+1].getPos	
						end
						if current!=0
							results << $buttons[current-1].getPos
							results << $buttons[current+$fields-1].getPos	
						end
						results << $buttons[current+$fields].getPos
					#last row
					elsif (($fields*($rows-1)))<=current && current<=(($fields*$rows)-1)
						if current!=(($fields*($rows-1)))
							results << $buttons[current-1].getPos
							results << $buttons[current-$fields-1].getPos
						end
						if current!=(($fields*$rows)-1)
							results << $buttons[current+1].getPos
							results << $buttons[current-$fields+1].getPos	
						end
						results << $buttons[current-$fields].getPos
					else
						if current % $rows!=0 # not the last file
							results << $buttons[current-1].getPos
							results << $buttons[current-$fields-1].getPos
							results << $buttons[current+$fields-1].getPos
						end
						if current % $rows!=($fields-1) # not the first file
							results << $buttons[current+1].getPos
							results << $buttons[current-$fields+1].getPos
							results << $buttons[current+$fields+1].getPos
						end
						results << $buttons[current-$fields].getPos
						results << $buttons[current+$fields].getPos
					end
					results.sort!
					results.compact! #delete any nil.
					#check if it is necessary to expand more fields
					for l in 0...(results.length)
						if current == ($rows*$fields)-1
							valid = $buttons[current-1].getValue
							checkValid(results,valid)
						else
							valid = $buttons[current+1].getValue
							checkValid(results,valid)
							if current != 0
								valid = $buttons[current-1].getValue
								checkValid(results,valid)
							end
						end
						if current+$fields < ($rows*$fields)
							valid = $buttons[current+$fields].getValue
							checkValid(results,valid)
						end
						if current-$fields >= 0
							valid = $buttons[current-$fields].getValue
							checkValid(results,valid)
						end
						results.delete_at(l)
					end
					results.each do
						|x| valid2 = $buttons[x].getValue
						if valid2 == 0
							c = closeBy(x)
							$buttons[x].setValue(c)
						end
					end
				end
				command do
				calculate
				$w.startTime
				end
				grid('row'=>i+1, 'column'=>j)
				#bind right click to markBomb
				bind('ButtonPress-3', proc do 
					if self.state!="disabled" 
						self.markBomb; $w.startTime 
					end 
				end)
			end
		end
	end
	#Menu data display and management
	#Set bombs in the field
	def setBomb(num)
		test = $buttons[num].getValue
		if test!="B"
			$buttons[num].makeBomb
			$p.setBombs($p.getBombs-1)
		end
	end
	#method to set bombs in the field
	def setFieldBombs
		max = ($rows*$fields)
		while $p.getBombs > 0
			num = rand(max)
			setBomb(num)
		end
		#populate $auxArray with the values of the field
		for n in 0...$buttons.length
			if $buttons[n].getValue=="B"
				$auxArray << $buttons[n].getValue
				$auxAux << "B"
			else
				aux = $buttons[n].getPos
				$auxArray << closeBy(aux)
				$auxAux << " "
			end
		end
	end
	#method that returns the number of bombs near
	def closeBy(current)
		results =0
		#If field in use or error
		if current ==-1 || current == -2
			puts "Error in closeBy #{current}" #should never happen
		elsif 0<=current && current<=$fields-1
			if current!=$fields-1
				results += $buttons[current+1].isBomb
				results += $buttons[current+$fields+1].isBomb	
			end
			if current!=0
				results += $buttons[current-1].isBomb
				results += $buttons[current+$fields-1].isBomb	
			end
			results += $buttons[current+$fields].isBomb
		#last row
		elsif (($fields*($rows-1)))<=current && current<=(($fields*$rows)-1)
			if current!=(($fields*($rows-1)))
				results += $buttons[current-1].isBomb
				results += $buttons[current-$fields-1].isBomb
			end
			if current!=(($fields*$rows)-1)
				results += $buttons[current+1].isBomb
				results += $buttons[current-$fields+1].isBomb	
			end
			results += $buttons[current-$fields].isBomb
		else
			if current % $rows!=0 # not the first file
				results += $buttons[current-1].isBomb
				results += $buttons[current-$fields-1].isBomb
				results += $buttons[current+$fields-1].isBomb
			end
			if current % $rows!=($fields-1) # not the last file
				results += $buttons[current+1].isBomb
				results += $buttons[current-$fields+1].isBomb
				results += $buttons[current+$fields+1].isBomb
			end
			results += $buttons[current-$fields].isBomb
			results += $buttons[current+$fields].isBomb
		end
		return results
	end
	setFieldBombs
end

$b = BombFinder.new
selectGame
Tk.mainloop
