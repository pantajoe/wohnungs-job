$(document).on('turbolinks:load', function() {
  if ($('.incident-daterange input').length > 0) {
    var start = getUrlParameter('from') || moment().startOf('month').toDate();
    var end   = getUrlParameter('to')   || moment().endOf('month').toDate();

    $('.incident-daterange input').datepicker({
      range: true,
      multipleDatesSeparator: ' - ',
      language: 'de'
    });

    var datepicker = $('.incident-daterange input').datepicker().data('datepicker');
    datepicker.selectDate(start);
    datepicker.selectDate(end);

    $('.incident-daterange input').datepicker({
      range: true,
      multipleDatesSeparator: ' - ',
      language: 'de',
      onSelect: function(formattedDate, dates) {
        if (dates.length < 2) return;
        else {
          $('.incident-daterange input').datepicker().data('datepicker').hide();

          var startDate = dates[0],
              endDate   = dates[1];

          $.ajax({
            type: 'GET',
            url: window.location.pathname,
            data: {
              from: moment(startDate).format('YYYY-MM-DD'),
              to: moment(endDate).format('YYYY-MM-DD'),
              filter: $("#filter-incidents-type").val(),
              format: 'js'
            }
          });
        }
      }
    });
  }

  if ($('#report-month.monthpicker').length > 0) {
    var startDate = moment(getUrlParameter('month')).toDate();

    var allowedMonths = gon.allowedMonths;
    var allowedYears = $.map(allowedMonths, function(date, i) {
      var splittedDate = date.split('-');
      splittedDate[1] = '01'
      return splittedDate.join('-');
    });
    allowedYears = allowedYears.filter((val, i, arr) => arr.indexOf(val) == i);

    $('#report-month.monthpicker').datepicker({
      startDate: startDate,
      language: 'de',
      minView: 'months',
      view: 'months',
      dateFormat: 'MM yyyy',
      onRenderCell: function(date, cellType) {
        if (cellType == 'year') {
          return {
            disabled: (allowedYears.indexOf(moment(date).format('YYYY-MM-DD')) == -1)
          }
        }
        else if (cellType == 'month') {
          return {
            disabled: (allowedMonths.indexOf(moment(date).format('YYYY-MM-DD')) == -1)
          }
        }
      },
      onSelect: function(formattedDate, date) {
        $('#report-month.monthpicker').datepicker().data('datepicker').hide();
        $.ajax({
          type: 'GET',
          url: window.location.pathname,
          data: {
            month: moment(date).format('YYYY-MM-DD'),
            format: 'js'
          }
        });
      }
    });
  }
});
