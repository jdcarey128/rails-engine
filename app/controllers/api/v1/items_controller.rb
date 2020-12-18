class Api::V1::ItemsController < ApplicationController 
  
  def index 
    render json: ItemSerializer.new(Item.all)
  end

  def show 
    item = Item.find_by(id: params[:id])
    if item 
      render json: ItemSerializer.new(item)
    else 
      render_error("The item", " does not exist in the database")
    end
  end

  def create 
    item = Item.new(item_params)
    if item.save 
      render json: ItemSerializer.new(item)
    else 
      render_error(item.errors.full_messages.to_sentence)
    end
  end

  def update 
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end
  
  def destroy 
    Item.destroy(params[:id])
    head :no_content
  end

  private 
    def item_params 
      params.permit(:name, :description, :unit_price, :merchant_id)
    end

    def render_error(error, extension = "")
      render json: {
        status: :bad_request,
        errors: "#{error} in your query" + extension
      }
    end
end
