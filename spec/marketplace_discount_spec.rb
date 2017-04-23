require 'marketplace_discount'

describe Checkout do

  describe '#total' do
    it 'should add up checkout item prices normally when there are no promotional rules' do
      co = Checkout.new(:promotional_rules => [])
      co.scan('001')
      co.scan('002')
      co.scan('003')
      co.scan('001')
      price = co.total
      expect(price).to eq(83.45)
    end

    it 'should give a 10% discount when total is over 60 pounds and promotional rule is active' do
      co = Checkout.new(:promotional_rules => ['over60'])
      co.scan('001')
      co.scan('002')
      co.scan('003')
      price = co.total
      expect(price).to eq(66.78)
    end

    it 'should reduce the price of lavender hearts to 8.5 when two or more is in checkout and promotional rule is active' do
      co = Checkout.new(:promotional_rules => ['lavender_heart_promo'])
      co.scan('001')
      co.scan('003')
      co.scan('001')
      price = co.total
      expect(price).to eq(36.95)
    end

    it 'should apply both over60 and lavender_heart_promo in same order' do
      co = Checkout.new(:promotional_rules => ['lavender_heart_promo', 'over60'])
      co.scan('001')
      co.scan('002')
      co.scan('001')
      co.scan('003')
      price = co.total
      expect(price).to eq(73.76)
    end

    it 'should not apply promotions if requirements are not met' do
      co = Checkout.new(:promotional_rules => ['lavender_heart_promo', 'over60'])
      co.scan('001')
      co.scan('003')
      co.scan('003')
      price = co.total
      expect(price).to eq(49.15)
    end

    it 'should apply three for two tshirts if three tshirts are ordered' do
      co = Checkout.new(:promotional_rules => ['three_for_two_tshirts'])
      co.scan('003')
      co.scan('003')
      co.scan('003')
      price = co.total
      expect(price).to eq(39.90)
    end
      
  end
end
