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
        expect(Item.find_item({id: @item.id})).to eq(@item)
      end

      it 'returns first item for name match' do 
        expect(Item.find_item({name: @item.name})).to eq(@item)
      end

      it 'returns first item for description match' do 
        expect(Item.find_item({description: @item.description})).to eq(@item)
      end

      it 'returns first item for unit_price match' do 
        expect(Item.find_item({unit_price: @item.unit_price})).to eq(@item)
      end

      it 'returns first item for merchant_id match' do 
        expect(Item.find_item({merchant_id: @item.merchant_id})).to eq(@item)
      end

      it 'returns first item for created_at match' do 
        expect(Item.find_item({created_at: @item.created_at})).to eq(@item)
      end

      it 'returns first item for updated_at match' do 
        expect(Item.find_item({updated_at: @item.updated_at})).to eq(@item)
      end

      it 'returns first item for partial name match' do 
        expect(Item.find_item({name: 'halo'})).to eq(@item)
      end

      it 'returns first item for partial description match' do 
        expect(Item.find_item({description: 'Glow liKe aN aNGel'})).to eq(@item)
      end

      it 'returns first item for partial description match' do 
        expect(Item.find_item({description: 'hAt'})).to eq(@item)
      end

    end
  end
end
