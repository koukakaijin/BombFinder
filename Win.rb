#!/usr/bin/env ruby
class Win
	def initialize()
		@winText = "Thanks for playing\nYou Won a relaxing image"
		@timePlayed = -1
	end
	def getTimePlayed
		@timePlayed
	end
	def setTimePlayed(time)
		@timePlayed = time
	end
	def startTime
		if @timePlayed  == -1
			@timePlayed = Time.now
		end
	end
	def menuWin(bombs)
		resetArray($buttons)
		$b.resetAuxArrays
		loadMenuWin(bombs)
	end
	def loadMenuWin(bombs)
		$p.setLabelWinTime("Time used #{@timePlayed} seconds")
		$p.setLabelWinAdvice(@winText)
		$p.setLabelWinImage($t.getWinImage)
		#allow user to insert his name
		TkRoot.new.tap { |o|
			$buttons << edit = TkEntry.new( o ).tap { |o|
				o.insert( 0, "Insert your name here" )
				o.grid(:column =>1, :row  =>5, :sticky => 'we')
			}
			$buttons << TkButton.new( o, :text => "Submit" ).tap { |o|
				o.grid(:column =>1, :row  =>6, :sticky => 'we')
				o.bind( '1' ) {
					updateRecord(edit.get().to_s, bombs)
				}
			}
		}	
	end
	#method that check if users has won
	def checkWin(bombs, remaining, auxAux, buttons)
		if remaining > 0
			for i in 0...auxAux.length
				if auxAux[i]==" "
					return -1
				end
			end
		else 
			for i in 0...buttons.length
				if buttons[i].getValue=="B"
					if buttons[i].getMarked!="M"
						return -1
					end
				end
			end
		end
		endTime = Time.now
		startTime = @timePlayed
		@timePlayed = (endTime-startTime).round
		menuWin(bombs)
	end
	def updateRecord(name,bombs)
		arrayFile=[]
		File.open("config/config#{bombs}.con", "r").each_line do |line|
			arrayFile << line
		end
		arrayFile << "#{getTimePlayed}|#{name}"
		arrayFile.sort_by! {|s| s[/\d+/].to_i}
		while arrayFile.length >10
			arrayFile.pop
		end
		File.open("config/config#{bombs}.con", "w+") do |f|
			arrayFile.each do |x|
				f.puts(x)
			end
		end
		resetArray($buttons)
		recordMenu(bombs)
	end
	def recordMenu(bombs)
		$b.resetVariables
		text = getMode(bombs)
		text += "\n\nTime  Player name\n"
		File.open("config/config#{bombs}.con", "r").each_line do |line|
			line.chomp
			text += line.sub("|", "      ")
		end
		$p.setLabelWinAdvice(text)
	end
	def getMode(bombs)
	case bombs
		when 10
			"Records for Easy Mode 8x8"
		when 15
			"Records for Standard Mode 8x8"
		when 27
			"Records for Standard Mode 12x12"
		else #35
			"Records for Hard Mode 12x12"
		end
	end
end