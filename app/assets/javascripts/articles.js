$(document).on('turbolinks:load', function() {
  // 投稿リストの開閉処理
  // 投稿リストのタイトルをクリックした時に詳細をプルダウンする
  $(".js-article-header").click(function() {
    $(".js-article-detail").not($(this).next()).slideUp();
    $(this).next().slideToggle();
  })

  // 投稿詳細プルダウンのメニューバーに表示される「閉じる」ボタンを押した時に詳細を閉じる
  $(".js-close-article-detail").click(function() {
    $(this).closest('.js-article-detail').slideUp();
  })
})
