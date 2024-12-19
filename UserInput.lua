-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
rectBorder=nil
rectEdit=nil
lblTitle=nil
editBuffer=nil
local _callback=nil

function myHelpTouchListener( event )
	print("ok clicked!")
	_callback(inputBuffer)
	removerInputBox()
    return true  -- Prevents tap/touch propagation to underlying objects
end



offsetx=500
offsety=600

local paint = {
    type = "image",
    filename = "img/ok.png"
}
okButton = display.newRect(offsetx, offsety, 200, 100 )
okButton.fill = paint
okButton:addEventListener( "touch", myHelpTouchListener )  -- Add a "touch" listener to the obj
okButton.isVisible=false
local paint = {
    type = "image",
    filename = "img/ok.png"
}
myHelpCloseButton = display.newRect(offsetx, offsety, 150, 150 )
myHelpCloseButton.fill = paint

myHelpCloseButton:addEventListener( "touch", myHelpTouchListener )  -- Add a "touch" listener to the obj
myHelpCloseButton.isVisible=false
if system.getInfo("platform")=="html5" then
	okButton.isVisible=false
else
	okButton.isVisible=false
end

function drawBorder(x,y,width,height)
		rectBorder = display.newRect(x,y,width,height)
		rectBorder.strokeWidth = 5
		rectBorder:setFillColor( 0, 0 , 0, 0.5 )
		rectBorder:setStrokeColor( 1, 1, 1 )
end
editBuffer=nil
function drawInputPrompt(x,y,width,height,prompt)
		lblTitle = display.newText( prompt, x, y, "fonts/ume-tgc5.ttf", 50 )
		lblTitle:setFillColor( 0.82, 0.86, 1 )
		editBuffer = display.newText( "", x, y+100, "fonts/ume-tgc5.ttf", 50 )
		editBuffer:setFillColor( 0.82, 0.86, 1 )
		rectEdit = display.newRect(x,y+100,width-300,height-700)
		rectEdit.strokeWidth = 5
		rectEdit:setFillColor( 1, 1 , 1, 0.5 )
		rectEdit:setStrokeColor( 1, 1, 1 )
end

function removeScreenKeyboard()
	print("RemoveScreenKeyboard called")
	for key, value in ipairs(keysLablesTable) do
		--print(value)
		value.isVisible=false
		if value.removeSelf then
			value:removeSelf()
		end
	end
end

function removerInputBox()
	if rectBorder.removeSelf then
		rectBorder:removeSelf()
	end
	if rectEdit.removeSelf then
		rectEdit:removeSelf()
	end
	if lblTitle.removeSelf then
		lblTitle:removeSelf()
	end
	if editBuffer.removeSelf then
		editBuffer:removeSelf()
	end
	if okButton.removeSelf then
		--okButton:removeSelf()
		okButton.isVisible=false
	end
	removeScreenKeyboard()
	Runtime:removeEventListener( "enterFrame", frameUpdate )
	Runtime:removeEventListener( "key", onKeyEvent )
	
end

--handle keystrokes
downkey=""
inputBuffer=""
local action = {}
function addInputToBuffer(downkey)
	if downkey == "enter" then
		print("inputBuffer:"..inputBuffer)
		_callback(inputBuffer)
		inputBuffer=""
		downkey=""
		removerInputBox()
	end
	if downkey == "deleteBack" or downkey == "back" or downkey == "<<" then
		inputBuffer = inputBuffer:sub(1, -2)--deletes last character off the buffer
		print("delete pressed")
		downkey=""
	end

	if downkey == "escape" then
		inputBuffer = ""
		print("escape pressed")
		downkey=""
	end

	if downkey == "space" then
		inputBuffer = inputBuffer .. " "
		print("space pressed")
		downkey=""
	end

	if downkey == "unknown" then
		print("unknown key pressed")
		downkey=""
		return
	end
		
	if downkey ~= "" then
		print("downkey:"..downkey)
		inputBuffer=inputBuffer..downkey
		downkey=""
	end
	
	editBuffer.text=inputBuffer
end
function frameUpdate()
	local keyDown = false
	-- See if one of the selected action buttons is down and move the knight.
	if downkey then
		addInputToBuffer(downkey)
		downkey=""
	end
end

function onKeyEvent( event )
	if event.phase == "down" then
	else
		downkey=event.keyName
	end
end
--help button
webView=nil
keysTable={}
keysLablesTable={}
local functionTable={}
function getFunctionName()
    local info = debug.getinfo(2, "n")
    return info.name or "anonymous"
end
function clickOnScreenKeys(event)
	if event.phase == "ended" then
		print("clickOnScreenKeys called")
		print(event.target.text)
		addInputToBuffer(event.target.text)
	end
end

function bringUpScreenKeyboard()
	keysTable={}
	table.insert(keysTable, "1")
	table.insert(keysTable, "2")
	table.insert(keysTable, "3")
	table.insert(keysTable, "4")
	table.insert(keysTable, "5")
	table.insert(keysTable, "6")
	table.insert(keysTable, "7")
	table.insert(keysTable, "8")
	table.insert(keysTable, "9")
	table.insert(keysTable, "0")
	table.insert(keysTable, "-")
	table.insert(keysTable, "<<")
	local xoffset=100
	local yoffset=100
	for key, value in ipairs(keysTable) do
		local lable = display.newText( value, xoffset, yoffset, "fonts/ume-tgc5.ttf", 50 )
		lable:setFillColor( 0.82, 0.86, 1 )
		lable:addEventListener( "touch", clickOnScreenKeys )
		table.insert(keysLablesTable, lable)
		xoffset=xoffset+50
	end
	yoffset=yoffset+50
	xoffset=125
	keysTable={}
	table.insert(keysTable, "q")
	table.insert(keysTable, "w")
	table.insert(keysTable, "e")
	table.insert(keysTable, "r")
	table.insert(keysTable, "t")
	table.insert(keysTable, "y")
	table.insert(keysTable, "u")
	table.insert(keysTable, "i")
	table.insert(keysTable, "o")
	table.insert(keysTable, "p")
	for key, value in ipairs(keysTable) do
		local lable = display.newText( value, xoffset, yoffset, "fonts/ume-tgc5.ttf", 50 )
		lable:setFillColor( 0.82, 0.86, 1 )
		lable:addEventListener( "touch", clickOnScreenKeys )
		table.insert(keysLablesTable, lable)
		xoffset=xoffset+50
	end
	yoffset=yoffset+50
	xoffset=150
	keysTable={}
	table.insert(keysTable, "a")
	table.insert(keysTable, "s")
	table.insert(keysTable, "d")
	table.insert(keysTable, "f")
	table.insert(keysTable, "g")
	table.insert(keysTable, "h")
	table.insert(keysTable, "j")
	table.insert(keysTable, "k")
	table.insert(keysTable, "l")
	for key, value in ipairs(keysTable) do
		local lable = display.newText( value, xoffset, yoffset, "fonts/ume-tgc5.ttf", 50 )
		lable:setFillColor( 0.82, 0.86, 1 )
		lable:addEventListener( "touch", clickOnScreenKeys )
		table.insert(keysLablesTable, lable)
		xoffset=xoffset+50
	end
	yoffset=yoffset+50
	xoffset=175
	keysTable={}
	table.insert(keysTable, "z")
	table.insert(keysTable, "x")
	table.insert(keysTable, "c")
	table.insert(keysTable, "v")
	table.insert(keysTable, "b")
	table.insert(keysTable, "n")
	table.insert(keysTable, "m")
	table.insert(keysTable, "_")
	for key, value in ipairs(keysTable) do
		local lable = display.newText( value, xoffset, yoffset, "fonts/ume-tgc5.ttf", 50 )
		lable:setFillColor( 0.82, 0.86, 1 )
		lable:addEventListener( "touch", clickOnScreenKeys )
		table.insert(keysLablesTable, lable)
		xoffset=xoffset+50
	end
	yoffset=yoffset+50
	xoffset=350
	local lable = display.newText( "space", xoffset, yoffset, "fonts/ume-tgc5.ttf", 50 )
	lable:setFillColor( 0.82, 0.86, 1 )
	lable:addEventListener( "touch", clickOnScreenKeys )
	table.insert(keysLablesTable, lable)
	
end


function showInputBox(prompt,callback)
	print("showInputBox called")
	_callback=callback
	okButton.isVisible=true
	drawBorder(display.contentCenterX, display.contentCenterY, 1000-100, 800-50)
	drawInputPrompt(display.contentCenterX, display.contentCenterY, 1000-100, 800-50,prompt)
	Runtime:addEventListener( "enterFrame", frameUpdate )
	Runtime:addEventListener( "key", onKeyEvent )
	--maybe do this optionally if on touchscreen
	bringUpScreenKeyboard()	
end
--call the following way in your program
function callback(userinput)
	print("the user inputed"..userinput)
	native.showAlert(
		"the user inputed", -- Title of the alert
		"the user inputed:"..userinput, -- Message content
		{ "OK" } -- Button labels
		--onComplete -- Listener for button clicks
	)
end