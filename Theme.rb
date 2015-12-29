#!/usr/bin/env ruby
class Theme
	def initialize()
		@themeSelected = 0
		@bombImage = TkPhotoImage.new("file"=>"resources/default/bomb.gif")
		@winImage = TkPhotoImage.new("file"=>"resources/default/winImage.gif")
		@flagImage = TkPhotoImage.new("file"=>"resources/default/whiteFlag.gif")
		@failImage = TkPhotoImage.new("file"=>"resources/default/crossedFlag.gif")
		@themeText = "default"
	end
	#get the game theme
	def getTheme
		@themeText
	end
	def getBombImage
		@bombImage
	end
	def getWinImage
		@winImage
	end
	def getFlagImage
		@flagImage
	end
	def getFailImage
		@failImage
	end
	#change the game theme
	def changeTheme
		directories = []
		directories << Dir.entries('resources').select {|entry| File.directory? File.join('resources',entry) and !(entry =='.' || entry == '..') }
		themesNumber = directories[0].length-1
		if @themeSelected == themesNumber
			@themeSelected = 0
		else
			@themeSelected += 1
		end
		@themeText = directories[0][@themeSelected]
		$b.changeThemeButton(@themeText)
		setThemeImages(@themeText.downcase)
	end
	def setThemeImages(theme)
		@winImage = TkPhotoImage.new("file"=>"resources/"+theme+"/winImage.gif")
		@bombImage = TkPhotoImage.new("file"=>"resources/"+theme+"/bomb.gif")
		@flagImage = TkPhotoImage.new("file"=>"resources/"+theme+"/whiteFlag.gif")
		@failImage = TkPhotoImage.new("file"=>"resources/"+theme+"/crossedFlag.gif")
	end
	#create a new theme
	def createTheme
		$menu = []
		$b.resetVariables(1)
		directory = "Default"
		TkRoot.new.tap { |o|
			$buttons << edit = TkEntry.new( o ).tap { |o|
				o.insert( 0, "Insert theme name" )
				o.grid(:column =>1, :row  =>5, :sticky => 'we')
			}
			$buttons << TkButton.new( o, :text => "Submit" ).tap { |o|
				o.grid(:column =>1, :row  =>6, :sticky => 'we')
				o.bind( '1' ) {
					directory = edit.get().to_s
					create_directory(directory)
				}
			}
		}	
	end
	#modify an existing theme
	def modifyTheme()
		$menu = []
		$b.resetVariables(2)
		$p.setLabelWinAdvice("Edit theme #{getTheme}")
		selectImage(getTheme)
	end
	#create a directory if it doesn't exists
	def create_directory(directory_name)
		if !File.exists?("resources/"+directory_name)
			Dir.mkdir("resources/"+directory_name) 
			$p.setLabelWinAdvice("You must have ImageMagick or GraphicsMagick installed\nFile format must be jpg, gif, bmp, jpeg or png")
			selectImage(directory_name)
		else
			modifyTheme(directory_name)
		end
	end
	def selectImage(dirName)
		resetArray($buttons)
		$buttons = []
		$buttons << TkButton.new do
			width 14
			text "Bomb image"
			grid('row'=>2, 'column'=>1)
			command do
				rute = Tk.getOpenFile
				dest_folder = "resources/"+dirName
				unless rute.nil? || rute==""
					a = rute.split(//).last(4).join("").to_s
					if a == ".gif"||a == ".jpg"||a == ".png"||a == "jpeg"||a == ".bmp"
						system "convert \"#{rute}\" -resize 52x48! #{dest_folder}/bomb.gif"
						$buttons[0].state="disabled"
					end
				end
			end
		end
		$buttons << TkButton.new do
			width 14
			text "Flag image"
			grid('row'=>3, 'column'=>1)
			command do
				rute = Tk.getOpenFile
				dest_folder = "resources/"+dirName
				unless rute.nil? || rute==""
					a = rute.split(//).last(4).join("").to_s
					if a == ".gif"||a == ".jpg"||a == ".png"||a == "jpeg"||a == ".bmp"
						system "convert \"#{rute}\" -resize 52x48! #{dest_folder}/whiteFlag.gif"
						$buttons[1].state="disabled"
					end
				end
			end
		end
		$buttons << TkButton.new do
			width 14
			text "Error flag image"
			grid('row'=>4, 'column'=>1)
			command do
				rute = Tk.getOpenFile
				dest_folder = "resources/"+dirName
				unless rute.nil? || rute==""
					a = rute.split(//).last(4).join("").to_s
					if a == ".gif"||a == ".jpg"||a == ".png"||a == "jpeg"||a == ".bmp"
						system "convert \"#{rute}\" -resize 52x48! #{dest_folder}/crossedFlag.gif"
						$buttons[2].state="disabled"
					end
				end
			end
		end
		$buttons << TkButton.new do
			width 14
			text "Win image"
			grid('row'=>5, 'column'=>1)
			command do
				rute = Tk.getOpenFile
				dest_folder = "resources/"+dirName
				unless rute.nil? || rute==""
					a = rute.split(//).last(4).join("").to_s
					if a == ".gif"||a == ".jpg"||a == ".png"||a == "jpeg"||a == ".bmp"
						system "convert \"#{rute}\" -resize 300x300 #{dest_folder}/winImage.gif"
						$buttons[3].state="disabled"
					end
				end
			end
		end	
	end
end