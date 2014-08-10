/* Place all the behaviors and hooks related to the matching controller here.
 * All this logic will automatically be available in application.js.
 * You can use CoffeeScript in this file: http://coffeescript.org/
 */

// # [Design_layout - Story 2.13]
// # Description: Editing the information 
// # Parameters:
// # 	data: the data to be showed
// # Returns:
// # 	none
// # Author: Ahmed Mohamed Magdi
function edit_form_course(data) {
	$("#course-name").html("<input type=\"text\" name=\"coursename\" id=\"coursename\" value=\""+data.name+"\" placeholder=\"name\">")
	$("#course-code").html("<input type=\"text\" name=\"coursecode\" id=\"coursecode\" value=\""+data.code+"\" placeholder=\"code\">")
	$("#course-link").html("<input type=\"text\" name=\"courselink\" id=\"courselink\" value=\""+data.link+"\" placeholder=\"code\">")
	$("#course-description").html("<textarea type=\"text\" name=\"coursedesc\" id=\"coursedesc\" placeholder=\"description\">"+data.description+"</textarea>")
	$("#course-semester").html("<input type=\"text\" name=\"coursesmester\" id=\"coursesemester\" value=\""+data.semester+"\" placeholder=\"semester\">")
	$("#course-year").html("<input type=\"text\" name=\"courseyear\" id=\"courseyear\" value=\""+data.year+"\" placeholder=\"year\">")
	$("#course-submition").html("<button class=\"btn btn-success submit-course\" type=\"button\" onclick=\"update_course();\">Save</button>")
}

// # [Design_layout - Story 2.13]
// # Description: Sends the data to the view
// # Parameters:
// # 	course_up: course updated info
// # Returns:
// # 	none
// # Author: Ahmed Mohamed Magdi
function reset_form_course(course_up) {
	form_print_html("course-name", course_up.name);
	form_print_html("course-code", course_up.code);
	form_print_html("course-link", course_up.link);
	form_print_html("course-description", course_up.description);
	form_print_html("course-semester", course_up.semester);
	form_print_html("course-year", course_up.year);
	$("#course-submition").html("")
}

// # [Design_layout - Story 2.13]
// # Description: For fringing the delfaul view before editing
// # Parameters:
// # 	div_id: The course ID
// # 	info: the data to be showed
// # Returns:
// # 	none
// # Author: Ahmed Mohamed Magdi
function form_print_html(div_id,info) {
	$("#"+div_id).html("<p><font> "+info+" </font></p>")
}

// # [Design_layout - Story 2.13]
// # Description: For editing the course
// # Parameters:
// # 	course_id: The course ID
// # Returns:
// # 	none
// # Author: Ahmed Mohamed Magdi
var course;
function edit_course(course_id) {
	course = course_id;
	$.ajax({
		type: "GET",
		url: "/courses/find_course/"+course_id,
		data:{
			id: course_id
		},
		success: function(data) {
			edit_form_course(data);
		},
		error: function() {
			alert("Unable to connect to server");
		}
	});
}

// # [Design_layout - Story 2.13]
// # Description: For updateing the course
// # Parameters:
// # 	none
// # Returns:
// # 	alert: for successfully created or not
// # Author: Ahmed Mohamed Magdi
function update_course() {
	Cname = $("#coursename").val();
	Ccode = $("#coursecode").val();
	Clink = $("#courselink").val();
	Csemester = $("#coursesemester").val();
	Cyear = $("#courseyear").val();
	Cdesc = $("#coursedesc").val();
	course_up = {
				name:Cname,
				code: Ccode,
				link: Clink,
				semester: Csemester,
				year: Cyear,
				desc: Cdesc 
			}
	$.ajax({
		type: "PATCH",
		url: "/courses/"+course,
		data:{
			id: course,
			course: course_up
		},
		success: function(data) {
			reset_form_course(data);
			alert("Changes success")
		},
		error: function() {
			alert("Wrong Inputs");
		}
	});
}

// # [Design_layout - Story 2.13]
// # Description: For acknowledgement students via lecturers
// # Parameters:
// # 	courseid: The course ID
// # Returns:
// # 	alert: for successfully created or not
// # Author: Ahmed Mohamed Magdi
function acknowledge(courseid){
	students_selected = $("#students_").val();
	desc = $("#acknowledgement_description").val();
	$.ajax({
		type: "POST",
		url: "/courses/"+courseid+"/acknowledgements",
		data:{
			course_id: courseid,
			students: students_selected,
			description: desc
		},
		success: function(data) {
			alert("Acknowledgements sent successfully")
		},
		error: function() {
			alert("Wrong Inputs, check student selectoins")
		}
	});
}

function disable_element(id, bool= true){
	$('#'+id).prop("disabled", bool);
}

// [Edit Course Sign Up]
// Sends request for data to populate form drop-down lists
// Parameters:
// 	key: label of drop-downlist, example: university
// 	value: value selected by user for th previous key, example: 'GUC'
// Author: Mohab Ghanim
function add_options(key, value){
	if (value != ""){
		$.ajax({
			type: "GET",
			url: '/courses/return_list?'+ key + "=" + value ,
			datatype: 'json',
			success: function(json){
				populate_list(json, key)
			} 
		})
	}
}

// [Edit Course Sign Up]
// Fills drop-down list with data recieved from ajax request
// Parameters:
// 	data: data recieved from request
// 	key: label of drop-downlist, example: university
// Author: Mohab Ghanim
function populate_list(data, key){
	var element;
	if (key == "university"){
		element = $("#course_registration_semester");
		$("#course_registration_course").val(" ");
		$("#course_registration_lecturer").val(" ");
		$("#form_submit").prop("disabled", true);
	}else if (key == "semester") {
		element = $("#course_registration_course");
		$("#course_registration_lecturer").val(" ");
		$("#form_submit").prop("disabled", true);
	}else if (key == "course"){
		element = $("#course_registration_lecturer");
		$("#form_submit").prop("disabled", true);
	}
	if (element) {
		element.html("");
		element.prop("disabled", false);
		element.append("<option></option>")
		$.each(data, function(i, list_item){
			list_item = data[i];
			element.append("<option value=" + i + ">" + list_item + "</option>")
		})
	}
}