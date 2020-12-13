class Api::V1::MerchantsController < ApplicationController
  
  def index 
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show 
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def create 
    # refactor: harness params are sent through body 
    render json: MerchantSerializer.new(Merchant.create(merchant_params))
  end

  def update 
    # refactor: harness params are sent through body 
    render json: MerchantSerializer.new(Merchant.update(params[:id], merchant_params))
  end

  def destroy 
    #refactor with serializer 
    #how to render 204 response? 
    # head :no_content
    render json: Merchant.delete(params[:id])
  end

  private 
    def merchant_params 
      params.require(:merchant).permit(:name)
    end
  
end
