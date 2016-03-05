# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

delay = (ms, func) -> setTimeout func, ms

$ ->
  load_employee_list employee_list_div for employee_list_div in $('.loading_call_out_list')

$(document).on 'change', "[data-submit-on-change='true']", (event) =>
    $.rails.handleRemote($(event.target).closest('form'))

$(document).on 'filtering', '.loading_call_out_list', (event) =>
  delay 1000, -> load_employee_list event.currentTarget

$(document).on 'click', '[data-toggle]', (event) =>
  target_id = $(event.target).data('toggle')
  $("##{target_id}").toggle()

load_employee_list = (employee_list_div) ->
  employee_list_div = $(employee_list_div)
  #console.log(employee_list_div.data())
  list_id = employee_list_div.data("id")
  facility_id = employee_list_div.data("facilityId")
  call_out_shift_id = employee_list_div.data("callOutShiftId")
  get_employee_list(facility_id, call_out_shift_id, list_id)

get_employee_list = (facility_id, call_out_shift_id, list_id) ->
  $.ajax "/facilities/#{facility_id}/call_out_shifts/#{call_out_shift_id}/call_out_lists/#{list_id}",
    type: 'GET'
    error: (jqXHR, textStatus, errorThrown) ->
      #console.log(jqXHR.responseText)
      #console.log(errorThrown)
      $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      #console.log(data)
