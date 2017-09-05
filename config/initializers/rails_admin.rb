RailsAdmin.config do |config|
  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  RailsAdmin.config do |config|
    config.authorize_with do
      authenticate_or_request_with_http_basic('Site Message') do |username, password|
        username == Settings.admin[:id] && password == Settings.admin[:password]
      end
    end

    config.main_app_name { %w(オフカラOK Admin) }
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
