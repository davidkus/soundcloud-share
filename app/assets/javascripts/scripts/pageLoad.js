$(document).on('page:fetch', function() {
  $("#main-content-segment").addClass("loading");
});

$(document).on('page:change', function() {
  $("#main-content-segment").removeClass("loading");
  jdenticon();
});
