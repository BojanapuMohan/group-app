// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.foundation
//= require foundation
//= require recurring_select
//= require_tree .

$(function() {
  $(document).foundation();
});

$(document).on('click', '[data-element-toggle]', function (event) {
  $("#"+$(this).data('element-toggle')).toggle()
  if($(this).data('element-toggle1')){
    $("#"+$(this).data('element-toggle1')).toggle()
  }
  return false;
})

$(document).ready( function() {
  $('#employees').dataTable({"iDisplayLength": 50});
  $('.shiftdate').fdatepicker();
} );

$(document).on('change', '#schedule_facility_id', function (event) {
  var selectedValue = $("#schedule_facility_id option:selected").val();
  window.location = "/schedules/"+selectedValue
});
$(document).on('change', '#shift_facility_id', function (event) {
  var selectedValue = $("#shift_facility_id option:selected").val();
  window.location = "/facilities/"+selectedValue+"/shifts"
});
$(document).on('click', '.week', function (event) {
  //alert("/schedules/"+selectedValue+"?"+$(this).attr('start_date')+"&"+$(this).attr('end_date'))
  var selectedValue = $("#schedule_facility_id option:selected").val();
  window.location = "/schedules/"+selectedValue+"?start_date="+$(this).attr('start_date')+"&end_date="+$(this).attr('end_date')
});

$(document).on('click', '[data-path]', function (event) {
  window.location = $(this).data('path')
})
