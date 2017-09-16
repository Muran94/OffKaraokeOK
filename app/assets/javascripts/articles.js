$(document).on('turbolinks:load', function() {
  // 投稿リストの開閉処理
  $(".js-article-header").click(function() {
    $(".js-article-detail").not($(this).next()).slideUp();
    $(this).next().slideToggle();
  })

  $(".js-close-article-detail").click(function() {
    $(this).closest('.js-article-detail').slideUp();
  })
})
