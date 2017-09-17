# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  # 参加処理
  $('.js-participate-button')
    .on 'ajax:success', (event) ->
      status = event.detail[0]['status']
      switch status
        # 参加系処理
        when "created" # 保存に成功した場合
          # 参加成功時のフラッシュメッセージ
          Materialize.toast('参加申請が完了しました', 4000)

          # 参加人数の表示に＋１
          $participant_num_disp = $(this).parents('.js-article-detail').prev().find('.js-participant-num-disp')
          $participant_num_disp.text(($participant_num_disp.text() * 1) + 1)

          # リンクとボタンのデザインの張り替え
          $(this).attr({'data-method' : 'delete', 'data-confirm': "本当に辞退しますか？", href: event.detail[0]['delete_path']})
          $(this).children().html('<i class="material-icons grey-text">group</i><br>辞退')

        when "unprocessable_entity" # 保存に失敗した場合
          # 参加失敗時のフラッシュメッセージ
          Materialize.toast('参加申請に失敗しました', 4000)

        when "already_participated" # 既に参加していた場合
          # 既に参加していた場合のフラッシュメッセージ
          Materialize.toast('既に参加済みです', 4000)

          # リンクとボタンのデザインの張り替え
          $(this).attr({'data-method' : 'delete', 'data-confirm': "本当に辞退しますか？", href: event.detail[0]['delete_path']})
          $(this).children().html('<i class="material-icons grey-text">group</i><br>辞退')

        # 辞退系処理
        when "resign_complete" # 辞退に成功した場合
          # 辞退した旨をフラッシュメッセージで表示
          Materialize.toast('辞退しました', 4000)

          # 参加人数の表示に−１
          $participant_num_disp = $(this).parents('.js-article-detail').prev().find('.js-participant-num-disp')
          $participant_num_disp.text(($participant_num_disp.text() * 1) - 1)

          # リンクとボタンのデザインの張り替え
          $(this).attr({'data-method' : 'post', href: event.detail[0]['post_path']}).removeAttr('data-confirm')
          $(this).children().html('<i class="material-icons red-text">group_add</i><br>参加')

        when "already_resigned" # 既に辞退していた場合
          # 既に辞退している旨をフラッシュメッセージで表示
          Materialize.toast('既に辞退しています', 4000)

    .on 'ajax:error', (event) ->
      # 通信に失敗した旨をフラッシュメッセージで表示
      Materialize.toast('サーバーとの通信に失敗しました。しばらく時間を置いてから再度お試しください。', 4000)
