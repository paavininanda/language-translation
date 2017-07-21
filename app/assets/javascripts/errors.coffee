$(document).on "page:change", ->
	$('#close-error').click ->
		$('#ErrorBox').toggle()