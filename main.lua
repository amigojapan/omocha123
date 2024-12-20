physics = require("physics")
local json = require( "json" )  -- Include the Corona JSON library
local widget = require( "widget" )
local lfs = require("lfs")
local network = require("network")
local UserInput = require("UserInput")
--immiediate code
local directory = system.pathForFile("", system.DocumentsDirectory)
-- Change the working directory to the Documents directory
local success, errorString = lfs.chdir(directory)
if not success then
    local function onComplete(event)
        -- Handle alert button presses here if needed
    end

    native.showAlert(
        "Directory Access Error", -- Title
        "Error accessing directory: " .. errorString, -- Message
        { "OK" }, -- Button labels
        onComplete -- Listener function (optional)
    )
    return files
end

-- original Sample code by Eetu Rantanen.
system.activate( "multitouch" )
-- Change the background to blue.
display.setDefault( "background", 0, 0.3, 0.8 )
--constants
gridSize=64
gridWidth=15
gridHeight=11
--helperfunctions
function table.clear(t)
	for k in pairs (t) do
		t [k] = nil
	end
end
function saveFile(fileName)
	print("saveFile called, filename"..fileName)
	if not sevrer then
		server="https://amjp.psy-k.org/omocha123"	
	end
	content=total
	-- URL of the PHP script
	local url = server .."/uploadOmocha123file.php" -- Replace with your actual server URL

	-- String to post
	local filename = fileName -- Replace with the filename string
	local fileContent = content -- Replace with the content string

	--native.showAlert("alertbox", "filename" .. filename .. "filecontent"..fileContent, {"OK"})
	-- Function to handle network response
	local function networkListener(event)
		--native.showAlert("alertbox", "here1" .. filename .. "filecontent"..fileContent, {"OK"})
		if (event.isError) then
			print("Network error: ", event.response)
			native.showAlert("Error", "Network error occurred.", {"OK"})
		else
			print("Response: ", event.response)
			--** show reponse to see if it works on android
			native.showAlert("Response", event.response, {"OK"})
			if event.response ~= "File accepted" then
				native.showAlert("Response", event.response, {"OK"})
			end
		end
	end

	-- Prepare the POST data
	local params = {
		body = "filename=" .. fileName .. "&omocha123=" .. fileContent,
		headers = {
			["Content-Type"] = "application/x-www-form-urlencoded",
		}
	}

	-- Send POST request
	--native.showAlert("alertbox", "here2url:" .. url.."fileName:"..fileName.. "&omocha123=" .. fileContent, {"OK"})
	--it is crashing next statement filename is empty!

	network.request(url, "POST", networkListener, params)

	--native.showAlert("alertbox", "here3" .. filename .. "filecontent"..fileContent, {"OK"})

end

function splitString(inputstr, sep)
	if sep == nil then
	  sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	  table.insert(t, str)
	end
	return t
  end
  
function deepCopy(obj)
    if type(obj) ~= 'table' then return obj end
    local res = setmetatable({}, getmetatable(obj))
    for k, v in pairs(obj) do res[deepCopy(k)] = deepCopy(v) end
    return res
end

function dumpTable(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dumpTable(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
 end

-- Function to get all files with a specific extension
local function getFilesWithExtension(directory, extension,server)
	if not sevrer then
		server="https://amjp.psy-k.org/omocha123/"	
	end
	local files = {}
	--[[
	local success, errorString = lfs.chdir(directory)
    if not success then
		local function onComplete(event)
			-- Handle alert button presses here if needed
		end
	
		native.showAlert(
			"Directory Access Error", -- Title
			"Error accessing directory: " .. errorString, -- Message
			{ "OK" }, -- Button labels
			onComplete -- Listener function (optional)
		)
		return files
	end
	]]
	-- URL of the PHP script
	local url = server .. "/listFilesOmocha123.php" -- Replace with your actual server URL

	-- String to post
	--local filename = "testfile.txt" -- Replace with the filename string
	--local fileContent = "This is the content of the file." -- Replace with the content string

	-- Function to handle network response
	local function networkListener(event)
		if (event.isError) then
			print("Network error: ", event.response)
			native.showAlert("Error", "Network error occurred.", {"OK"}, function() end)
		else
			print("Response: ", event.response)
			--native.showAlert("Response", event.response, {"OK"}, function() end)
			-- Iterate over each file in the directory
			local filesArray=splitString(event.response, ",")
			
			return filesArray
			--[[
			for file in filesArray do
				-- Check if it's not a hidden file and ends with the desired extension
				if file ~= "." and file ~= ".." and file:match("%." .. extension .. "$") then
					table.insert(files, file)
				end
			end

			return files
			]]
		end
	end

	-- Prepare the POST data
	local params = {
		body = "",--no data needs to be send
		headers = {
			["Content-Type"] = "application/x-www-form-urlencoded",
		}
	}

	-- Send POST request
	network.request(url, "POST", networkListener, params)

	-- Example of showing an alert box with a variable's content
	local function showAlert()
		local alertMessage = "The filename is: " .. filename
		native.showAlert("Alert", alertMessage, {"OK"}, function() end)
	end

	-- Show the alert box
	--showAlert()

end
 
-- Require and start the physics engine.

physics.start()

--ugly hacks to get the physics working simillar on different pllatforms
if system.getInfo("environment") == "browser" then
	physics.setScale( 32.5 )	
end
if system.getInfo("platform") == "android"  then
	physics.setScale( 40 )	
end

--physics.setGravity( 0, 98.1 ) -- Setting a very high gravity.
physics.setGravity( 0, 0 ) -- start simulation with no gravity

y=gridSize
for x = 1, gridWidth do
	local ground = display.newImage( "img/brick.png", x*gridSize, y )
	physics.addBody( ground, "static", { density=1, friction=0.9, bounce=0 } )
end

y=gridSize*gridHeight
for x = 1, gridWidth do
	local ground = display.newImage( "img/brick.png", x*gridSize, y )
	physics.addBody( ground, "static", { density=1, friction=0.9, bounce=0 } )
end
x=gridSize
for y = 2, gridHeight do
	local ground = display.newImage( "img/brick.png", x, y*gridSize )
	physics.addBody( ground, "static", { density=1, friction=0.9, bounce=0 } )
end
x=gridSize*gridWidth
for y = 1, gridHeight do
	local ground = display.newImage( "img/brick.png", x, y*gridSize )
	physics.addBody( ground, "static", { density=1, friction=0.9, bounce=0 } )
end
--toolbar
toolBarOffsetX=2
addBlockTool = display.newImage( "img/block-white.png", gridSize*toolBarOffsetX, gridSize*1 )
physics.addBody( addBlockTool, "static", { density=0, friction=0, bounce=0 } )
addBlockTool.angularDamping = 3
addBlockTool.myName="addBlockTool"

toolBarOffsetX=toolBarOffsetX+1
runTool = display.newImage( "img/run.png", gridSize*toolBarOffsetX, gridSize*1 )
physics.addBody( runTool, "static", { density=0, friction=0, bounce=0 } )
runTool.angularDamping = 3
runTool.myName="runTool"

toolBarOffsetX=toolBarOffsetX+1
stopTool = display.newImage( "img/stop.png", gridSize*toolBarOffsetX, gridSize*1 )
physics.addBody( stopTool, "static", { density=0, friction=0, bounce=0 } )
stopTool.angularDamping = 3
stopTool.myName="stopTool"

toolBarOffsetX=toolBarOffsetX+1
pinOnTool = display.newImage( "img/pin-on.png", gridSize*toolBarOffsetX, gridSize*1 )
physics.addBody( pinOnTool, "static", { density=0, friction=0, bounce=0 } )
pinOnTool.angularDamping = 3
pinOnTool.myName="pinOnTool"

toolBarOffsetX=toolBarOffsetX+1
pinOffTool = display.newImage( "img/pin-off.png", gridSize*toolBarOffsetX, gridSize*1 )
physics.addBody( pinOffTool, "static", { density=0, friction=0, bounce=0 } )
pinOffTool.angularDamping = 3
pinOffTool.myName="pinOffTool"

toolBarOffsetX=toolBarOffsetX+1
gravityOnTool = display.newImage( "img/gravity-on.png", gridSize*toolBarOffsetX, gridSize*1 )
physics.addBody( gravityOnTool, "static", { density=0, friction=0, bounce=0 } )
gravityOnTool.angularDamping = 3
gravityOnTool.myName="gravityOnTool"

toolBarOffsetX=toolBarOffsetX+1
gravityOffTool = display.newImage( "img/gravity-off.png", gridSize*toolBarOffsetX, gridSize*1 )
physics.addBody( gravityOffTool, "static", { density=0, friction=0, bounce=0 } )
gravityOffTool.angularDamping = 3
gravityOffTool.myName="gravityOffTool"

toolBarOffsetX=toolBarOffsetX+1
deleteTool = display.newImage( "img/trash_can.png", gridSize*toolBarOffsetX, gridSize*1 )
physics.addBody( deleteTool, "static", { density=0, friction=0, bounce=0 } )
deleteTool.angularDamping = 3
deleteTool.myName="deleteTool"

toolBarOffsetX=toolBarOffsetX+1
saveTool = display.newImage( "img/save.png", gridSize*toolBarOffsetX, gridSize*1 )
physics.addBody( saveTool, "static", { density=0, friction=0, bounce=0 } )
saveTool.angularDamping = 3
saveTool.myName="saveTool"

toolBarOffsetX=toolBarOffsetX+1
loadTool = display.newImage( "img/load.png", gridSize*toolBarOffsetX, gridSize*1 )
physics.addBody( loadTool, "static", { density=0, friction=0, bounce=0 } )
loadTool.angularDamping = 3
loadTool.myName="loadTool"


arc = display.newImage( "img/arc.png", gridSize*2, gridSize*2 )
physics.addBody( arc, "static", { density=1, friction=2, bounce=0 } )
arc.angularDamping = 3
arc.myName="arcTool"

selectedItem=nil
editingItem=nil
itemTable={}
savedTable=nil
stageProperties={}
stageProperties.gravity="on"
addBlockYellow=nil
addBlockRed=nil
addBlockBlue=nil
addBlockBrick=nil
addBlockGoal=nil
addBlockGreen=nil
addBlockGreen=nil
addCircleYellow=nil
addCircleRed=nil
addCircleGreen=nil
addCircleBlue=nil
addBalloon=nil
addSpike=nil
submenuShowing=false

local function dragObject( event, params )
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()

	if "began" == phase then
		--stage:setFocus( body )
		if event.target.myName=="addBlockTool" and submenuShowing then
			print("addBlockTool is ture and submenuShowing==false")
			clearSubmenu()
			return true
		end
		if event.target.myName=="saveTool" then
			print("save stage clicked")
			saveStage()
			return true
		end
		if event.target.myName=="loadTool" then
			print("load stage clicked")
			displayFileList("Load from file:","txt")
			return true
		end
		display.getCurrentStage():setFocus( event.target, event.id )
		if event.target.myName=="block" or event.target.myName=="circle" or event.target.myName=="balloon" or event.target.myName=="spike" or event.target.myName=="brick" then--move above selected item
			editingItem=event.target
		end
		selectedItem=event.target
		if selectedItem.myName~="arc" then
			arc.x=gridSize*2
			arc.y=gridSize*2
			if editingItem then
				--editingItem.rotation=0 this was causing the bug of not saving hte rotation
			end
		end
		body.isFocus = true
		print(selectedItem.myName)
		if physicsRun then
			body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )
			if selectedItem.myName=="stopTool" then
				print("stop tool clicked!")
				physics.setGravity( 0, 0 )
				physicsRun=false
				clearAllObjects()
				reproduceInitioalState()
				return true
			end
		else--edit  mode
			if not physicsRun and selectedItem.myName=="runTool" then
				print("run tool clicked!")
				saveCurrentState()
				clearAllObjects()
				reproduceInitioalState()
				physics.start()
				if stageProperties.gravity== "off" then
					physics.setGravity( 0, 0 )
				else--gravity on
					physics.setGravity( 0, 98.1 )	
				end
				physicsRun=true
				return true
			end
			if selectedItem.myName=="addBlockTool" then
				print("add item tool clicked!")
				submenuShowing=true
				toolBarOffsetY=2
				toolBarOffsetX=2
				addBlockYellow = display.newImage( "img/block.png", toolBarOffsetX*gridSize, toolBarOffsetY*gridSize )
				physics.addBody( addBlockYellow, "static", { density=0, friction=0, bounce=0 } )
				addBlockYellow.angularDamping = 3
				addBlockYellow.myName="addBlockYellow"
				addBlockYellow:addEventListener( "touch", dragObject )
				
				toolBarOffsetY=toolBarOffsetY+1
				addBlockRed = display.newImage( "img/block-red.png", toolBarOffsetX*gridSize, toolBarOffsetY*gridSize )
				physics.addBody( addBlockRed, "static", { density=0, friction=0, bounce=0 } )
				addBlockRed.angularDamping = 3
				addBlockRed.myName="addBlockRed"
				addBlockRed:addEventListener( "touch", dragObject )

				toolBarOffsetY=toolBarOffsetY+1
				addBlockGreen = display.newImage( "img/block-green.png", toolBarOffsetX*gridSize, toolBarOffsetY*gridSize )
				physics.addBody( addBlockGreen, "static", { density=0, friction=0, bounce=0 } )
				addBlockGreen.angularDamping = 3
				addBlockGreen.myName="addBlockGreen"
				addBlockGreen:addEventListener( "touch", dragObject )

				toolBarOffsetY=toolBarOffsetY+1
				addBlockBlue = display.newImage( "img/block-blue.png", toolBarOffsetX*gridSize, toolBarOffsetY*gridSize )
				physics.addBody( addBlockBlue, "static", { density=0, friction=0, bounce=0 } )
				addBlockBlue.angularDamping = 3
				addBlockBlue.myName="addBlockBlue"
				addBlockBlue:addEventListener( "touch", dragObject )



				toolBarOffsetY=toolBarOffsetY+1
				addCircleYellow = display.newCircle( toolBarOffsetX*gridSize, toolBarOffsetY*gridSize, 10 )
				addCircleYellow.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/ball-yellow.png"
				}
				-- Fill the circle
				addCircleYellow.fill = paint
				physics.addBody( addCircleYellow, "static", { density=0, friction=0, bounce=0 } )
				addCircleYellow.angularDamping = 3
				addCircleYellow.myName="addCircleYellow"
				addCircleYellow:addEventListener( "touch", dragObject )


				toolBarOffsetY=toolBarOffsetY+1
				addCircleRed = display.newCircle( toolBarOffsetX*gridSize, toolBarOffsetY*gridSize, 10 )
				addCircleRed.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/ball-red.png"
				}
				-- Fill the circle
				addCircleRed.fill = paint
				physics.addBody( addCircleRed, "static", { density=0, friction=0, bounce=0 } )
				addCircleRed.angularDamping = 3
				addCircleRed.myName="addCircleRed"
				addCircleRed:addEventListener( "touch", dragObject )


				toolBarOffsetY=toolBarOffsetY+1
				addCircleGreen = display.newCircle( toolBarOffsetX*gridSize, toolBarOffsetY*gridSize, 10 )
				addCircleGreen.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/ball-green.png"
				}
				-- Fill the circle
				addCircleGreen.fill = paint
				physics.addBody( addCircleGreen, "static", { density=0, friction=0, bounce=0 } )
				addCircleGreen.angularDamping = 3
				addCircleGreen.myName="addCircleGreen"
				addCircleGreen:addEventListener( "touch", dragObject )
				
				toolBarOffsetY=toolBarOffsetY+1
				addCircleBlue = display.newCircle( toolBarOffsetX*gridSize, toolBarOffsetY*gridSize, 10 )
				addCircleBlue.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/ball-blue.png"
				}
				-- Fill the circle
				addCircleBlue.fill = paint
				physics.addBody( addCircleBlue, "static", { density=0, friction=0, bounce=0 } )
				addCircleBlue.angularDamping = 3
				addCircleBlue.myName="addCircleBlue"
				addCircleBlue:addEventListener( "touch", dragObject )

				toolBarOffsetX=3
				toolBarOffsetY=2
				addBalloon = display.newCircle( toolBarOffsetX*gridSize, toolBarOffsetY*gridSize, 10 )
				addBalloon.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/balloon.png"
				}
				-- Fill the circle
				addBalloon.fill = paint
				physics.addBody( addBalloon, "static", { density=0, friction=0, bounce=0 } )
				addBalloon.angularDamping = 3
				addBalloon.myName="addBalloon"
				addBalloon.color="purple"
				addBalloon:addEventListener( "touch", dragObject )


				toolBarOffsetY=toolBarOffsetY+1
				addSpike = display.newCircle( toolBarOffsetX*gridSize, toolBarOffsetY*gridSize, 10 )
				addSpike.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/spike.png"
				}
				-- Fill the circle
				addSpike.fill = paint
				physics.addBody( addSpike, "static", { density=0, friction=0, bounce=0 } )
				addSpike.angularDamping = 3
				addSpike.myName="addSpike"
				addSpike.color="purple"
				addSpike:addEventListener( "touch", dragObject )

				toolBarOffsetY=toolBarOffsetY+1
				addBlockBrick = display.newImage( "img/brick.png", toolBarOffsetX*gridSize, toolBarOffsetY*gridSize )
				physics.addBody( addBlockBrick, "static", { density=0, friction=0, bounce=0 } )
				addBlockBrick.angularDamping = 3
				addBlockBrick.myName="addBlockBrick"
				addBlockBrick:addEventListener( "touch", dragObject )

				toolBarOffsetY=toolBarOffsetY+1
				addBlockGoal = display.newImage( "img/goal.png", toolBarOffsetX*gridSize, toolBarOffsetY*gridSize )
				physics.addBody( addBlockGoal, "static", { density=0, friction=0, bounce=0 } )
				addBlockGoal.angularDamping = 3
				addBlockGoal.myName="addBlockGoal"
				addBlockGoal:addEventListener( "touch", dragObject )

				return true
			end

			if selectedItem.myName=="addBlockYellow" then
				print("add block yellow tool clicked!")
				local block = display.newImage( "img/block.png", selectedItem.x, selectedItem.y )
				physics.addBody( block, "dynamic", { density=1, friction=2, bounce=0 } )
				block.angularDamping = 3
				block.myName="block"
				block.color="yellow"
				block:addEventListener( "touch", dragObject )
				table.insert(itemTable,block)
				clearSubmenu()
				return true
			end
			if selectedItem.myName=="addBlockRed" then
				print("add block yellow tool clicked!")
				local block = display.newImage( "img/block-red.png", selectedItem.x, selectedItem.y )
				physics.addBody( block, "dynamic", { density=1, friction=2, bounce=0 } )
				block.angularDamping = 3
				block.myName="block"
				block.color="red"
				block:addEventListener( "touch", dragObject )
				table.insert(itemTable,block)
				clearSubmenu()
				return true
			end
			if selectedItem.myName=="addBlockGreen" then
				print("add block yellow tool clicked!")
				local block = display.newImage( "img/block-green.png", selectedItem.x, selectedItem.y )
				physics.addBody( block, "dynamic", { density=1, friction=2, bounce=0 } )
				block.angularDamping = 3
				block.myName="block"
				block.color="green"
				block:addEventListener( "touch", dragObject )
				table.insert(itemTable,block)
				clearSubmenu()
				return true
			end
			if selectedItem.myName=="addBlockBlue" then
				print("add block yellow tool clicked!")
				local block = display.newImage( "img/block-blue.png", selectedItem.x, selectedItem.y )
				physics.addBody( block, "dynamic", { density=1, friction=2, bounce=0 } )
				block.angularDamping = 3
				block.myName="block"
				block.color="blue"
				block:addEventListener( "touch", dragObject )
				table.insert(itemTable,block)
				clearSubmenu()
				return true
			end

			if selectedItem.myName=="addBlockBrick" then
				print("add block brick tool clicked!")
				local block = display.newImage( "img/brick.png", selectedItem.x, selectedItem.y )
				physics.addBody( block, "dynamic", { density=1, friction=2, bounce=0 } )
				block.angularDamping = 3
				block.myName="block"
				block.color="brick"
				block:addEventListener( "touch", dragObject )
				table.insert(itemTable,block)
				clearSubmenu()
				return true
			end

			if selectedItem.myName=="addBlockGoal" then
				print("add block yellow tool clicked!")
				local block = display.newImage( "img/goal.png", selectedItem.x, selectedItem.y )
				physics.addBody( block, "dynamic", { density=1, friction=2, bounce=0 } )
				block.angularDamping = 3
				block.myName="block"
				block.color="goal"
				block:addEventListener( "touch", dragObject )
				table.insert(itemTable,block)
				clearSubmenu()
				return true
			end

			if selectedItem.myName=="addCircleBlue" then
				print("add circle blue tool clicked!")
				local circleBlue = display.newCircle( selectedItem.x, selectedItem.y, 64 )
				circleBlue.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/ball-blue.png"
				}
				-- Fill the circle
				circleBlue.fill = paint

				--local block = display.newImage( "img/block-blue.png", 480, 100 )
				physics.addBody( circleBlue, "dynamic", { radius=64/2, density=1, friction=2, bounce=0 } )
				circleBlue.angularDamping = 3
				circleBlue.myName="circle"
				circleBlue.color="blue"
				circleBlue:addEventListener( "touch", dragObject )
				table.insert(itemTable,circleBlue)
				clearSubmenu()
				return true
			end
			
			if selectedItem.myName=="addSpike" then
				print("add baloon tool clicked!")
				local circleSpike = display.newCircle( selectedItem.x, selectedItem.y, 64 )
				circleSpike.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/spike.png"
				}
				-- Fill the circle
				circleSpike.fill = paint

				--local block = display.newImage( "img/block-blue.png", 480, 100 )
				physics.addBody( circleSpike, "dynamic", { radius=64/2, density=1, friction=2, bounce=0 } )
				circleSpike.angularDamping = 3
				circleSpike.myName="spike"
				circleSpike.color="grey"
				circleSpike:addEventListener( "touch", dragObject )
				table.insert(itemTable,circleSpike)
				clearSubmenu()
				return true
			end
			

			if selectedItem.myName=="addBalloon" then
				print("add baloon tool clicked!")
				local circleBaloon = display.newCircle( selectedItem.x, selectedItem.y, 64 )
				circleBaloon.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/balloon.png"
				}
				-- Fill the circle
				circleBaloon.fill = paint

				--local block = display.newImage( "img/block-blue.png", 480, 100 )
				physics.addBody( circleBaloon, "dynamic", { radius=64/2, density=1, friction=2, bounce=0 } )
				circleBaloon.angularDamping = 3
				circleBaloon.myName="balloon"
				circleBaloon.color="purple"
				circleBaloon:addEventListener( "touch", dragObject )
				table.insert(itemTable,circleBaloon)
				clearSubmenu()
				return true
			end


			if selectedItem.myName=="addCircleGreen" then
				print("add circle green tool clicked!")
				local circleGreen = display.newCircle( selectedItem.x, selectedItem.y, 64 )
				circleGreen.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/ball-green.png"
				}
				-- Fill the circle
				circleGreen.fill = paint

				--local block = display.newImage( "img/block-blue.png", 480, 100 )
				physics.addBody( circleGreen, "dynamic", { radius=64/2, density=1, friction=2, bounce=0 } )
				circleGreen.angularDamping = 3
				circleGreen.myName="circle"
				circleGreen.color="green"
				circleGreen:addEventListener( "touch", dragObject )
				table.insert(itemTable,circleGreen)
				clearSubmenu()
				return true
			end

			if selectedItem.myName=="addCircleRed" then
				print("add circle red tool clicked!")
				local addRed = display.newCircle( selectedItem.x, selectedItem.y, 64 )
				addRed.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/ball-red.png"
				}
				-- Fill the circle
				addRed.fill = paint

				--local block = display.newImage( "img/block-blue.png", 480, 100 )
				physics.addBody( addRed, "dynamic", { radius=64/2, density=1, friction=2, bounce=0 } )
				addRed.angularDamping = 3
				addRed.myName="circle"
				addRed.color="red"
				addRed:addEventListener( "touch", dragObject )
				table.insert(itemTable,addRed)
				clearSubmenu()
				return true
			end

			if selectedItem.myName=="addCircleYellow" then
				print("add circle yellow tool clicked!")
				local circleYellow = display.newCircle( selectedItem.x, selectedItem.y, 64 )
				circleYellow.path.radius = 64
				local paint = {
					type = "image",
					filename = "img/ball-yellow.png"
				}
				-- Fill the circle
				circleYellow.fill = paint

				--local block = display.newImage( "img/block-blue.png", 480, 100 )
				physics.addBody( circleYellow, "dynamic", { radius=64/2, density=1, friction=2, bounce=0 } )
				circleYellow.angularDamping = 3
				circleYellow.myName="circle"
				circleYellow.color="yellow"
				circleYellow:addEventListener( "touch", dragObject )
				table.insert(itemTable,circleYellow)
				clearSubmenu()
				return true
			end


			if selectedItem.myName=="deleteTool" then
				print("delete tool clicked!")
				for key, item in ipairs(itemTable) do
					if item == editingItem then
						table.remove(itemTable, key);
						physics.removeBody(editingItem)
						editingItem:removeSelf()
						break
					end
				end
				return true
			end
			if selectedItem.myName=="pinOnTool" then
				print("pin on tool clicked!")
				for key, item in ipairs(itemTable) do
					if item == editingItem then
						editingItem.bodyType = "static"
						itemTable[key].bodyType = editingItem.bodyType
						print("item pinned")
						break
					end
				end
				return true
			end
			if selectedItem.myName=="pinOffTool" then
				print("pin off tool clicked!")
				for key, item in ipairs(itemTable) do
					if item == editingItem then
						editingItem.bodyType = "dynamic"
						itemTable[key].bodyType = editingItem.bodyType
						break
					end
				end
				return true
			end
			if selectedItem.myName=="gravityOffTool" then
				print("gravity off tool clicked!")
					stageProperties.gravity="off"
				return true
			end
			if selectedItem.myName=="gravityOnTool" then
				print("gravity off tool clicked!")
					stageProperties.gravity="on"
				return true
			end
		end
	elseif body.isFocus then
		if "moved" == phase then
			if physicsRun then
				if body then
					if body.tempJoint then
						if body.tempJoint.setTarget then
							body.tempJoint:setTarget( event.x, event.y )	
						end
					end
				end
			else--edit mode
				print(tostring(selectedItem.myName))
				if selectedItem.myName=="arcTool" then
					body.x=event.x
					body.y=gridSize*2
					if editingItem then
						editingItem.rotation=event.x

						 -- Update the corresponding entry in itemTable
						 for key, item in ipairs(itemTable) do
							if item == editingItem then
								itemTable[key].rotation = editingItem.rotation
								print ("rotation arc[key]:"..itemTable[key].rotation.."key:"..key)
								break
							end
						end

					end
					return true	
				end
				if not string.find(selectedItem.myName, "Tool") then
					body.x=event.x--move every item that is not a tool
					body.y=event.y
				end
			end
		elseif "ended" == phase or "cancelled" == phase then
			stage:setFocus( nil )
			body.isFocus = false
			if physicsRun then
				if body.tempJoint then
					if body.tempJoint.removeSelf then
						body.tempJoint:removeSelf()
					end
				end
			end
		end
	end

	return true
end
arc:addEventListener( "touch", dragObject )
addBlockTool:addEventListener( "touch", dragObject )
runTool:addEventListener( "touch", dragObject )
stopTool:addEventListener( "touch", dragObject )
deleteTool:addEventListener( "touch", dragObject )
saveTool:addEventListener( "touch", dragObject )
loadTool:addEventListener( "touch", dragObject )
pinOnTool:addEventListener( "touch", dragObject )
pinOffTool:addEventListener( "touch", dragObject )
gravityOffTool:addEventListener( "touch", dragObject )
gravityOnTool:addEventListener( "touch", dragObject )

-- sword:addEventListener( "touch", dragObject ) -- Uncomment to make the sword draggable too.

function clearAllObjects()
	--clear screen
	for key, item in ipairs(itemTable) do
		physics.removeBody(item)
		item:removeSelf()
	end
end

function balloonLevitate()
	if physicsRun then
		for key, item in ipairs(itemTable) do
			if item.myName=="balloon" then
				--print("balloon levitation force applied")
				item:applyForce(0, -2000, item.x, item.y )
			end
		end
	end
	for i, v in ipairs(removequeue) do
		if v then
			if v.removeSelf then
				physics.removeBody(v)
				v:removeSelf()
			end
		end
	end
	removequeue={}
end
function reproduceInitioalState()
	--reproduce initial state
	if itemTable then
		table.clear(itemTable)	
	end
	itemTable={}
	print("Saved Table Contents:")
	for key, item in ipairs(savedTable) do
		print("Block at", item.x, item.y, "Rotation:", item.rotation)
	end

	for key, item in ipairs(savedTable) do
		local imageA=nil
		local b=nil
		local paint=nil
		if item.myName=="block" then
			if item.color=="yellow" then
				imageA="img/block.png"
			elseif item.color=="red" then
				imageA="img/block-red.png"
			elseif item.color=="green" then
				imageA="img/block-green.png"
			elseif item.color=="blue" then
				imageA="img/block-blue.png"
			elseif item.color=="brick" then
				imageA="img/brick.png"
			elseif item.color=="goal" then
				imageA="img/goal.png"
			end
			b = display.newImage( imageA, item.x, item.y )
			physics.addBody( b, "dynamic", { density=1, friction=2, bounce=0 } )
		elseif item.myName=="circle" then
			b = display.newCircle( item.x, item.y, 64 )
			b.path.radius = 64
			if item.color=="yellow" then
				paint = {
					type = "image",
					filename = "img/ball-yellow.png"
				}
			elseif item.color=="red" then
				paint = {
					type = "image",
					filename = "img/ball-red.png"
				}
			elseif item.color=="green" then
				paint = {
					type = "image",
					filename = "img/ball-green.png"
				}
			elseif item.color=="blue" then
				paint = {
					type = "image",
					filename = "img/ball-blue.png"
				}
			end
			-- Fill the circle
			b.fill = paint
			physics.addBody( b, "dynamic", { radius=64/2,density=1, friction=2, bounce=0.4 } )
			print("added circle")
		elseif item.myName=="balloon" then
			b = display.newCircle( item.x, item.y, 64 )
			b.path.radius = 64
			if item.color=="purple" then
				paint = {
					type = "image",
					filename = "img/balloon.png"
				}
			end
			-- Fill the circle
			b.fill = paint
			physics.addBody( b, "dynamic", { radius=64/2,density=1, friction=2, bounce=0.4 } )
			
			print("added balloon")
		elseif item.myName=="spike" then
			b = display.newCircle( item.x, item.y, 64 )
			b.path.radius = 64
			if item.color=="grey" then
				paint = {
					type = "image",
					filename = "img/spike.png"
				}
			end
			-- Fill the circle
			b.fill = paint
			physics.addBody( b, "dynamic", { radius=64/2,density=1, friction=2, bounce=0.4 } )
			
			print("added spike")
		end
	
		b.angularDamping = 3
		b.rotation=item.rotation
		b.myName=item.myName
		print("item.bodyType:"..item.bodyType)
		b.bodyType=item.bodyType
		b.color=item.color
		b:addEventListener( "touch", dragObject )
		table.insert(itemTable,b)
	end
	physics.pause()
	print("item Table Contents:")
	for key, item in ipairs(itemTable) do
		print("Block at", item.x, item.y, "Rotation:", item.rotation)
	end
end	

function clearSubmenu()
	if addBlockYellow then
		addBlockYellow:removeSelf()
	end
	if addBlockRed then
		addBlockRed:removeSelf()
	end
	if addBlockGreen then
		addBlockGreen:removeSelf()
	end
	if addBlockBlue then
		addBlockBlue:removeSelf()
	end
	if addBlockBrick then
		addBlockBrick:removeSelf()
	end
	if addBlockGoal then
		addBlockGoal:removeSelf()
	end
	if addCircleYellow then
		addCircleYellow:removeSelf()
	end
	if addCircleRed then
		addCircleRed:removeSelf()
	end
	if addCircleGreen then
		addCircleGreen:removeSelf()
	end
	if addCircleBlue then
		addCircleBlue:removeSelf()
	end
	if addBalloon then
		addBalloon:removeSelf()
	end
	if addSpike then
		addSpike:removeSelf()
	end
	submenuShowing=false
end

balloonLevitateTimer = timer.performWithDelay( 180, balloonLevitate, 0 )

removequeue={}
local function onGlobalCollision( event )
	if physicsRun then
		if event.object1.myName and event.object2.myName then
			if ( event.phase == "began" ) then
				print( "began: " .. event.object1.myName .. " and " .. event.object2.myName )
				if event.object1.myName=="balloon" and event.object2.myName=="spike" then
					for key, item in ipairs(itemTable) do
						if item == event.object1 then
							table.remove(itemTable, key);
							--physics.removeBody(event.object1)
							--event.object1:removeSelf()
							table.insert(removequeue,event.object1)
							break
						end
					end
				elseif event.object1.myName=="spike" and event.object2.myName=="balloon" then
					for key, item in ipairs(itemTable) do
						if item == event.object2 then
							table.remove(itemTable, key);
							--physics.removeBody(event.object2)
							--event.object2:removeSelf()
							table.insert(removequeue,event.object2)
							break
						end
					end
				end
			elseif ( event.phase == "ended" ) then
				print( "ended: " .. event.object1.myName .. " and " .. event.object2.myName )
			end
		end
	end
end
 
Runtime:addEventListener( "collision", onGlobalCollision )

local defaultField
local button1
local textBoxBackground
local myText
local defaultField
inputedText=""
total=""
textField=nil
local tableView

function textListener( event )
 
    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
		--both of the following are empty!!!
		print( "ended input event :" .. textField.text) 
		print( "ended input event :" .. event.target.text) 
		print( "new characters :" .. inputedText)
		inputedText=event.target.text
		print("final name is:" .. inputedText)

		--saveFile(inputedText,total)
		--button1:removeSelf()
		--textBoxBackground:removeSelf()
		--myText:removeSelf()
		--textField:removeSelf()
		inputedText=""
    elseif ( event.phase == "editing" ) then
        --this is not ideal but at least it works
		--inputedText=inputedText..event.newCharacters
		print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
		--inputedText=event.text
    end
end


-- Function to handle button events
local function handleButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Button was pressed and released" )
		--**probl;em with input text!!! it is empty!problem with total variable? out of scope?
		--native.showAlert("alertbox", "here99".. inputedText.."total"..total, {"OK"})
		saveFile(inputedText,total)
		button1:removeSelf()
		textBoxBackground:removeSelf()
		myText:removeSelf()
		textField:removeSelf()
		inputedText=""
		--defaultField	
    end
end

function displayInputBox(prompt)
	showInputBox("enter omohca name:",saveFile)
end

local textLabelTable={}

function fileClickEventListener(event)
	if event.phase == "began" then
		print("loading:"..event.target.text.."...")
		loadStageFromFile(event.target.text)
		for key, value in ipairs(textLabelTable) do
			if value.removeSelf then
				value:removeSelf()
			end
		end
	end
end

local function onRowRender(event)
	local row = event.row
	local params = row.params

	-- Create a text object for the row's content
	local rowText = display.newText({
		text = params.filename, -- Use the filename from the params
		x = row.contentWidth * 0.5,
		y = row.contentHeight * 0.5,
		font = native.systemFont,
		fontSize = 16,
		align = "left"
	})

	rowText:setFillColor(0) -- Set text color to black
	row:insert(rowText) -- Insert the text into the row
end

local function onRowTouch(event)
    local row = event.target
    local params = row.params -- Retrieve the params passed to the row

    if event.phase == "began" then
        -- Highlight the row (optional)
        row.alpha = 0.5
        print("Touched row: " .. params.filename)

    elseif event.phase == "moved" then
        -- Optionally handle drag or movement
        print("Moving on row: " .. params.filename)

    elseif event.phase == "release" then
        -- Perform action when row is clicked (released)
        row.alpha = 1 -- Restore row alpha
        print("Clicked row: " .. params.filename)
        -- Custom logic: open file, change scene, etc.
		--**loadStageFromFile(params.filename)
		if not sevrer then
			server="https://amjp.psy-k.org/omocha123/"	
		end
	
		-- URL of the PHP script
		local url = server .."/downloadOmocha123file.php" -- Replace with your actual server URL
	
		-- String to post
		local filename = params.filename -- Replace with the filename string
		--local fileContent = content -- Replace with the content string
	
		-- Function to handle network response
		local function networkListener(event)
			if (event.isError) then
				print("Network error: ", event.response)
				native.showAlert("Error", "Network error occurred.", {"OK"})
			else
				print("Response: ", event.response)
				if event.response == nil then
					native.showAlert("Response", "error occured while loding file from cloud", {"OK"})
				end
				if not physicsRun then
					total=event.response
					local loadTable=splitString(total,"|")
					print("items:"..loadTable[1])
					print("stage properties:"..loadTable[2])
					savedTable=deepCopy(json.decode( loadTable[1] ))
					stageProperties=deepCopy(json.decode( loadTable[2] ))
					print(dumpTable(savedTable))
					clearAllObjects()
					reproduceInitioalState()
					if tableView then
							tableView=nil
					end
				end		
			end
		end
	
		-- Prepare the POST data
		local params = {
			body = "filename=" .. filename,
			headers = {
				["Content-Type"] = "application/x-www-form-urlencoded",
			}
		}
	
		-- Send POST request
		network.request(url, "POST", networkListener, params)
	
	
		local fileName=params.filename
		tableView:removeSelf()
		for key, value in ipairs(textLabelTable) do
			if value.removeSelf then
				value:removeSelf()
			end
		end
	end
    return true -- Prevent touch propagation to other objects
end

function displayFileList(prompt,extention)
	-- Usage example
	filePath=system.pathForFile( "" , system.DocumentsDirectory)
	local directory = filePath -- Current directory
	local extension = "txt" -- Extension you're looking for
	
	if not sevrer then
		server="https://amjp.psy-k.org/omocha123/"	
	end
	local files = {}
	-- URL of the PHP script
	local url = server .. "/listFilesOmocha123.php" -- Replace with your actual server URL

	-- String to post
	--local filename = "testfile.txt" -- Replace with the filename string
	--local fileContent = "This is the content of the file." -- Replace with the content string

	-- Function to handle network response
	local function networkListener(event)
		if tableView then
			--todo, add cancel button
			return
		end
		if (event.isError) then
			print("Network error: ", event.response)
			native.showAlert("Error", "Network error occurred.", {"OK"}, function() end)
		else
			--print("Response: ", event.response)
			--native.showAlert("Response", event.response, {"OK"}, function() end)
			-- Iterate over each file in the directory
			if event.response==nil then
				native.showAlert("Response", "server empty", {"OK"}, function() end)
				return false
			end
			local omocha123Files = splitString(event.response, ",")

			-- Print the results
			fileX=300
			fileY=170
			myText = display.newText( prompt, fileX, fileY, native.systemFont, 50 )
			myText:setFillColor( 1, 1, 1 )
			fileY=fileY+50
			table.insert(textLabelTable,myText)
			
			tableView = widget.newTableView(
				{
					left = 200,
					top = 200,
					height = 330,
					width = 300,
					onRowRender = onRowRender,
					onRowTouch = onRowTouch,
					listener = scrollListener
				}
			)
			
			for _, file in ipairs(omocha123Files) do
				print(file)
				-- Insert a row into the tableView
				tableView:insertRow{
					rowHeight = 40,
					params = { filename = file }
				} -- Pass file name as parameter}
			end
		
			return filesArray
		end
	end

	-- Prepare the POST data
	local params = {
		body = "",--no data needs to be send
		headers = {
			["Content-Type"] = "application/x-www-form-urlencoded",
		}
	}

	-- Send POST request
	print(url)
	network.request(url, "POST", networkListener, params)

	-- Example of showing an alert box with a variable's content
	local function showAlert()
		local alertMessage = "The filename is: " .. filename
		native.showAlert("Alert", alertMessage, {"OK"}, function() end)
	end

end

 
 

function saveStage()
	if not physicsRun then
		saveCurrentState()
		local serializedJSONblocks = json.encode( savedTable )
		local serializedJSONstage = json.encode( stageProperties )
		total=serializedJSONblocks.."|"..serializedJSONstage
		--textBoxBackground=display.newRect( gridSize*5-10, gridSize*5-10, 380+10, gridSize*5+10 )
		--textBoxBackground.strokeWidth = 3
		--textBoxBackground:setFillColor( 0,0,0 )
		--textBoxBackground:setStrokeColor( 0, 1, 0 )
		displayInputBox("File Name, then [ENTER]")
	end
end

function readFile(fileName)
	filePath = system.pathForFile( fileName , system.DocumentsDirectory)
	-- Opens a file in read mode
	file = io.open(filePath, "r")

	-- prints the first line of the file
	lines = file:read()

	-- closes the opened file
	file:close()

	return lines
end

--[[
function saveStage()
	if not physicsRun then
		saveCurrentState()
		local serializedJSONblocks = json.encode( savedTable )
		local serializedJSONstage = json.encode( stageProperties )
		total=serializedJSONblocks.."|"..serializedJSONstage
		saveFile("saved.omocha123",total)

		total=readFile("saved.omocha123")
		loadTable=splitString(total,"|")
		print("items:"..loadTable[1])
		print("stage properties:"..loadTable[2])
	end
end
--]]

function loadStageFromFile(filename)
	if not physicsRun then
		total=readFile(filename)
		loadTable=splitString(total,"|")
		print("items:"..loadTable[1])
		print("stage properties:"..loadTable[2])
		savedTable=deepCopy(json.decode( loadTable[1] ))
		stageProperties=deepCopy(json.decode( loadTable[2] ))
		print(dumpTable(savedTable))
		clearAllObjects()
		reproduceInitioalState()
	end
end

function saveCurrentState()
	--save initial positions
	if savedTable then
		table.clear(savedTable)
	end
	savedTable={}
	for key, item in ipairs(itemTable) do
		obj={}
		obj.x=item.x
		obj.y=item.y
		print("item rotation to save:"..item.rotation)
		obj.rotation=item.rotation
		obj.myName=item.myName
		obj.bodyType=item.bodyType
		obj.color=item.color
		table.insert(savedTable, obj)
		print("itemTable[1].rotation:", itemTable[1].rotation) -- Debug here
		print("item rotation to save:", item.rotation) -- Debug here
	end
	print("Saved Table Contents:")
	for key, item in ipairs(savedTable) do
		print("Block at", item.x, item.y, "Rotation:", item.rotation)
	end
end	
--(fixed, variable scope problem for paint variable) bug, cicles dissapear after run . also add shape circle or block, it is inside myName, I will just use myName to determine shape
--(fixed)bug,red ball turns green when run
--(fixed,needed to add spikes to first if statement with blocks and circles)bug, spikes cant be pinned
--(fixed)need to remove submenu when block clicked second time
--I should make a visual way of seeing the contents of files before you load them
--balloon explode even when not in physicsRun mode
