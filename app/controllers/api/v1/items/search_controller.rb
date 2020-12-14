class Api::V1::Items::SearchController < ApplicationController

  def show 
    render json: ItemSerializer.new(Item.find_item(search_param))
  end

  private 
    def search_param 
      params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
    end
end
