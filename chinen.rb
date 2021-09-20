class DrinkCollection
  include Enumerable
  attr_reader :drinks

  def initialize
    @drinks = [
      Drink.new(kind: :coke, price: 120, amount: 5),
      Drink.new(kind: :redbull, price: 200, amount: 5),
      Drink.new(kind: :water, price: 100, amount: 5),
    ]
  end

  def keys
    @drinks.map(&:kind)
  end

  def each
    @drinks.each do |drink|
      yield drink if block_given?
    end
  end

  def find_drink key
    @drinks.find{|drink| drink.kind == key}
  end
end

class Drink
  attr_reader :price, :amount, :kind
  def self.KIND
    [
      {key: :coke, name: "コーラ"},
      {key: :water, name: "水"},
      {key: :redbull, name: "レッドブル"}
    ]
  end

  def initialize kind: nil, price: nil, amount: nil
    raise if kind.nil? || price.nil? || amount.nil?
    raise unless Drink.KIND.map{|k| k[:key]}.include? kind
    @kind = kind
    @price = price
    @amount = amount
  end

  def purchased
    @amount -= 1
  end

  def available?
    @amount > 0
  end


  def name
    kind = Drink.KIND.find{|kind| kind[:key] == @kind}
    kind[:name]
  end

  def to_s
    "価格： #{@price.to_s}円, 在庫: #{@amount.to_s}本, 種類: #{name}"
  end
end


class VendingMachine

  def self.ACCEPTABLE_MONEY
    [10, 50, 100, 500, 1000]
  end

  def initialize
    @total_sales = 0
    @total = 0
    @drink_collection = DrinkCollection.new
  end

  def total
    @total
  end

  def display_total
    puts "投入済み金額: #{total}円"
  end

  def insert(input_money)
    if VendingMachine.ACCEPTABLE_MONEY.include? input_money
      puts "#{input_money.to_s}円が投入されました"
      @total += input_money
      display_total
      :succeeded
    else
      puts "受付不可能なお金を返却"
      display_total
      input_money
    end
  end

  def display_purchase_message
    puts "購入したい商品を選択してください。"
    puts "======="
    @drink_collection.each_with_index do |item, index|
      puts "#{item.name} を 購入したい場合は #{index+1}"
    end
    puts "======="
    puts "を入力し、Enter キーを押してください。"
  end

  def purchase
    display_purchase_message
    input_kind = gets
    puts ""
    puts ""
    rst = purchase_item(@drink_collection.keys[input_kind.to_i - 1])
    case rst
    when :no_kind
      puts "そんなのありません"
    when :no_item
      puts "在庫がありません"
    when :less_money
      puts "投入金額が足りません"
    else
      puts "#{rst} が購入されました。"
      puts "(ガタンッ!)"
      puts "取り出してください。"
    end
    puts ""
    puts ""
    display_status
  end

  def purchase_item item_key
    return :no_kind unless DrinkCollection.KIND.include? item_key
    target_item = get_item(item_key)
    return :no_item unless target_item.available?
    return :less_money if @total <= target_item.price
    @total -= target_item.price
    @total_sales += target_item.price
    target_item.purchased
    target_item.name
  end

  def get_item item_key
    @drink_collection.find_drink item_key
  end

  def refund
    puts "#{total}円を返却"
    display_total
    @total = 0
  end

  def display_status
    display_input_money
    display_sales_info
    display_stock_info
  end

  private
    def display_input_money
      puts "投入金額: #{total}"
    end

    def display_stock_info
      @drink_collection.each_with_index do |d, index|
        puts "No.#{(index+1).to_s.rjust(3, '0')} --- #{d.to_s}"
      end
      nil
    end

    def display_sales_info
      puts "売上金額: #{@total_sales}"
    end

end

# vm = VendingMachine.new

# vm.total # => 0と出力される

# # 10円を投入
# vm.insert(10)
# => 何を返すと良いか？

# # 100円を投入
# vm.insert(100)
# => 何を返すと良いか？

# # 貨幣として存在しない111円を投入
# vm.insert(111) # => 何を返すといいのか？考える

# vm.total # => 110と出力される

