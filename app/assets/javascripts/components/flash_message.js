var initializeFlashMessage = function() {
  $('.flash-message').find('button.delete').click(function() {
    $(this).parent().remove();
  });

  setTimeout(function() {
    $('.flash-message').fadeOut(500);
  }, 7000);
}

$(document).on('turbolinks:load', function() {
  initializeFlashMessage();
});
