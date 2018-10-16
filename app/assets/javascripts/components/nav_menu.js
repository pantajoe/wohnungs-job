$(document).on('turbolinks:load', function() {
  $('a.nav-menu').click(function() {
    $('a.nav-menu').toggleClass('active');
    $('#nav-dropdown').toggle();
  });

  $(document).click(function(e) {
    var target = e.target;
    if (!$(target).is('#nav-dropdown') && !$(target).parents().is('#nav-dropdown') && !$(target).parents().is('a.nav-menu')) {
      if ($('#nav-dropdown').css('display') != 'none') {
        $('a.nav-menu').removeClass('active');
        $('#nav-dropdown').toggle();
      }
    }
  });

  $(".navbar-burger").click(function() {
      // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
      $('.navbar-burger').toggleClass('is-active');
      $('.navbar-menu').toggleClass('active');
      $('.navbar-menu').slideToggle();
  });
});
