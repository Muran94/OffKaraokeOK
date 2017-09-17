# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  # お気に入り処理
  $('.js-favorite-button')
    .on 'ajax:success', (event) ->
      status = event.detail[0]['status']
      switch status
        # お気に入り登録系処理
        when "created" # 保存に成功した場合
          # 参加成功時のフラッシュメッセージ
          Materialize.toast('お気に入り登録が完了しました', 4000)

          # リンクとボタンのデザインの張り替え
          $(this).attr({'data-method' : 'delete', 'data-confirm': "お気に入り登録を解除してもよろしいですか？", href: event.detail[0]['delete_path']})
          $(this).children().removeClass('grey-text').addClass('yellow-text')

        when "unprocessable_entity" # 保存に失敗した場合
          # 参加失敗時のフラッシュメッセージ
          Materialize.toast('お気に入り登録に失敗しました', 4000)

        when "already_added_to_favorite" # 既にお気に入り登録済みの場合
          # 既にお気に入り登録済みだった場合のフラッシュメッセージ
          Materialize.toast('既にお気に入り登録済みです', 4000)

          # リンクとボタンのデザインの張り替え
          $(this).attr({'data-method' : 'delete', 'data-confirm': "お気に入り登録を解除してもよろしいですか？", href: event.detail[0]['delete_path']})
          $(this).children().removeClass('grey-text').addClass('yellow-text')

        # お気に入り登録解除処理
        when "deleted" # お気に入り削除に成功した場合
          # お気に入り解除した旨をフラッシュメッセージで表示
          Materialize.toast('お気に入り登録を解除しました', 4000)

          # リンクとボタンのデザインの張り替え
          $(this).attr({'data-method' : 'post', href: event.detail[0]['post_path']}).removeAttr('data-confirm')
          $(this).children().removeClass('yellow-text').addClass('grey-text')

        when "already_deleted" # 既に辞退していた場合
          # 既にお気に入り登録の解除が完了している旨をフラッシュメッセージで表示
          Materialize.toast('既にお気に入り解除済みです', 4000)

          # リンクとボタンのデザインの張り替え
          $(this).attr({'data-method' : 'post', href: event.detail[0]['post_path']}).removeAttr('data-confirm')
          $(this).children().removeClass('yellow-text').addClass('grey-text')

    .on 'ajax:error', (event) ->
      # 通信に失敗した旨をフラッシュメッセージで表示
      Materialize.toast('サーバーとの通信に失敗しました。しばらく時間を置いてから再度お試しください。', 4000)
