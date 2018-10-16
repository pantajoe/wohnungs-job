const options = {
  uiEnabled: true,
  validationThreshold: 3,
  focus: 'first',
  trigger: 'focusout',
  errorClass: 'is-danger',
  successClass: 'is-success',
  errorsContainer: function (field) {
    return field.$element.parent().find('.errors');
  },
  errorsWrapper: '<ul class="parsley-errors-list"></ul>',
  errorTemplate: "<li class='help is-danger'></li>"
};

var resetForm = function($form) {
  $.each($form.find('input.input'), function(i, $el) {
    toggleValidationIcon(null, $(this));
  });
  $form[0].reset();
  $form.parsley().reset();
}

var toggleValidationIcon = function(type, $element) {
  $element.removeClass('is-success');
  $element.removeClass('is-danger');
  $element.parent().find('span.icon.is-small.is-right.has-text-danger').remove();
  $element.parent().find('span.icon.is-small.is-right.has-text-success').remove();
  if (type == 'success') {
    $element.addClass('is-success');
    $("<span class='icon is-small is-right has-text-success'><i class='fa fa-check'/></span>")
      .insertAfter($element);
  } else if (type == 'error') {
    $element.addClass('is-danger');
    $("<span class='icon is-small is-right has-text-danger'><i class='fa fa-exclamation-triangle'/></span>")
      .insertAfter($element);
  }
}

var initializeForm = function($form) {
  $form = $($form);
  if ($form.length > 0) {
    $form.parsley(options)
      .on('field:ajaxoptions', function(xhr, data) {
        // query for uniqueness
        var ajaxOptions = Object.assign(data, this.$element.data('parsley-remote-options'));
        ajaxOptions.data += '&where_value=' + this.$element.val();
        return data = ajaxOptions;
      })
      .on('field:success', function(field) {
        toggleValidationIcon('success', field.$element);
      })
      .on('field:error', function(field) {
        toggleValidationIcon('error', field.$element);
      });

    $form.find('input.input').on('change focusout', function() {
      $(this).parsley(options).validate();
    });
  }
}

$(document).on('turbolinks:load', function() {
  window.Parsley.addAsyncValidator('isUnique', function(xhr) {
    return !xhr.responseJSON.result;
  });

  // project modal forms
  initializeForm($('#new-project-form'));

  $.each($('.edit-project-form'), function(i, $el) {
    initializeForm($el);
  });

  // incident modal forms
  initializeForm($('#new-incident-form'));
  initializeForm($('#edit-incident-form'));
});
