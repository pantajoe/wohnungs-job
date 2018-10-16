function openModal(target) {
  var $target = $(target);
  $(document.documentElement).addClass('is-clipped');
  $($target).addClass('is-active');
}

function closeModals() {
  $(document.documentElement).removeClass('is-clipped');
  $('.modal').removeClass('is-active');
}

var initializeModals = function() {
  var $modalCloses = $('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button.cancel');
  var $modalButtons = $('.modal-button');

  if ($modalButtons.length > 0) {
    $.each($modalButtons, function(i, $el) {
      $($el).bind('click', function(e) {
        e.preventDefault();
        openModal($($el).data('target'));
      });
    });
  }

  if ($modalCloses.length > 0) {
    $modalCloses.on('click', function(e) {
      e.preventDefault();
      closeModals();
    });
  }

  $(document).keydown(function(e) {
    // Esc-Key
    if (e.keyCode == 27) closeModals();
  });
}

$(document).on('turbolinks:load', function() {
  initializeModals();
});
