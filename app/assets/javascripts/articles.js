$(document).on('turbolinks:load', function() {
  // 投稿リストの開閉処理
  // 投稿リストのタイトルをクリックした時に詳細をプルダウンする
  $(".js-article-header").click(function(e) {
    if( $(e.target).closest('.favorite-btn').length ){
      return // お気に入りボタンを押した時はslideDown()しない
    }
    $(".js-article-detail").not($(this).next()).slideUp();
    $(this).next().slideToggle();
  })

  // 投稿詳細プルダウンのメニューバーに表示される「閉じる」ボタンを押した時に詳細を閉じる
  $(".js-article-detail").click(function(e) {
    if( $(e.target).closest('.js-article-menu').length ){
      return; // 投稿のメニューボタンをクリックした時はslideUp()しない
    }
    $(this).slideUp();
  })
})
