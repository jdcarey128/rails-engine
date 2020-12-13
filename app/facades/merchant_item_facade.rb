class MerchantItemFacade 
  
  def self.all_items(merchant_id)
    Merchant.find(merchant_id).items
  end
  
end
