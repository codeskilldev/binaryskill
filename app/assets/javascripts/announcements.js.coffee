innerHTML = {}
datas = {}
@edit_announcement = (id, edit) ->
	$.ajax
		type: "GET"
		url: "/announcements/#{id}/edit"
		success: (data) ->
			edit_form_announcement id, data
		datatype: "JSON"
		error: ->
			alert "Failed to update the announcement, Try again Later"

edit_form_announcement = (id, data) ->
	container = $("#announcement_#{id}")
	innerHTML[container[0].id] = container.html()
	container.html("<textarea id='textarea_#{id}' \
		placeholder='Enter text ...'>#{data.content}</textarea>\
		<input class='btn btn-default btn-sm' value='Update' onclick='update_announcement(#{id})'>\
		<input class='btn btn-default btn-sm' value='Cancel' \
		onclick='refill_announcement(#{id})'>")
	datas[id] = data
	$("#announcement_date_#{id}").html(data.date)

@update_announcement = (id) ->
	data_input = $("#textarea_#{id}").val()
	$.ajax
		type: "PATCH"
		url: "/announcements/#{id}"
		data: {content: data_input}
		success: (data) ->
			refill_announcement(id, data)
		datatype: "JSON"
		error: ->
			alert "Failed to update the announcement, Try again Later"

@refill_announcement = (id, data) ->
	container = $("#announcement_#{id}")
	container.html(innerHTML[container[0].id])
	delete innerHTML[container[0].id]
	unless data
		data = datas[id]
		delete datas[id]
	$("#announcement_content_#{id}").html("<h2>#{data.content}</h2>")
	$("#announcement_date_#{id}").html("<font>#{data.date} ago</font>")

@delete_announcement = (id) ->
	$.ajax
		type: "DELETE"
		url: "/announcements/#{id}"
		success: ->
			$("#announcement_#{id}").fadeOut 500, ->
				$(this).remove()
			$("#announcement_date_#{id}").next("hr").fadeOut 500, ->
				$(this).remove()
			$("#announcement_date_#{id}").fadeOut 500, ->
				$(this).remove()
		error: ->
			alert "Failed to delete the announcement, Try again Later"

create_new_announcement = (data) ->
	elem_text = "<div class='row' id='announcement_#{data.id}'>\
		<div class='col-sm-10' id='announcement_content_#{data.id}'>\
		<h2>#{data.content}</h2></div>\
		<div class='col-sm-2'><div class='col-sm-5 pull-right'>\
		<img alt='Delete button 2' onclick='delete_announcement(#{data.id})' \
		src='/assets/delete_button_2.png'></div>\
		<div class='col-sm-5 pull-right'><img alt='Edit button' \
		onclick='edit_announcement(#{data.id})' src='/assets/edit_button.png'></div>\
		</div></div>\
		<div class='pull-right' id='announcement_date_#{data.id}'><font>#{data.date}</font></div><hr>"
	$(".announcement .main_row").prepend($(elem_text))
	$("#textarea_new").val("")

$ ->
	$("#announcement_new").click ->
		data_input = $("#textarea_new").val()
		$.ajax
			type: "POST"
			url: "/announcements"
			data: 
				content: data_input
				course_id: $(".announcement .main_row").data("course")
			success: (data) ->
				create_new_announcement data
				e.preventDefault()
				$('html, body').animate
					scrollTop: $("#announcement_#{data.id}").offset().top
				, 2000
				return
			error: ->
				alert "Failed to add new announcement, Try again Later"