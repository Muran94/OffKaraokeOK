(function() {
  $(function() {
    return $(".collection-item").click(function() {
      $(".js-detail-container").not($(this).next()).slideUp();
      return $(this).next().slideToggle();
    });
  });

}).call(this);
