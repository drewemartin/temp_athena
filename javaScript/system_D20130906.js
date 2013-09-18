//Jquery UI Elements------------------------------------------------------------
function x___________________GENERAL_WEBPAGE_FUNCTIONS(){}
//------------------------------------------------------------------------------

var athena = "D20130906"

var action_group = undefined;
function add_student(element, sid){
	if(element.value == 1){
                
		if(action_group == undefined){
			action_group = sid
		}else{
			included = action_group.split(':')
			if(included.indexOf(sid) == -1){
				action_group = action_group + ':' + sid;
			}
		}
		
	}else{
		if(action_group != undefined){
			included = action_group.split(':')
			if(included.indexOf(sid) != -1){
				action_group = action_group.replace(':'+sid,	''	);
				action_group = action_group.replace(sid,	''	);	
			}
			if(action_group.length == 0){
				action_group = undefined;
			}
		}
	}
}
function group_action_request(action){
	send(action+",action_group="+action_group);
}

//Adds new HTML content to the end of parent
function appendInnerHTML(id, newContent){
	
	$("#" + id).append(newContent)
	
}

//Appends error message box
function appendMessageBox(message){
	
	$("#message_box", parent.document).append(message+"<br>")
	
}

//Clears the loading Ajax Spinner that appears in the lower right of the page
function clearSpinner(){
	
	parent.document.getElementById('loading_box'  ).innerHTML = "";
	parent.document.getElementById('loading_cover').innerHTML = "";
	
}

//Adds new HTML content to the beginning of parent
function prependInnerHTML(id, newContent){
	
	$("#" + id).prepend(newContent)
	
}

//Changes the selected tab
function selectTab(tabNum){
	
	$('.ui-tabs').tabs('option', 'selected', (tabNum-1));
	
}

// FNORD - When this is read into the ruby output change this explicit path to a $config reference
//Sets the loading Ajax Spinner that appears in the lower right of the page
function setActivitySpinner(){
	
	var load_img = '<img style=\"display:block; height:18px; width:120px; border:none;\" src=\"/athena/images/ajax-loader_08.gif\"/>'
	parent.document.getElementById('loading_box').innerHTML = load_img;
	
}

//Clears the border of the element. Used to clear a red error border
function setDefaultBorder(id){
	
	var element = document.getElementById(id);
	element.style.border = '';
	
}

//Sets the border of the element to 1px-solid-red
function setErrorBorder(id){
	
	var element = document.getElementById(id);
	if(element != undefined){
		element.style.border = '1px solid red';
	}
	
}

//Replaces content with a loading spinner
function setPreSpinner(id){
	
	document.getElementById(id).innerHTML = spinner()
	
}

//Returns Ajax Spinner Animated Gif
function spinner(){
	
	return "<img src='/athena/images/ajax-loader_07.gif' style='display:block; margin-left:auto; margin-right:auto; padding:10px'/>"

}

//Sets the appropriate value of a checkbox when it is clicked
function toggle_checkbox(checkbox){
	
	if(checkbox.value == '1'){
		
		checkbox.value = '0';
		
	}else if(checkbox.value == '0' || checkbox.value == ''){
		
		checkbox.value = '1';
		
	}
	
}

//Replaces HTML content
function updateInnerHTML(id, content){
	
	document.getElementById(id).innerHTML = content;
	
}

//Updates error message box
function updateMessageBox(message){
	
	$("#message_box", parent.document).html(message)
	
}

//Jquery UI Elements------------------------------------------------------------
function x___________________AJAX_AND_RESPONSE_PROCESSING(){}
//------------------------------------------------------------------------------

//Extracts the content from an Ajax Response as a useable hash
function extractContent(response){
	
	//error_message
	updateMessageBox("");
	
	var evalArr = response.match(/<eval_script[\s\S]*?<\/eval_script>/g);
	response	= response.replace(evalArr, '')
	var errorArr = response.match(/<error_communication[\s\S]*?<\/error_communication>/g);
	
	for (errorArr_i in errorArr){
		
		appendMessageBox(errorArr[errorArr_i]);
		
	}
	
	//modify_tag_content
	var contentArr = response.match(/<contentStart__[\s\S]*?<\/contentEnd>/g);
	
	for (content_i in contentArr){
		
		var opening_tag = contentArr[content_i].match(/<contentStart__[\s\S]*?>/g)[0];
		var type 	= opening_tag.split("__")[1];
		var id 		= opening_tag.split(type+"__")[1].split(">")[0]
		var new_value	= contentArr[content_i].replace(opening_tag,"").replace("</contentEnd>","")
		
		var element 	= document.getElementById(id)
		
		var attach = true
		
		if (element != undefined){
			
			if (type == "update"){
				
				updateInnerHTML(id, new_value)
				
				if (id == "student_page_view_container"){
					
					attach = false
					
				}
				
				id_arr = id.split("field_id")
				
				if (id.indexOf("field_id") != -1 && id.indexOf("field_id____") == -1 && id_arr[1].length != 0){
					
					send(id)
				}
				
			}else if (type == "append"){
				
				prependInnerHTML(id, new_value)
				
			}
		}else{
			
			appendMessageBox('WARNING:' + id + ' undefined')
			
		}
		if (attach == true){
			
			attachJQuery();
			
			//Centers dialogs after ajax content load && sets max width screen size
			if ($("#"+id).hasClass('ui-dialog-content')) {
				
				if ($("#"+id).parent().width()>1200){
					
					$("#"+id).dialog("option", "width", 1200);
					
				}else{
					
					$("#"+id).dialog("option", "width", "auto");
					
				}
				
				$("#"+id).dialog("option", "position", ["center",dialog_Ypos()]);
			}
			
		}
	}
	
	for (evalArr_i in evalArr){
		
		feval = evalArr[evalArr_i].split("<eval_script>")[1].split("</eval_script>")[0]
		eval(feval);
		
	}
	
}

//Returns the keys of a hash as an array
function getHashKeys(object){
	
	var keys = new Array;
	
	for(var k in object){
		
		keys.push(k);
		
	}
	
	if (keys.length >= 1){
		
		return keys;
	
	}else{
		
		return false;
	
	}
}

function handle_upload(iframe, form_id){
	
	var innerHTML = iframe.contentWindow.document.body.innerHTML
	
	if (innerHTML != ""){
		
		if ($("#upload_status").length > 0){
			
			document.getElementById("upload_status").innerHTML = innerHTML
			
		}else{
			
			document.getElementById(form_id).innerHTML = innerHTML
			
		}
		
		//clear form fields on success
		if (innerHTML.match(/<success>/)){
			
			$("#"+form_id).find("[type=text],[type=textarea],[type=checkbox],[type=select],[type=file],[type=radio]").each(function(){
				
				this.value = ""
			});
		}
		
	}else{
		
		$("#upload_status").html("Response Error?")
		
	}
	
	$(".ui-dialog-buttonset").show();
}

function postString(post_params){
	
	var user 	= document.getElementById("user_id"	).value;
	var school_year = document.getElementById("school_year"	).value;
	var page 	= document.getElementById("page"	).value;
	
	valis(page);
	
	post_string = "user_id=" + user + "&page=" + page + "&school_year=" + school_year
	
	if ( $("#student_page_view_container").length == 1 ){
		
		post_string = post_string + "&" + "student_page_view=" + $("#student_page_view").attr("value");
		
	};
	
	post_params_array = post_params.split(",");
	post_params_array.push("student_id");
	for (param_i in post_params_array){
		var param = post_params_array[param_i]
		if ($("#"+param).length >= 1){
			
			if (param == "student_page_view"){
				
				post_string = post_string + "&" + "sid=" + document.getElementById("student_id").value;
				
			};
			
			var name  			= document.getElementById(param).name;
			var value 			= document.getElementById(param).value;
			var param_string 		= name + '=' + value.replace(/&/g,'and').replace(/;/g, ':');
			post_string 			= post_string + '&' + param_string;
			
		}else{
			
			post_string 			= post_string + '&' + param;
			
		}
	}
	
	return post_string
}

//For asychronous file submission
function redirect_submit(form_id){
	
	if (form_id==undefined){
		
		return false;
	
	}
	
	var x = postString("")
	y = x.split("&")
	e = document.getElementById(form_id).innerHTML
	
	for (y_i in y){
		z = y[y_i]
		
		a = z.split("=")[0]
		b = z.split("=")[1]
		c = "<input type='hidden' id='" +a+ "' name='" +a+ "' value='" +b+ "'>"
		
		if(a == "student_page_view"){
			
			document.getElementById(form_id).innerHTML.substr(-7,c);
			
		}
		
	}
	
	$("#upload_status").dialog("open");
	$(".ui-dialog-buttonset").hide();
	$("#"+form_id).attr("target", "upload_iframe_"+form_id);
	$("#"+form_id).submit();
	
}

function select_student(params) {
	
	var unsaved = send_unsaved(false);
	
	if (unsaved){
		
		params = params+","+unsaved;
		
	}
	
	$("#search_dialog").dialog("close");
	
	send(params,"prep_tab('student')");

}

var wait = false

//Ajax send to server
function send(post_params, preCallback, callback){
	
	if (wait == true){
		
		setTimeout(function(){send(post_params, preCallback, callback)},200)
		
	}else{
		
		wait = true
		
		if (parent.document.getElementById('loading_box').innerHTML == ""){
			
			setActivitySpinner();
			
		}
		
		//updateMessageBox("");
		
		var data = postString(post_params)
		
		if (preCallback != undefined){
			
			eval(preCallback)
			
		}
		
		$.ajax({
			
			type:     'POST',
			url:      '/cgi-bin/'+athena+'.rb',
			dataType: 'html',
			data:      data,
			timeout:   120000,
			success: function(data){
				
				clearSpinner();
				
				extractContent(data);
				
				if (callback != undefined){
					
					eval(callback)
					
				}
				
				wait = false
				
			},
			error: function(jqXHR, textStatus, errorThrown){
				
				var alert_message = "<img src='/athena/images/dialog_error.png' style='display:block; margin-left:auto; margin-right:auto; padding:10px'/>"
				
				if(textStatus == "error" && errorThrown == ""){
					
					alert_message += "You don't appear to be connected to the internet at this moment<br>Please check your internet connection for any connectivity issues.<br>It is reccommended that you refresh this page, and check for any unsaved work due to a disconnection."
					
				}else if(textStatus == "error" && errorThrown == "Internal Server Error") {
					
					alert_message += "Your request seems to have caused an unexpected error.<br>Don't worry, it's not your fault, but if you were just making changes, they may not have saved correctly.<br>Please refresh this page, and try again in a few minutes.<br>If this error persists, please notify the system administrators using the link provided below, so the error may be corrected as soon as possible."
					
				}else if(textStatus == "timeout"){
					
					alert_message += "Your request timed out<br>This happens if you become disconnected from the internet while your computer is waiting for information from Athena.<br>You may be disconnected from the internet, or are receiving an unrelaible wirelss signal.<br>It is reccommended that you check your internet connection, refresh this page, and check for any unsaved work due to a disconnection."
					
				}else{
					
					alert_message += "Unknown Error Type.<br>Please report this using the button below so it may be known."
					
				}
				
				warning_dialog(alert_message, textStatus, errorThrown)
				clearSpinner();
				setErrorBorder(post_params);
				wait = false
				
			}
			
		});
		
	}
	
}

//Jquery UI Elements------------------------------------------------------------
function x___________________JQUERY_UI_ELEMENTS(){}
//------------------------------------------------------------------------------
$(function () {
	
	var body = $("body")
	
	var unique_date     = $(".datepick").length
	
	//Date Picker
	body.delegate(".datepick:not(.hasDatepicker)", "focus", function(){
		this.id = "date_"+unique_date
		unique_date += 1
		var min = $(this).attr("min")
		var max = $(this).attr("max")
		var thrower = $(this).attr("catch_from")
		var catcher = $(this).attr("throw_to")
		$(this).datepicker({
			showButtonPanel: true,
			beforeShow: function( input ) {
				setTimeout(function() {
					var buttonPane = $( input )
						.datepicker( "widget" )
						.find( ".ui-datepicker-buttonpane" );
					$( "<button>", {
						text: "Clear",
						click: function() {
							$.datepicker._clearDate( input );
						}
					}).appendTo( buttonPane )
					  .addClass('ui-state-default')
					  .addClass('ui-corner-all');
				}, 1 );
			},
			minDate: min,
			maxDate: max,
			dateFormat: 'mm/dd/yy',
			defaultDate: $("[throw_to='"+thrower+"']").val(),
			onSelect: function() {
				$(this).trigger('datechange')
				$("[catch_from='"+catcher+"']").datepicker( "option", "defaultDate", $(this).val() );
			}
		});
	});
	
	var unique_datetime = $(".datetimepick").length
	
	//Date Time Picker
	body.delegate(".datetimepick:not(.hasDatepicker)", "focus", function(){
		this.id = "datetime_"+unique_datetime
		unique_datetime += 1
		var min = $(this).attr("min")
		var max = $(this).attr("max")
		$(this).datetimepicker({
			dateFormat: 'mm/dd/yy',
			timeFormat: 'hh:mm:ss TT',
			pickerTimeFormat: 'hh:mm:ss TT',
			minDate: min,
			maxDate: max,
			//stepMinute: 5,
			onSelect: function() {
				$(this).trigger('datechange')
			}
		});
	});
	
	$("#student_search_dialog_button").button({
		
		icons: {secondary: "ui-icon-search"}
		
	}).bind("click", function() {
		
		$("#student_search_dialog").dialog("open");
		
	});
	
	$("#student_search_dialog").dialog({
		
		autoOpen	: false,
		draggable	: false,
		resizable	: false,
		closeOnEscape	: false,
		modal		: true,
		width		: 400,
		position	: "top",
		title		: "Search",
		open		: function(event, ui) {
			
			$("div[ariaLabelledBy='ui-dialog-title-student_search_dialog']", ui.dialog).show();
			
		}
	});
	
	$( "#student_search_button" ).button({
		
		icons		: {secondary: "ui-icon-search"},
		text		: true,
		label		: "Search"
		
	}).bind("click", function() {
		
		$("#student_search_results").html("Retrieving Search Results..." + spinner());
		
	})
	
	$(":input[class^='search__STUDENT']").bind("keyup", function(e){
		
		if (e.which == 13){
			
			$("#student_search_button").click();
			
		}
	});
	
	$("#team_search_button").button({
		
		icons		: {secondary: "ui-icon-search"},
		text		: true,
		label		: "Search"
		
	}).bind("click", function() {
		
		$("#team_search_results").html("Retrieving Search Results..." + spinner());
		
	})
	
	$(":input[class^='search__TEAM']").bind("keyup", function(e){
		
		if (e.which == 13){
			
			$("#team_search_button").click();
			
		}
	});
	
	$("#team_search_dialog_button").button({
		
		icons		: {secondary: "ui-icon-search"}
		
	}).bind("click", function() {
		
		$("#team_search_dialog").dialog("open");
		
	});
	
	$("#team_search_dialog").dialog({
		
		autoOpen	: false,
		draggable	: false,
		resizable	: false,
		closeOnEscape	: false,
		modal		: true,
		width		: 400,
		position	: "top",
		title		: "Search",
		open		: function(event, ui) {
			
			$("div[ariaLabelledBy='ui-dialog-title-student_search_dialog']", ui.dialog).show();
			
		}
		
	});

});

//Data Tables-------------------------------------------------------------------
function x___________________DATA_TABLES(){}
//------------------------------------------------------------------------------

//Gets the correct return export value for a given data cell in DataTables
function dataTablesExportCell( sValue, nTr ) {
	
	regexp1 = /[^<>]+(?=[<])/
	regexp2 = /id=\".+?(?=")/
	
	if (sValue.match(regexp2)){
		
		id = "#" + String(sValue.match(regexp2)).replace("id=\"","")
		
		if ($(id,nTr).is("select")){
			
			return $(id + " :selected",nTr).text()
			
		}else if($(id,nTr).is(":checkbox")){
			
			if ($(id,nTr).attr("value")=="1"){
				
				return "Yes"
			
			}else{
				
				return "No"
			
			}
			
		}else{
			
			return $(id,nTr).attr("value")
			
		}
		
	}else if (sValue.match(regexp1)!="\n" && sValue.match(regexp1)!=null){
		
		return String(sValue.match(regexp1))
		
	}else{
		
		return sValue
		
	}
	
}

function set_aoColumn_sort(table){
	
	var aoColumn_array = [];
	
	row = $("tr",table).eq(1)
	
	var regexp   = /id=\".+?(?=")/
	
	var grade_regexp = /^\d{1,2}[thsndr]{2} Grade$/
	
	var tds = row.children('td')
	
	if (tds.length != 0){
		
		tds.each(function(){
			
			var sValue = $(this).html()
			
			if (sValue.match(regexp)){
				
				var id = "#" + String(sValue.match(regexp)).replace("id=\"","")
				
				var node = $(id,row)
				
				if(node.is("input:checkbox")){
					
					aoColumn_array.push({ "sSortDataType": "dom-checkbox" })
					
				}else if (node.is("input:not(.datepick,.datetimepick)")){
					
					aoColumn_array.push({ "sSortDataType": "dom-text" })
					
					//if (node.val().match(/^\d*$/)){
					//	
					//	aoColumn_array.push({ "sSortDataType": "dom-text_int", "sType": "numeric" })
					//	
					//}else{
					//	
					//	aoColumn_array.push({ "sSortDataType": "dom-text" })
					//	
					//}
					
				}else if(node.is("input.datepick")){
					
					aoColumn_array.push({ "sSortDataType": "dom-text", "sType": "date-us" })
					
				}else if(node.is("input.datetimepick")){
					
					aoColumn_array.push({ "sSortDataType": "dom-text", "sType": "datetime-us" })
					
				}else if (node.is("textarea")){
					
					aoColumn_array.push({ "sSortDataType": "dom-textarea" })
					
				}else if(node.is("select")){
					
					aoColumn_array.push({ "sSortDataType": "dom-select" })
					
				}else{
					
					aoColumn_array.push(null)
					
				}
				
			}else{
				
				if (sValue.match(grade_regexp)){
					
					aoColumn_array.push({ "sSortDataType": "dom-grade", "sType": "numeric" })
					
				}else{
					
					aoColumn_array.push(null)
					
				}
				
			}
			
		})
	
	}else{
		
		header_row = $("tr",table).eq(0)
		x = $('th', header_row).length
		
		while (x--){
			
			aoColumn_array.push(null)
			
		}
		
	}
	
	return aoColumn_array
	
}

//Default DataTables Options
var defaults = {
	
	'sDom'			: 'T<\"clear\">lfrtip',
	"sScrollX"		: "100%",
	'aLengthMenu'		: [[10, 25, 50, -1], [10, 25, 50, "All"]],
	"fnPreDrawCallback"	: function( oSettings ) {
		send_unsaved()
	},
	'oTableTools'		: {
		'sSwfPath'	: '/athena/javaScript/data_tables/extras/TableTools/media/swf/copy_csv_xls.swf',
		'mColumns'	: "all",
		'aButtons'	:[
			{
				"sExtends":"csv",
				"fnCellRender": function ( sValue, iColumn, nTr, iDataIndex ){
					return dataTablesExportCell(sValue, nTr)
				}
			}
		]
	}
}

//"sSortDataType": "dom-text"
$.fn.dataTableExt.afnSortData['dom-text'] = function  ( oSettings, iColumn ){
	
	var aData = [];
	
	$(oSettings.oApi._fnGetTrNodes(oSettings)).each( function () {
		
		var val = $('input', $(this).children('td').eq(iColumn)).val()
		
		if (val==""){
			
			aData.push("zzzzzzzzzz")
			
		}else{
			
			aData.push( val );
			
		}
		
	});
	
	return aData;

}

//"sSortDataType": "dom-text_int"
$.fn.dataTableExt.afnSortData['dom-text_int'] = function  ( oSettings, iColumn ){
	
	var aData = [];
	
	$(oSettings.oApi._fnGetTrNodes(oSettings)).each( function () {
		
		var val = $('input', $(this).children('td').eq(iColumn)).val()
		
		if (val==""){
			
			aData.push(0)
			
		}else{
			
			aData.push( parseInt(val) );
			
		}
		
	});
	
	return aData;

}

//"sSortDataType": "dom-textarea"
$.fn.dataTableExt.afnSortData['dom-textarea'] = function  ( oSettings, iColumn ){
	
	var aData = [];
	
	$(oSettings.oApi._fnGetTrNodes(oSettings)).each( function () {
		
		var val = $('textarea', $(this).children('td').eq(iColumn)).val()
		
		if (val==""){
			
			aData.push("zzzzzzzzzz")
			
		}else{
			
			aData.push( val );
			
		}
		
	});
	
	return aData;

}

//"sSortDataType": "dom-select"
$.fn.dataTableExt.afnSortData['dom-select'] = function  ( oSettings, iColumn ){
	
	var aData = [];
	
	$(oSettings.oApi._fnGetTrNodes(oSettings)).each( function () {
		
		var val = $('select option:selected', $(this).children('td').eq(iColumn)).text()
		
		if (val==""){
			
			aData.push("zzzzzzzzzz")
			
		}else{
			
			aData.push( val );
			
		}
		
	});
	
	return aData;

}

//"sSortDataType": "dom-checkbox"
$.fn.dataTableExt.afnSortData['dom-checkbox'] = function  ( oSettings, iColumn ){
	
	var aData = [];
	
	$(oSettings.oApi._fnGetTrNodes(oSettings)).each( function () {
		
		aData.push($('input', $(this).children('td').eq(iColumn)).prop('checked')==true ? "1" : "0")
		
	});
	
	return aData;

}

//"sSortDataType": "dom-grade"
$.fn.dataTableExt.afnSortData['dom-grade'] = function  ( oSettings, iColumn ){
	
	var aData = [];
	
	$(oSettings.oApi._fnGetTrNodes(oSettings)).each( function () {
		
		var val = $(this).children('td').eq(iColumn).html().match(/^[\d|K]{1,2}/)
		
		if (val==undefined){
			
			aData.push(0)
			
		}else if(val=="K"){
			
			aData.push( 0.5 );
			
		}else{
			
			aData.push( parseInt(val) );
			
		}
		
	});
	
	return aData;

}

//"sType": "date-us" (mm/dd/yyyy)
$.extend( jQuery.fn.dataTableExt.oSort, {
	
	"date-us-pre": function ( a ) {
		
		var usDatea = a.split('/');
		
		if (usDatea == false || usDatea == "zzzzzzzzzz"){
			
			return 0;
			
		}else{
			
			return (usDatea[2] + usDatea[0] + usDatea[1]) * 1;
			
		}
		
	},

	"date-us-asc": function ( a, b ) {
		return ((a < b) ? -1 : ((a > b) ? 1 : 0));
	},
	
	"date-us-desc": function ( a, b ) {
		return ((a < b) ? 1 : ((a > b) ? -1 : 0));
	}
    
});

//"sType": "datetime-us" (mm/dd/yyyy hh:mm:ss TT )
$.extend( jQuery.fn.dataTableExt.oSort, {
	
	"datetime-us-pre": function ( a ) {
		
		var usDateTime = a.split(' ');
		
		if (usDateTime == false || usDateTime == "zzzzzzzzzz"){
			
			return 0;
			
		}else{
			
			var usDate = usDateTime[0].split("/")
			
			var date = (usDate[2] + usDate[0] + usDate[1]) * 1000000
			
			var ampm;
			
			if (usDateTime[3]=="AM"){
				
				ampm = 0;
				
			}else{
				
				ampm = 120000;
				
			}
			
			var hhmmss = usDateTime[1].split(":")
			
			if (hhmmss[0] == "12"){
				
				hhmmss[0] = "00"
				
			}
			
			var time = hhmmss.join("") * 1 + ampm
			
			return date+time
			
		}
		
	},

	"datetime-us-asc": function ( a, b ) {
		return ((a < b) ? -1 : ((a > b) ? 1 : 0));
	},
	
	"datetime-us-desc": function ( a, b ) {
		return ((a < b) ? 1 : ((a > b) ? -1 : 0));
	}
    
});

//Auto Saving-------------------------------------------------------------------
function x___________________AUTO_SAVING(){}
//------------------------------------------------------------------------------

var focusedElementId 	= [];
var pleaseSaveIds 	= []
var saveElements 	= ["text", "textarea", "checkbox", "select", "radio"] //array of element types: "type="
var saveExceptions 	= [//multidimensional array of ["attribute", "value"]
		      ["name",     "^=", "field_id____"],
		      ["name",     "^=", "search__"],
		      ["disabled", "^=", "disabled"],
		      ["class",    "~=", "no_save"]
]

window.setInterval(saveTimer, 2000);

function saveTimer(){
	
	if (pleaseSaveIds.length > 0){
		
		send(pleaseSaveIds.join())
		pleaseSaveIds = []
		
	}
	
}

function saveSelector(element_names){
	
	var output = ""
	i=1
	
	for (element_i in element_names){
		
		var element = element_names[element_i]
		output = output + "[type=" + element + ']:not('
		j=1
		
		for (exception_i in saveExceptions){
			
			var exception = saveExceptions[exception_i]
			output = output + "[" + exception[0] + exception[1] + "'" + exception[2] + "']"
			
			if (j!=saveExceptions.length){
				
					output = output + ","
					
			}
			
			j++
			
		}
		
		output = output + ")"
		
		if (i!=element_names.length){
			
				output = output + ","
				
		}
		
		i++
	}
	
	return output

}

function send_unsaved(send_trigger){
	
	if (send_trigger == undefined){
		
		send_bool = true
		
	}else{
		
		send_bool = false
		
	}
	
	var saveIds    	 = pleaseSaveIds.join()
	focusedElementId = [];
	pleaseSaveIds    = [];
	
	if (send_bool==true && saveIds != ""){
		wait = false;
		send(saveIds)
		
	}else if (send_bool==false && saveIds != ""){
		
		return saveIds
		
	}else{
		
		return false
		
	}
	
}

$(function () {
	
	var body = $("body")
	
	body.delegate(saveSelector(saveElements), "focus", function(){
		
		$(this).unbind("blur change keyup datechange").bindWithDelay("blur change keyup datechange", function(event){
			
			var eventId	= event.currentTarget.id;
			
			if (focusedElementId.indexOf(eventId)!=-1) {
				
				if ($("#"+eventId).hasClass("validate") && $("#"+eventId).attr("value") == ""){
					
					alert("Please fill out all required fields.")
					
				}else{
					
					if (pleaseSaveIds.indexOf(eventId)==-1) {
						
						pleaseSaveIds.push(eventId)
						
					}
					
				}
				
				index = focusedElementId.indexOf(eventId)
				focusedElementId.splice(index,1);
				
			}
			
		},50).change(function(event){
			
			if (focusedElementId.indexOf(event.currentTarget.id)==-1 && !event.currentTarget.id.match("datetime")){
				
				focusedElementId.push(event.currentTarget.id)
				
			}
			
		}).keyup(function(event){
			
			if (focusedElementId.indexOf(event.currentTarget.id)==-1 && event.which != 9){
				
				focusedElementId.push(event.currentTarget.id)
				
			}
			
		}).bind("datechange", function(event){
			
			if (focusedElementId.indexOf(event.currentTarget.id)==-1){
				
				focusedElementId.push(event.currentTarget.id)
				
			}
			
		})
		
	})
	
})

//Jquery UI Dialogs-------------------------------------------------------------
function x___________________JQUERY_UI_DIALOGS(){}
//------------------------------------------------------------------------------
	
	function dialog_Ypos(){
		
		var yPos   = 0;
		var offset = 8;
		
		if ($("html", window.parent.document).scrollTop()>200){
			
			yPos = $("html", window.parent.document).scrollTop()-200;
			
		}
		
		return yPos + offset
		
	}
	
	function load_secure_doc(doc_id, direct, pdf_type){
		if (direct == true){
			
			send("doc_id_"+doc_id)
			
		}else{
			updateInnerHTML(
				
				"document_dialog",
				spinner() + "<input id='doc_id' name='doc_id' style='display:none;' value='" + doc_id + "'>"
				
			);
			
			$(function() {
				
				$( "#document_dialog" ).dialog({
					
					position	: ["center",dialog_Ypos()],
					resizable	: false,
					width		: 1125,
					height		: 1500,
					modal		: true,
					draggable	: false,
					open		: function(event, ui) {
						
						$(".ui-dialog-titlebar-close", ui.dialog).show();
						
					}
					
				});
				
			});
			
			send("doc_id,view_pdf_"+pdf_type)
		}
		
		return false;
		
	}
	
	function upload_doc(doc_name, params) {
		
		var buttons = Array
		
		$('#upload_new_doc_'+doc_name).dialog({
			
			title		:"Upload Document",
			position	: ["center",dialog_Ypos()],
			autoOpen	: false,
			draggable	: false,
			resizable	: false,
			closeOnEscape	: false,
			modal		: true,
			height		: "auto",
			width		: "auto",
			open		: function(event, ui) {
				
				$(this).dialog("option", "position", ["center",dialog_Ypos()]);
				$(".ui-dialog-titlebar-close", ui.dialog).hide();
				$(this).html(spinner);
				buttons = $(this).dialog( "option", "buttons" );
				
			},
			buttons		: {
				
				"Save": function() {
					
					var field_ids = "upload_new_doc_"+doc_name
					var break_save = false
					
					$(this).find("[type=text],[type=textarea],[type=checkbox],[type=select],[type=hidden],[type=file]").each(function(){
						
						if ($(this).hasClass("validate") && $(this).attr("value") == ""){
							
							alert("Please Complete Out All Fields")
							field_ids = ""
							break_save = true
							
						}
						if (!break_save){
							
							var field_id = $(this).attr("id")
							
							if(field_id != ""){
								
								if(field_ids == ""){
									
									field_ids = field_id
									
								}else{
									
									field_ids = field_ids + "," + field_id
									
								}
								
							}
							
							if ($(this).parent().is("div")){
								
								$(this).parent().hide()
								
							}
							
						}
						
					});
					
					if (!break_save){
						
						if (field_ids){
							
							redirect_submit("doc_upload_form")
							$("#doc_upload_form").append(spinner())
							send('sid,tid')
							
						}
						
						$('#upload_new_doc_'+doc_name).dialog( "option", "buttons", {
							
							OK: function() {
								
								$(this).dialog( "option", "buttons", buttons)
								$(this).dialog( "close" );
								
							}
							
						});
						
						$(".ui-dialog-buttonset").hide();
						$(".doc_upload").hide();
						
					}
					
				},
				Cancel: function() {
					
					$(this).html(spinner())
					$(this).dialog( "close" );
					
				}
				
			}
			
		});
		
		$('#upload_new_doc_'+doc_name).dialog("open");
		send(params);
		
	}
	
	function warning_dialog(message, textStatus, errorThrown) {
		
		$('#warning_dialog').dialog({
			
			title		:"Uh Oh...",
			position	: ["center",dialog_Ypos()],
			autoOpen	: false,
			draggable	: false,
			resizable	: false,
			closeOnEscape	: false,
			modal		: true,
			height		: "auto",
			width		: $("body").width()/2,
			show		: "fade",
			hide		: "fade",
			open		: function(event, ui) {
				
				$(this).dialog("option", "position", ["center",dialog_Ypos()]);
				$(".ui-dialog-titlebar-close", ui.dialog).hide();
				$(this).html(message);
				
			},
			buttons		: {
				
				"Report This Error": function() {
					
					$(this).html("")
					window.location.href = "mailto:jhalverson@agora.org;esaddler@agora.org?Subject=Athena Error Report&Body=Reporting Refererence ID: " + $("#student_page_view").attr("value") + " - " + errorThrown +":"+ textStatus + "%0D%0A%0D%0A" + "In the space below, please provide any additional information or steps to reproduce the problem:%0D%0A%0D%0A(Please be as detailed as possible, as this allows us to more quickly replicate, and correct the issue)" + "%0D%0A%0D%0A";
					$(this).dialog( "close" );
					
				},
				"Nah, I'm good": function() {
					
					$(this).html("")
					$(this).dialog( "close" );
					
				}
			}
		});
		
		$('#warning_dialog').dialog("open");
		
	}

//Unsorted-------------------------------------------------------------------
function x___________________UNSORTED(){}
//------------------------------------------------------------------------------

	// FNORD - When this is read into the ruby output change this explicit path to a $config reference
	function maintenance(){
		window.location = "http://athena-sis.com/athena/maintenance.html"
	}
	
	function confirmation_dialog_open(){
		$("#confirmation_dialog").dialog("open");
	}
	
	//Checks if file extension is allowable
	function ext_check(element, accepted_extensions){
		var ext = $(element).attr("value").split(".").pop().toLowerCase();
		accepted_extensions = accepted_extensions.split(",")
		if(accepted_extensions.indexOf(ext) < 0){
			var message = "Please select a file with the correct extension and try again."
			alert(message)
			$(element).attr("value", "")
			return
		}
	}
	
//------BEING USED------------------------------------------------------------//
	var kmail_keywords = [
		"|student.firstnameLastname|",
		"|student.firstname|",
		"|student.lastname|",
		"|student.genderString|",
		"|student.hisHerTheirString|",
		"|student.heSheTheyString|",
		"|student.phoneFormatted|",
		"|student.birthday|",
		"|student.attendanceInLastThirtyDaysMinutes|",
		"|student.attendanceInLastThirtyDaysHours|",
		"|student.id|",
		"|student.preferredOrFirstname|",
		"|daysSinceLastLogin|",
		"|lastLoginDate|",
		"|hoursOfAttendanceYtd|",
		"|firstDateRequiringLogin|",
		"|learningCoach.firstnameLastname|",
		"|learningCoach.cellPhoneFormatted|",
		"|learningCoach.workPhoneFormatted|",
		"|school.name|",
		"|school.abbreviation|",
		"|school.phoneFormatted|"
	]

	//Attaches all JQuery objects
	function attachJQuery(){
		
		$(".new_row").click(function(event){
				event.stopPropagation();
			});
		$(function () {
			
			window.onbeforeunload = function() {
				if (pleaseSaveIds.length > 0) {
					return "You may lose some unsaved changes...";
				};
			};
			
			$(".get_link:not(.ui-button)").button({
				label:"Request File",
				icons: {primary: "ui-icon-arrowthickstop-1-e"}
			}).unbind("click").bind("click", function() {
				$(this).button( "option", "disabled", true );
				$(this).fadeOut(200, function() {
					$(this).button( "option", "label", "Aquiring..." );
					$(this).button( "option", "icons", {primary: "ui-icon-arrowthickstop-1-s"});
					$(this).fadeIn(200);
				});
			})
			
			$(".link:not(.ui-button)").button({
				label:"Aquiring...",
				icons: {primary: "ui-icon-arrowthickstop-1-s"},
				disabled: true
			}).fadeOut(250, function(){
				$(this).button( "option", "label", "DOWNLOAD" );
				$(this).button( "option", "icons", {primary: "ui-icon-disk"});
				$(this).fadeIn(300, function(){
					$(this).button( "option", "disabled", false );
				})
			})
			
			$("#file_viewer:not(.ui-accordion)").accordion({
				active:      false,
				collapsible: true,
				autoHeight:  false,
				heightStyle: "content",
				icons:       { "header": "defaultIcon", "headerSelected": "selectedIcon" },
				change: function(event, ui){
					var clicked = $(this).find('.ui-accordion-content-active').attr('id');
					if (clicked != undefined){
						$("#"+clicked).html(spinner())
						$("#accordion_doctype").val(clicked)
						send('accordion_doctype,accordion_category_id')
					}
				},
				changestart: function(event, ui){
					var clicked = $(this).find('.ui-accordion-content-active').attr('id');
					if (clicked != undefined){
						$("#"+clicked).html("")
					}
				}
			})
			
			$( "#retract_withdraw" ).dialog({
				autoOpen: false,
				resizable: false,
				height:200,
				modal: true
			});
			$( ".disabled_button" ).button({
				disabled:true
			});
			$(".retract_button").button().unbind("click").bind("click", function() {
				var send_id = $(this).attr("id").split("__").slice(0,-1).toString().replace(/,/g, "__")
				var pid = $(this).attr("id").split("__")[1]
				
				$("#retract_withdraw").dialog( "option", "buttons", {
					"Retract Withdraw Request": function(){
						$('#'+send_id).attr('value', '1');
						send("sid," + send_id);
						$( "#" + send_id + "__button" ).button( "option", "disabled", true );
						$('#withdrawalARGV'+pid).trigger('click');
						$( this ).dialog( "close" );
					},
					Cancel: function(){
						$( this ).dialog( "close" );
					}
				});
				$("#retract_withdraw").dialog("option", "position", ["center",dialog_Ypos()]);
				$("#retract_withdraw").dialog("open");
			});
			$( "#rescind_withdraw" ).dialog({
				autoOpen: false,
				resizable: false,
				height:200,
				modal: true
			});
			$(".rescind_button").button().unbind("click").bind("click", function() {
				var send_id = $(this).attr("id").split("__").slice(0,-1).toString().replace(/,/g, "__")
				var pid = $(this).attr("id").split("__")[1]
				
				$("#rescind_withdraw").dialog( "option", "buttons", {
					"Rescind Withdraw Request": function(){
						$('#'+send_id).attr('value', '1');
						send("sid," + send_id);
						$( "#" + send_id + "__button" ).button( "option", "disabled", true );
						$('#withdrawalARGV'+pid).trigger('click');
						$( this ).dialog( "close" );
					},
					Cancel: function(){
						$( this ).dialog( "close" );
					}
				});
				$("#rescind_withdraw").dialog("option", "position", ["center",dialog_Ypos()]);
				$("#rescind_withdraw").dialog("open");
			});
			
			$("#upload_status").dialog({
				autoOpen: false,
				draggable: false,
				resizable: false,
				closeOnEscape: false,
				modal: true,
				height: 250,
				width: $("body").width(),
				position: "top",
				open: function(event, ui) {
					$(".ui-dialog-titlebar-close", ui.dialog).hide();
					$(this).html("<div>Please Wait While Your Request Is Processed</div>" + spinner())
				},
				buttons: {
					OK: function() {
						$(this).dialog( "close" );
					}
				}
			});
			$("#confirmation_dialog").dialog({
				autoOpen: false,
				draggable: false,
				resizable: false,
				closeOnEscape: false,
				modal: true,
				height: 500,
				width: $("body").width(),
				position: "top",
				open: function(event, ui) {
					$(".ui-dialog-titlebar-close", ui.dialog).hide();
					$(this).html("<div>Generating Sample...</div>" + spinner())
					$(this).dialog( "option", "buttons", {
						YES: function() {
							$(this).html("<div>OK...</div>" + spinner());
							send("test_event_site_id,kmail_body,kmail_subject")
							$("#confirmation_dialog").dialog( "option", "buttons", {
								OK: function() {
									$(this).dialog( "close" );
								}
							});
						},
						NO: function() {
							$(this).dialog( "close" );
						}
					});
				}
			});
			$( ":button" ).button();
			$(".expansion_header").each(function(){
				var id = $(this).attr("id");
				if ($("#content_div_expand_" + id).hasClass("expanded") && $("#content_div_expand_" + id).height()!=0 && $("#content_div_expand_" + id).html()!=spinner && !$(this).hasClass("content_loaded")){
					$(this).addClass("content_loaded")
					$("#content_div_expand_" + id).animate({
						height:$("#content_div_expand_" + id).children().outerHeight(true)
					},
					500,
					function(){
						$("#content_div_expand_" + id).css('height', 'auto');
					});
				}
				if(!$(this).hasClass("click_binded")){
					$(this).addClass("click_binded")
					$(this).toggle(
						function() {
							$("#content_div_expand_" + id).html(spinner)
							$("#content_div_expand_" + id).addClass("expanded")
							$(this).animate({
								color:"#FFF",
								backgroundColor:"#3baae3"
							});
							var el 		= $("#content_div_expand_" + id),
							curHeight 	= el.height(),
							autoHeight 	= el.css('height', 'auto').height();
							el.height(curHeight).animate(
								{height: autoHeight, backgrounfColor:"#f2f5f7"},
								500,
								function(){ send("expand_"+id) }
							);
						},
						function() {
							send_unsaved();
							$("#content_div_expand_" + id).removeClass("expanded")
							$(this).removeClass("content_loaded")
							$(this).animate(
								{color:"#2779aa",backgroundColor:"#d7ebf9"}
							);
							$( "#content_div_expand_" + id ).animate(
								{height: 0},
								500,
								function(){
									$("#content_div_expand_" + id).html("");
								}
							);
						}
					);
				}
			})
			
			$("#new_pdf").dialog({
				title		: "New PDF",
				position	: "top",
				autoOpen	: false,
				draggable	: false,
				resizable	: false,
				closeOnEscape	: false,
				modal		: true,
				height		: "auto",
				width		: $("body").width(),
				open		: function(event, ui) {
					$(".ui-dialog-titlebar-close", ui.dialog).hide();
					$(this).html(spinner)
				},
				buttons		: {
					"Save Record": function() {
						var field_ids = ""
						if (validate($(this))){
							$(this).find("[type=text],[type=textarea],[type=checkbox],[type=select],[type=hidden],[type=radio]:checked").each(function(){
								var field_id = $(this).attr("id")
								if(field_id != ""){
									if(field_ids == ""){
										field_ids = field_id
									}else{
										field_ids = field_ids + "," + field_id
									}
								}
							});
							if (field_ids){
								send("student_id," + field_ids)
								$(this).html(spinner())
								$(this).dialog( "close" );
							}
						}else{
							alert("Please Fill Out All Required Fields")
						}
					},
					Cancel: function() {
						$(this).html(spinner())
						$(this).dialog( "close" );
					}
				}
			});
			$('.kmail_validate_content[type=textarea],[type=text]').unbind("change").bind("change", function(){
				var text_value = $(this).attr("value")
				var original_val = text_value
				text_value = replaceWordChars(text_value)
				text_value = text_value.replace(/\t/g, '     ');
				if (original_val != text_value){
					$(this).attr("value", text_value)
					alert("Illegal Characters Found. (Most likely because of pasting from Microsoft Word)\nThey have been replaced by the appropriate cognate.\nPlease check to make sure the content looks as intended.")
				}
				if (text_value.match(/\|.*?\|/g)){
					var invalid_keys = new String
					var keywords = text_value.match(/\|.*?\|/g)
					for (var keyword_i in keywords){
						var keyword = keywords[keyword_i]
						if (kmail_keywords.indexOf(keyword)==-1){
							if (invalid_keys == ""){
								invalid_keys = keyword
							}else{
								invalid_keys = invalid_keys + ", " + keyword
							}
						}
					}
					if (invalid_keys!=""){
						alert("The following keywords are not valid: \"" + invalid_keys + "\".  Please refer to the legend for the correct spelling.")
					}
				}
			})
			
			$('table.dataTableNewRecord:not(.dataTable)').each( function(){
				$(this).dataTable( $.extend( true, {}, defaults,
					{
						"sDom"			: '<"top">rt<"bottom"><"clear">',
						"fnPreDrawCallback"	: function( oSettings ) {}
					}
				));
			});
			
			$('table.dataTableDefault:not(.dataTable)').each( function(){
				$(this).dataTable( $.extend( true, {}, defaults,
					{
						"aoColumns"		: set_aoColumn_sort(this)
					}
				));
			});
			
			var select_index = $('#tabs').tabs('option', 'selected')+1
			var oTable = $('div.dataTables_scrollBody>table.dataTable', $('#tabs-'+select_index)).dataTable();
			if ( oTable.length > 0 ) {
				oTable.fnAdjustColumnSizing();
			}
			
			$(".js_error").hide();  //ALWAYS LAST SO THERE IS A MESSAGE IF THERE IS A JS ERROR.
			
		});
	}
	
	function send_covered(post_params){
		
		var load_img = '<img style=\"display:block; height:'+screen.height+'px; width:'+screen.width+'px; border:none;\" src=\"/athena/images/trans.gif\"/>'
		var box = parent.document.getElementById('loading_cover');
		box.innerHTML 		= load_img;
		
		var unsaved = send_unsaved(false);
		if (unsaved){
			post_params = post_params+","+unsaved;
		}
		
		send(post_params);
		
	}
	
	function clear_student_record_content(){
		
		$("#student_record_title").html("Loading...")
		$("#student_record_content").html(spinner())
		
	}
	
	function clear_team_record_content(){
		
		$("#team_member_record_title").html("Loading...")
		$("#team_member_record_content").html(spinner())
		
	}
	
	//Called by inital html to set and load the correct page
	function set_page(){
		document.getElementById('user_id').value = parent.document.getElementById('user_form').user_id.value;
		document.getElementById('page').value = parent.document.getElementById('user_form').page.value;
		if (parent.document.getElementById('user_form').dashboard_options != undefined){
			document.getElementById('dashboard_options').value = parent.document.getElementById('user_form').dashboard_options.value;
		}
		ref_test = document.referrer;
		document.forms.get_page.submit();
	}
	

	
//------Private---------------------------------------------------------------//
	
	function student_doc_dialog(URL,title){
		updateInnerHTML(
			"document_dialog",
			"<div id='student_doc' title='"+title+"'><object width='1100' height='1415' data='"+URL+"'></object></div>"
		);
		$(function() {
			$( "#document_dialog" ).dialog(
				{
					position	: ["center",dialog_Ypos()],
					resizable	: false,
					minWidth	: 1125,
					minHeight	: 1440,
					modal		: true,
					draggable	: false
				}
			);
		});
		return false;
	}
	
	function get_new_breakaway(a) {
		
		var data 	= postString(a)
		var height	= screen.height
		var width	= screen.width
		var specs 	= "height="+height+",width="+width+",location=0,scrollbars=yes"
		window.open(
			'/cgi-bin/'+athena+'.rb?'+data,
			''
		);
		
	};
	
	function get_how_to(params, how_to_title) {
		
		$('#how_to_dialog').dialog({
			
			position	: ["center",dialog_Ypos()],
			title		: how_to_title,
			autoOpen	: false,
			draggable	: false,
			resizable	: false,
			closeOnEscape	: true,
			modal		: true,
			height		: "auto",
			width		: $("body").width(),
			open		: function(event, ui) {
				$(this).html(spinner);
				$(this).css("height", "auto");
			},
			buttons		: {
				"Close": function() {
					$(this).html(spinner())
					$(this).dialog( "close" );
				}
			}
			
		});
		
		$('#how_to_dialog').dialog("open");
		send(params);
		
	};

	function get_new_row(params, table_name, save_params) {
		
		$('#add_new_dialog_'+table_name).dialog({
			title		:"Add New Record",
			position	: ["center",dialog_Ypos()],
			autoOpen	: false,
			draggable	: false,
			resizable	: false,
			closeOnEscape	: false,
			modal		: true,
			height		: "auto",
			width		: "auto",
			open		: function(event, ui) {
				$(this).dialog("option", "position", ["center",dialog_Ypos()]);
				$(".ui-dialog-titlebar-close", ui.dialog).hide();
				$(this).html(spinner);
				$(this).css("height", "auto");
			},
			buttons		:[
				{
					id	: "commit_save",
					text	: "Save Record",
					click	: function() {
						var field_ids = "add_new_"+table_name
						if (save_params != undefined){
							field_ids = field_ids+","+save_params
						}
						if (validate($(this))){
							$(this).find("[type=text],[type=textarea],[type=checkbox],[type=select],[type=hidden],[type=radio]:checked").each(function(){
								var field_id = $(this).attr("id")
								if(field_id != ""){
									if(field_ids == ""){
										field_ids = field_id
									}else{
										field_ids = field_ids + "," + field_id
									}
								}
							});
							if (field_ids){
								send("student_id,sid," + field_ids)
								$(this).html(spinner())
								$(this).dialog( "close" );
								$(window).scrollTop(0);
							}
						}else{
							alert("Please Fill Out All Required Fields")
						}
					}
				},
				{
					id	: "cancel_save",
					text	: "Cancel",
					click	: function() {
						$(this).html(spinner())
						$(this).dialog( "close" );
					}
				}
			]
		});
		
		$('#add_new_dialog_'+table_name).dialog("open");
		send(params);
	};
	
	function get_row(params, table_name, dialog_title) {
		
		$('#get_row_dialog').dialog({
			position	: ["center",dialog_Ypos()],
			title		: dialog_title,
			autoOpen	: true,
			draggable	: true,
			resizable	: true,
			closeOnEscape	: false,
			modal		: true,
			height		: "auto",
			width		: "auto",
			open		: function(event, ui) {
				$(this).html(spinner);
			},
			buttons		: {
				"Save Record": function() {
					
					var field_ids = "add_new_"+table_name
					if (validate($(this))){
						
						$(this).find("[type=text],[type=textarea],[type=checkbox],[type=select],[type=hidden]").each(
							
							function(){
								field_ids = field_ids + "," + $(this).attr("id")
							}
							
						);
						
						if (field_ids){
							send(field_ids)
							$(this).dialog( "close" );
							$(window).scrollTop(0);
						}
						
					}else{
						alert("Please Fill Out All Required Fields")
					}
				},
				Cancel: function() {
					$(this).html(spinner())
					$(this).dialog( "close" );
				}
			}
		});
		
		$('#get_row_dialog_'+table_name).dialog("open");
		send(params);
	};
	function get_new_download(params) {
		var data 	= postString(params)
		var height	= 100
		var width	= 100
		var left 	= (screen.width/2	)-(width/2);
		var top 	= (screen.height/2	)-(height/2);
		var specs 	= "height="+height+",width="+width+",top="+top+",left="+left
		window.open(
			'/cgi-bin/'+athena+'.rb?'+data,
			'',
			specs
		);	
	};
	function select_team_member(params) {
		var unsaved = send_unsaved(false);
		if (unsaved != ""&& !unsaved){
			params = params+","+unsaved;
		}
		send(params,"prep_tab('team')");
	}
	function prep_tab(type){
		if (type == "student"){
			var student_tab = $("#student_tab").attr("value")
			selectTab(student_tab)
			$("#tabs-"+student_tab).html("Loading Student")	
		}else if (type == "team"){
			var team_member_tab = $("#team_member_tab").attr("value")
			selectTab(team_member_tab)
			$("#tabs-"+team_member_tab).html("Loading Team Member")
		}
	}
	/// Replaces commonly-used Windows 1252 encoded chars that do not exist in ASCII or ISO-8859-1 with ISO-8859-1 cognates.
	function replaceWordChars(text) {
		var s = text;
		// smart single quotes and apostrophe
		s = s.replace(/(\u2018|\u2019|\u201A)/g, "\'");
		// smart double quotes
		s = s.replace(/(\u201C|\u201D|\u201E)/g, "\"");
		// ellipsis
		s = s.replace(/\u2026/g, "...");
		// dashes
		s = s.replace(/(\u2013|\u2014)/g, "-");
		// circumflex
		s = s.replace(/\u02C6/g, "^");
		// open angle bracket
		s = s.replace(/\u2039/g, "<");
		// close angle bracket
		s = s.replace(/\u203A/g, ">");
		// spaces
		s = s.replace(/(\u02DC|\u00A0)/g, " ");
		// bullets
		s = s.replace(/\u2022/g, "*");
		return s;
	}
	function validate(container){
		var valid = true
		container.find("[type=text][class~=validate],[type=textarea][class~=validate],[type=checkbox][class~=validate],[type=select][class~=validate],[type=radio][class~=validate]").each(function(){
			if ($(this).attr("value") == ""){
				valid = false
				return false
			}
		});
		return valid
	}
	function get_set_ext(element){
		
		var ext	      = element.value.split(".").pop();
		document.getElementById('extension').value = ext
		
	}
	function fill_select_option(field_to_modify, element_obj, additional_params){
		
		field_name		= element_obj.id.split("__").pop();
		field_value 		= element_obj.value;
		
		if(additional_params != undefined){
			send_covered(additional_params+","+"fill_select_option_"+field_to_modify+"="+field_name+":"+field_value);
		}else{
			send_covered("fill_select_option_"+field_to_modify+"="+field_name+":"+field_value);
		}	
		
	}
	
	function load_tab(tab_number, arg) {
		send_unsaved();
		params = "load_tab_"+tab_number+"="+arg
		send(params)	
	};
	
	$(function() {
		
		function runEffect() {
			
			var selectedEffect = "slide"
			var options = {};
		 
			$( "#student_demographics" ).hide( selectedEffect, options, 1000, callback );
		  
		};
		
		// callback function to bring a hidden box back
		function callback() {
		  setTimeout(function() {
		    $( "#student_demographics" ).removeAttr( "style" ).hide().fadeIn();
		  }, 1000 );
		};
	     
		// set effect from select menu value
		$( "#button" ).click(function() {
		  runEffect();
		  return false;
		});
	});
	
	var _gaq = _gaq || [];
	_gaq.push(['_setAccount', 'UA-39558322-1']);
	_gaq.push(['_setDomainName', 'athena-sis.com']);
	_gaq.push(['_trackPageview']);
      
	(function() {
	  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
	  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
	  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
	})();

	function valis(gapgvw){_gaq.push(['_trackPageview', '/'+gapgvw]);}

	
//RECYCLE BIN^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^
function x___________________RECYCLE_BIN(){}
//^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^><^^><^><^><^>
//$(function () {
//	$(".days_slider").each(function(){
//		var ref_input = $(this).parent().find(":input.ATTENDANCE_REPORT_SCHEDULE__target_days")
//		var slide_text = $(this).parent().find(".days_slider_text")
//		var current_val = ref_input.val().split(",");
//		if(current_val.length == 1){
//			var values_array = [current_val[0],current_val[0]]
//		}else{
//			var values_array = [current_val[0],current_val[1]]
//		}
//		var text
//		if (values_array[1]==200){
//			text = values_array[0] + " or more days";
//		}else if (values_array[0]==values_array[1]){
//			text = values_array[0] + " days";
//		}else{
//			text = values_array[0] + " to " + values_array[1] + " days";
//		}
//		slide_text.text(text)
//		$(this).slider({
//			range: true,
//			min: 1,
//			max: 51,
//			values: values_array,
//			slide: function( event, ui ) {
//				if (ui.values[1] == 51){
//					ui.values[1] = 200
//					slide_text.text(ui.values[0] + " or more days")
//					ref_input.val(ui.values[ 0 ] + "," + ui.values[ 1 ]).change();
//				}else if (ui.values[0] == ui.values[1]){
//					text = ui.values[0]
//					slide_text.text(ui.values[0] + " days")
//					ref_input.val(ui.values[0]).change();
//				}else{
//					slide_text.text(ui.values[ 0 ] + " to " + ui.values[ 1 ] + " days")
//					ref_input.val(ui.values[ 0 ] + "," + ui.values[ 1 ]).change();
//				}
//			}
//		});
//	});
//	$( ".delete" ).button({
//		icons: {secondary: "ui-icon-close"},
//		text: false
//	}).unbind("click").bind("click", function() {
//		if($(this).hasClass("active")){
//			var table = $(this).attr("id").split("__")[0].toUpperCase()
//			var pid   = $(this).attr("id").split("__")[1]
//			var delete_field_id = "field_id__" + pid + "__" + table + "__deleted"
//			$("#" + delete_field_id).attr("value", "1")
//			send(delete_field_id)
//			$(this).parent().fadeOut(500);
//		}
//	});
//	$(".delete").mouseenter(function(){
//		$(this).button( "option", "disabled", false );
//		$(this).fadeOut(400, function() {
//			$(this).button( "option", "text", true )
//			$(this).fadeIn(1000, function(){
//				$(this).addClass("active");
//			});
//		});
//	}).mouseleave(function(){
//		$(this).removeClass("active");
//		$(this).fadeOut(250, function() {
//			$(this).button( "option", "text", false )
//			$(this).fadeIn(250);
//		});
//	});
//	$("#close_attendance").button().bind("click", function() {
//		send("date_1,date_2");
//	})
//})
//
//$(function () {
//	$('#jquery_file_tree').fileTree(
//	    {
//		root    : file_path,
//		script  : '/athena/javaScript/jqueryFileTree/jqueryFileTree.php'
//	    },
//	    function(file) {
//		alert(file);
//		location.href   = file;
//	    }
//	);
//
//};
