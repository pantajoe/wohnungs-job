var getIncidentDateRange = function() {
  return $.map($('.incident-daterange input').val().split(' - '), function(date, i) {
    return moment(date, 'DD.MM.YYYY').format('YYYY-MM-DD');
  });
}

var reloadIncidents = function(filter) {
  var dateRange = getIncidentDateRange();
  $.ajax({
    type: 'GET',
    url: window.location.pathname,
    data: {
      from:   dateRange[0],
      to:     dateRange[1],
      filter: filter,
      format: 'js'
    }
  });
}

$(document).on('ready turbolinks:load', function() {
  if ($("#filter-incidents-type").length > 0) {
    $("#filter-incidents-type").change(function() {
      reloadIncidents($(this).val());
    });
  }
});
