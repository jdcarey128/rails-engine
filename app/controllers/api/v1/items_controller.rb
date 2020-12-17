class Api::V1::ItemsController < ApplicationController 
  
  def index 
    render json: ItemSerializer.new(Item.all)
  end

  def show 
    item = Item.find_by(id: params[:id])
    if item 
      render json: ItemSerializer.new(item)
    else 
      nonexisting_item
    end
  end

  def create 
    item = Item.new(item_params)
    if item.save 
      render json: ItemSerializer.new(item)
    else 
      missing_params(item)
    end
  end

  def update 
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end
  
  def destroy 
    Item.delete(params[:id])
    head :no_content
  end

  private 
    def item_params 
      params.permit(:name, :description, :unit_price, :merchant_id)
    end

    def nonexisting_item
      render json: {
        status: :bad_request,
        errors: "Item does not exist in the database"
      }
    end

    def missing_params(item)
      render json: {
        status: :bad_request,
        errors: "#{item.errors.full_messages.to_sentence} in your query"
      }
    end
end
