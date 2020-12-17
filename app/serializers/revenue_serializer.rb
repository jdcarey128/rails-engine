class RevenueSerializer 
  
  def self.format_revenue(revenue)
    {
      "data": {
        "id": nil, 
        "attributes": {
          "revenue": revenue
        }
      }
    }
  end
  
  
end
