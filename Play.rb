#!/usr/bin/env ruby
#encoding: UTF-8
class Play
	
	#remainingbombs
	def remainingBombs
		if @bombs != -1
			value = "Bombs left: #{@bombs2}"	
		end
	end	
#---  
	def initialize
		root = TkRoot.new do  
			title "BombFinder by Daniel Hernandez Cassel"
			minsize(240,240)
		end
		@WinAdvice = TkLabel.new do
			font TkFont.new('times 15 bold')
			justify 'left'
			grid('row'=>1, 'column'=>1, 'sticky'=>"W")
		end
		@WinTime = TkLabel.new do
			font TkFont.new('times 15 bold')
			grid('row'=>2, 'column'=>1, 'sticky'=>"W")
		end
		@WinImage = TkLabel.new do
			grid('row'=>3, 'column'=>1, 'sticky'=>"W")
		end
		@RemainigBombs = TkLabel.new do
			grid('row'=>0, 'column'=>3, 'columnspan'=>4, 'sticky'=>"W")
		end
		@RemainigBombs.text = remainingBombs
		
		@font2 = TkFont.new('times 9')
		@font = TkFont.new('times 20 bold')
		@bombs2 = @bombs = -1
		def getBombs
			@bombs
		end
		def setBombs(bombs)
			@bombs = bombs
		end
		def getBombs2
			@bombs2
		end
		def setBombs2(bombs)
			@bombs2 = bombs
		end
		def getFont2
			@font2
		end
		def getFont
			@font
		end
		def setLabelRemainingBombs
			@RemainigBombs.text remainingBombs
		end
		def setLabelWinImage(newImage="")
			@WinImage.image newImage
		end
		def getLabelWinImage
			removeRestart
			@WinImage.image $t.getWinImage
		end
		def removeRestart
			for s in 0...$menu.length do
				if $menu[s].text=="Restart"
					TkGrid.forget([$menu[s]])
				end
			end
		end
		def setLabelWinTime(newText="")
			@WinTime.text newText
		end
		def setLabelWinAdvice(ntext="")
			@WinAdvice.text ntext
		end
	end #initialize  
end # class
