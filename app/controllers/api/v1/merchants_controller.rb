class Api::V1::MerchantsController < ApplicationController
  
  def index 
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show 
    merchant = Merchant.find_by(id: params[:id])
    if merchant 
      render json: MerchantSerializer.new(merchant)
    else 
      render_error("The merchant id", " does not exist in the database")
    end
  end

  def create 
    merchant = Merchant.new(merchant_params)
    if merchant.save 
      render json: MerchantSerializer.new(merchant)
    else 
      render_error(merchant.errors.full_messages.to_sentence)
    end
  end

  def update 
    render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
  end

  def destroy 
    Merchant.destroy(params[:id])
    head :no_content
  end

  private 
    def merchant_params 
      params.permit(:name)
    end
    
    def render_error(error, extension = "")
      render json: {
        status: :bad_request,
        errors: "#{error} in your query" + extension
      }
    end
end
