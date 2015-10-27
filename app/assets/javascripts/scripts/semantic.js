$(document).ready(function() {
  // Set up Semantic-UI components

  // Dropdown Menus
  $('.ui.hover.dropdown').dropdown({ on: 'hover' });
  $('.ui.click.dropdown').dropdown();

  // Messages
  $('.message .close').on('click', function() {
    $(this).closest('.message').fadeOut(function() {
      $(this).remove();
    });
  });

  setTimeout(function() {
    $('.message .close').closest('.message').fadeOut(function() {
      $(this).remove();
    });
  }, 5000);

  // Checkboxes
  $('.ui.checkbox').checkbox();

  // Progress Bars
  $('.progress').progress();

  // Popups
  $('.popup').popup();

});
