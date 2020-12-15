class Api::V1::Items::SearchController < ApplicationController

  def show 
    render json: ItemSerializer.new(Item.find_one(search_param))
  end

  def index 
    render json: ItemSerializer.new(Item.find_all(search_param))
  end

  private 
    def search_param 
      params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
    end
end
