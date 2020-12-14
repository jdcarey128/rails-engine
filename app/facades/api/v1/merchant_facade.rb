class Api::V1::MerchantFacade 
  def self.all_merchants
    Merchant.all
  end
end
