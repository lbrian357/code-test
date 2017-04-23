class PromotionDiscount
  attr_accessor :rules, :scanned, :total
  def initialize(args)
    @rules = args[:rules]
    @scanned = args[:items]
    @total = args[:total]
  end

  def discount_amount
    total_discount = 0
    #lavender_heart_promo discount
    total_discount += (0.75*scanned.count('001')) if lavender_heart_promo?

    # three_for_two_tshirts discount
    total_discount += 19.95 if three_for_two_tshirts?

    # overall discounts should be applied after per item price reduction
    after_per_price_discount_total = total - total_discount
    
    #over60  discount
    total_discount += discount(after_per_price_discount_total, 10) if over60?
    total_discount
  end

  def discount(price, percentage_off_price)
    price * percentage_off_price / 100
  end

  def total_over?(total, top_amount)
    true if total > top_amount
  end
  
  def lavender_heart_promo?
    true if scanned.count('001') >= 2 && rules.include?('lavender_heart_promo')
  end

  def over60?
    true if rules.include?('over60') && total_over?(total, 60)
  end

  def three_for_two_tshirts?
    true if rules.include?('three_for_two_tshirts') && scanned.count('003') > 2
  end
end

class Products
  attr_reader :current
  def initialize(*args)
    @current ||= args
  end
  
  def current
      {
        '001' => { 'name' => 'Lavender heart', 'price' => 9.25 },
        '002' => { 'name' => 'Personalised cufflinks', 'price' => 45.00 },
        '003' => { 'name' => 'Kids T-shirt', 'price' => 19.95 } 
      }
  end
end


class Checkout
  attr_accessor :products, :scanned, :promotional_rules
  def initialize(args)
    @promotional_rules = args[:promotional_rules]
    @products = Products.new.current 
    @scanned ||= []
  end

  def total
    total = prices(scanned).inject(:+)

    discount = PromotionDiscount.new(:rules => promotional_rules, :items => scanned, :total => total).discount_amount

    (total-discount).round(2)
  end

  def scan(item) 
    scanned << item
  end

  def prices(items) 
    #returns array of prices for all items
    items.map do |item|
      products[item]['price']
    end
  end
end
