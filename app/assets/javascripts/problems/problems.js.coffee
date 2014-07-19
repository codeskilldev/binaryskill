//= require_tree
//= require FileSaver
//= require Blob

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

digit = 0
min = 0
time = 0
timer_is_on = 0

# [Give Hints - Story 3.6, Problem Timer - Story 3.10, Consistent Timer - Story 3.13]
# Counts up the time spent so far on the problem since the page opened
# 	and displays hints accordingly
# Parameters: none
# Returns: none
# Author: Mohamed Fadel + Rami Khalil
timer = ->
	digit++
	if digit > 59
		min++
		document.getElementById("mins").innerHTML = min
		digit = 0
	if digit <= 9
		digit = "0" + digit
	document.getElementById("secs").innerHTML = digit
	i = 0
	while true
		tip = $('#tip' + i)
		if typeof(tip.attr 'time') == 'undefined'
			break
		if typeof(tip.attr 'shown') == 'undefined'
			time = tip.attr 'time'
			if time <= min*60 + parseInt(digit, 10)
				tip.attr 'class', ''
				the_tip = 'Tip: ' + tip.html()
				tip.attr 'shown', ''
				log = alert the_tip, 'log', 0
		i++
	return

activate = ->
	unless timer_is_on
		timer_is_on = 1
		time = setInterval(timer, 1000)
		timer

@toggle_description = ->
	elem = $('span#desc.glyphicon.hover')
	if elem.hasClass('glyphicon-chevron-up')
		$('section div.problem.panel-collapse').collapse('hide')
		elem.removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down')
	else
		$('section div.problem.panel-collapse').collapse('show')
		elem.removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up')
	return

# [Design - Story Design]
# Start counter if the two labels with ids "mins" and "secs" exists
# Parameters: none
# Returns: none
# Author: Mussab ElDash
jQuery ->
	if element_exists("mins") and element_exists("secs")
		activate()
	if element_exists("editor")
		editor = ace.edit("editor")
		edit_session = editor.getSession()
		default_code = $('#problem_default_code').val()
		student_code = $('#problem_student_code').val()
		if student_code == ""
			edit_session.setValue(default_code)
		else
			edit_session.setValue(student_code)
		editor.setTheme("ace/theme/twilight")
		edit_session.setMode("ace/mode/java")
		$('body').on('contextmenu', '#editor > :not(.ace_gutter)', (e) ->
			false
		)
		$('body').on('contextmenu', '#editor > .ace_gutter', (e) ->
			false
		)
		# Add Save Command using Ctrl+S buttons
		editor.commands.addCommand
			name: 'Save'
			bindKey: {win: 'Ctrl-S',  mac: 'Command-S'}
			exec: (editor) ->
				class_name = $("#class_name").val()
				input = editor.getSession().getValue()
				blob = new Blob([input], type: "text/plain;charset=utf-8")
				saveAs(blob, class_name + ".java")
				return
			readOnly: true # false if this command should not apply in readOnly mode

		ClipBoardText = null

		# Override the Use of Crtl+V combination buttons to paste
		editor.commands.addCommand
			name: 'Override-Paste'
			bindKey: {win: 'Ctrl-V',  mac: 'Command-V'}
			exec: (editor) ->
				editor.insert(ClipBoardText)
			readOnly: true
		# Override the Use of Crtl+C combination buttons to copy
		editor.commands.addCommand
			name: 'Override-Copy'
			bindKey: {win: 'Ctrl-C',  mac: 'Command-C'}
			exec: (editor) ->
				ClipBoardText = editor.getCopyText()
			readOnly: true
		# Override the Use of Crtl+X combination buttons to cut
		editor.commands.addCommand
			name: 'Override-Cut'
			bindKey: {win: 'Ctrl-X',  mac: 'Command-X'}
			exec: (editor) ->
				ClipBoardText = editor.getCopyText()
				editor.remove(ClipBoardText)
			readOnly: false
	return