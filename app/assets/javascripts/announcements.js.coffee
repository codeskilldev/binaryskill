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
			$("#announcement_content_#{id}").remove()
			$("#announcement_date_#{id}").next("hr").remove()
			$("#announcement_date_#{id}").remove()
		error: ->
			alert "Failed to delete the announcement, Try again Later"