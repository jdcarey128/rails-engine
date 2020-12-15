require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:unit_price) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'class methods' do 
    describe 'find_item()' do 
      before :each do 
        @item = create(:item, name: 'Halo Glow', 
                              description: 'Want to glow like an angel? This hat is for you!', 
                      )
        @item_2 = create_list(:item, 3, merchant: @item.merchant)
      end

      it 'returns and item for id match' do 
        expect(Item.find_item({id: @item.id.to_s})).to eq(@item)
      end

      it 'returns first item for name match' do 
        expect(Item.find_item({'name' => @item.name})).to eq(@item)
      end

      it 'returns first item for description match' do 
        expect(Item.find_item({'description' => @item.description})).to eq(@item)
      end

      it 'returns first item for unit_price match' do 
        expect(Item.find_item({unit_price: @item.unit_price.to_s})).to eq(@item)
      end

      it 'returns first item for merchant_id match' do 
        expect(Item.find_item({merchant_id: @item.merchant_id.to_s})).to eq(@item)
      end

      it 'returns first item for created_at match' do 
        expect(Item.find_item({created_at: @item.created_at.to_s})).to eq(@item)
      end

      it 'returns first item for updated_at match' do 
        expect(Item.find_item({updated_at: @item.updated_at.to_s})).to eq(@item)
      end

      it 'returns first item for partial name match' do 
        expect(Item.find_item({'name' => 'halo'})).to eq(@item)
      end

      it 'returns first item for partial description match' do 
        expect(Item.find_item({'description' => 'Glow liKe aN aNGel'})).to eq(@item)
      end

      it 'returns first item for partial description match' do 
        expect(Item.find_item({'description' => 'hAt'})).to eq(@item)
      end
    end

    describe 'find_all' do 
      before :each do 
        @items  = create_list(:item, 3, 
                              name: 'running watch', 
                              description: 'great for long distances!', 
                              unit_price: 50.00, 
                             )
        @item_1 = @items.first 
        @item_4 = create(    :item, 
                              name: 'gps watch',
                              description: 'top quality watch for running', 
                              unit_price: 500.00,
                              merchant: @item_1.merchant 
            )
      end
      
      it 'returns an item array with one item for id' do
        expect(Item.find_all('id' => @item_1.id.to_s)).to eq([@item_1])
        expect(Item.find_all('id' => @item_4.id.to_s)).to eq([@item_4])
      end

      it 'returns an array with multiple items for name' do 
        expect(Item.find_all('name' => @item_1.name)).to eq(@items)
        expect(Item.find_all('name' => @item_1.name).count).to eq(3)
        expect(Item.find_all('name' => 'waTCh')).to eq([@items, @item_4].flatten)
        expect(Item.find_all('name' => 'waTCh').count).to eq(4)
      end

      it 'returns an array with multiple items for description' do 
        expect(Item.find_all('description' => @item_1.description)).to eq(@items)
        expect(Item.find_all('description' => @item_1.description).count).to eq(3)
        expect(Item.find_all('description' => @item_4.description)).to eq([@item_4])
        expect(Item.find_all('description' => @item_4.description).count).to eq(1)
      end

      it 'returns an array with multiple items for partial match description' do 
        expect(Item.find_all('description' => 'great FOR')).to eq(@items)
        expect(Item.find_all('description' => 'great FOR').count).to eq(3)
        expect(Item.find_all('description' => 'fOr')).to eq([@items, @item_4].flatten)
        expect(Item.find_all('description' => 'fOr').count).to eq(4)
      end

      it 'returns an array with multiple items for unit_price' do 
        expect(Item.find_all('unit_price' => @item_1.unit_price.to_s)).to eq(@items)
        expect(Item.find_all('unit_price' => @item_1.unit_price.to_s).count).to eq(3)
      end

      it 'returns an array with multiple items for created_at' do 
        expect(Item.find_all('created_at' => @item_1.created_at.to_s)).to eq([@items, @item_4].flatten)
        expect(Item.find_all('created_at' => @item_1.created_at.to_s).count).to eq(4)
      end

      it 'returns an array with multiple items for updated_at' do 
        expect(Item.find_all('updated_at' => @item_1.updated_at.to_s)).to eq([@items, @item_4].flatten)
        expect(Item.find_all('updated_at' => @item_1.updated_at.to_s).count).to eq(4)
      end

    end
  end
end
