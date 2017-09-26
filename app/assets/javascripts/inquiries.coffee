# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('#js-inquiry-form')
    .on 'ajax:success', (event) ->
      status = event.detail[0]['status']
      switch status
        when "created" # 保存に成功した場合
          # 問い合わせ完了フラッシュメッセージを表示
          Materialize.toast('問い合わせが完了しました', 4000)

          # 問い合わせに対する感謝のメッセージを表示
          $('#js-inquiry-form-container').addClass('hide')
          $('#js-inquiry-form-success-message-container').removeClass('hide')

        when "unprocessable_entity" # 保存に失敗した場合
          # 問い合わせ失敗フラッシュメッセージを表示
          Materialize.toast('問い合わせに失敗しました', 4000)

          # エラーメッセージを表示
          errors = event.detail[0]['data']
          if errors["inquirers_email"]?
            $("#error-message-for-inquiry-inquirers-email-field.red-text").removeClass('hide')
          if errors["type"]?
            $("#error-message-for-inquiry-type-field").removeClass('hide')
          if errors["message"]?
            $("#error-message-for-inquiry-message-field").removeClass('hide')

    .on 'ajax:error', (event) ->
      $('#js-inquiry-form-container').addClass('hide')
      $('#js-inquiry-form-error-message-container').removeClass('hide')
