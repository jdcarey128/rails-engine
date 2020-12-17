class Api::V1::MerchantRevenueFacade 
  
  def self.total_revenue(start_date, end_date)
    Merchant.total_revenue(start_date, end_date)
  end
end
