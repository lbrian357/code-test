class Promotions
end

module Products
end

class Checkout

  def initialize(*promotional_rules)
    @promotional_rules = promotional_rules
    @products = {
      '001' => { 'name' => 'Lavender heart', 'price' => 9.25 },
      '002' => { 'name' => 'Personalised cufflinks', 'price' => 45.00 },
      '003' => { 'name' => 'Kids T-shirt', 'price' => 19.95 } 
                }
    @scanned = []
  end

  def total
    total = prices(@scanned).inject(:+)

    total -= discount(total, 10) if @promotional_rules.include?('over60') && total_over?(total, 60)

    total.round(2)
  end

  def scan(item) 
    @scanned << item
  end

  def discount(price, percentage_off)
    price * percentage_off / 100
  end
  
  def prices(items) 
    #replaces price with promo price when necessary
    items.map do |item|
      if item == '001' && lavender_heart_promo?
        8.50
      else
        @products[item]['price']
      end
    end
  end

  def total_over?(total, amount)
    true if total > amount
  end
  
  def lavender_heart_promo?
    true if @scanned.count('001') >= 2 && @promotional_rules.include?('lavender_heart_promo')
  end
end
