class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  protect_from_forgery with: :exception
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials.BASIC_AUTH_USER && password == Rails.application.credentials.BASIC_AUTH_PASSWORD
    end
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, 
      keys: [
              :nickname, 
              :first_name, 
              :last_name, 
              :first_name_kana,     
              :last_name_kana, 
              :birthday, 
              :image, 
              :postal_cade, 
              :prefecture, 
              :city, 
              :address_num, 
              :building, 
              :tell, 
              :gender, 
              :profile       
            ]
    )
  end
end
