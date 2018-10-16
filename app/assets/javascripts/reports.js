$(document).on('ready turbolinks:load', function() {
  initializeReports();
});

var createLoadingSpinner = function() {
  $(
    '<div class="spinner-holder">' +
      '<div class="sk-double-bounce">' +
        '<div class="sk-child sk-double-bounce1"></div>' +
        '<div class="sk-child sk-double-bounce2"></div>' +
      '</div>' +
      '<p>Report wird geladen...</p>' +
    '</div>'
  ).prependTo($('body'));
}

var removeLoadingSpinner = function() {
  $('.spinner-holder').remove();
}

var hideFurtherOptions = function() {
  $('.further-options-box.active').hide();
  $('.further-options-box.active').removeClass('active');
}

var hideFurtherOptionsOnClick = function() {
  // Hide Further Option Box on any other Click
  $(document).click(function(e) {
    var target = e.currentTarget;
    if (!$(target).parents().is('.further-options-box') &&
        !$(target).is('.further-options-box')) {
      $('.further-options-box.active').hide();
      $('.further-options-box.active').removeClass('active');
    }
  });
}

var toggleFurtherOptionsBox = function($optionsButton) {
  var optionsBox = $($optionsButton.data('target'));
  var bottom = $optionsButton.offset().top  + $optionsButton.outerHeight();
  var right  = $optionsButton.offset().left + $optionsButton.outerWidth();
  optionsBox.css({ top: bottom, left: right });
  optionsBox.toggleClass('active');
  optionsBox.toggle();
}

var initializeFurtherOptions = function() {
  $('.panel-tabs').find('.further-options').click(function(e) {
    e.stopPropagation();
    toggleFurtherOptionsBox($(this));
    return false;
  });

  hideFurtherOptionsOnClick();

  $('.panel-tabs').children().click(function(){
    hideFurtherOptions();
  });
}

var initializeSendMail = function() {
  $('.send-mail').click(function(e) {
    e.stopPropagation();
    $.ajax({
      type: 'POST',
      url: $(this).data('href')
    });
  });
}

var initializeNewReport = function() {
  $('.new-report').click(function() {
    hideFurtherOptions();
    createLoadingSpinner();
  });
}

var initializeShowReport = function() {
  $('.panel-block.report').click(function() {
    window.open($(this).data('href'), '_blank');
  });
}

var initializeReports = function() {
  initializeShowReport();
  initializeSendMail();
  initializeFurtherOptions();
  initializeNewReport();
}
