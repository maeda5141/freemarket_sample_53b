class CreditsController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.credits.present?
      Payjp.api_key = get_payjp_key()
      credit = current_user.credits.first
      customer = Payjp::Customer.retrieve(credit.customer_id)
      card = customer.cards.retrieve(customer.default_card)
      @card_info = get_card_info(current_user)
    end
  end
  
  def new
    if current_user.credits.present?
      redirect_to credits_path
    end
  end

  def create
    if current_user.credits.present?
      credit = current_user.credits.first
      @credit = create_payjp_card(current_user , credit.costomer)
    else
      customer = create_payjp_customer()
      @credit = create_payjp_card(current_user, customer)
    end
    
    if @credit.save
      flash[:notice] = "クレジットカードを登録しました"
      redirect_to credits_path
    else
      flash[:alert] = "登録に失敗しました"
      render "new"
    end
  end

  def destroy 
    if current_user.credits.present?
      Payjp.api_key = get_payjp_key()
      credit = current_user.credits.first
      customer = Payjp::Customer.retrieve(credit.customer_id)
      customer.delete
      credit.destroy
    end
    flash[:notice] = "クレジットカードを削除しました"
    redirect_to action: "index"
  end

  private

  def create_payjp_customer
    Payjp.api_key = get_payjp_key()
    customer = Payjp::Customer.create()
  end

  def create_payjp_card(user,customer)
    customer.cards.create(card: token_parmas[:token])
    credit = Credit.new(
      user_id: user.id,
      customer_id: customer.id,
    )
  end

  def token_parmas
    params.permit(:token)
  end

  def get_payjp_key
    Rails.application.credentials.MERUCARI_PAYJP_SECRET_KEY
  end

  def get_card_info(user)
    Payjp.api_key = get_payjp_key()
    credit = user.credits.first
    customer = Payjp::Customer.retrieve(credit.customer_id)
    card = customer.cards.retrieve(customer.default_card)
    card_info = {}
    if card.brand == "Visa"
      card_info[:brand] = "visa.svg"
    elsif card.brand == "master"
      card_info[:brand] = "master.png"
    elsif card.brand == "jcb"
      card_info[:brand] = "jcb.png"
    else
      card_info[:brand] = "non-card.png"
    end
    
    card_info[:last4] = "*" * 12 + card.last4
    card_info[:exp_date] = "#{card.exp_month}/#{card.exp_year.to_s.slice(2,2)}"
    return card_info
  end

  def pay(user,item)
    if user.nil? || item.nil? || user.credits.blank?
      return false
    end
    Payjp.api_key = get_payjp_key()
    charge = Payjp::Charge.create(
      amount: item.price,
      customer: user.credits.first.customer_id,
      currency: 'jpy'
    )
    return true
  end
end
