class VendingMachine
  def initialize
    puts "OK"
  end

  def total
    total = 0
    ary = []
    ary << 0
    # total += money
  end

  def insert(money)
    ary = []

    if money==10 || money==100
      # yen = money
      puts "insert "+money.to_s+" yen"
      ary << money
      puts ary.sum
      # total
    else
      puts "refund"
    end
    money
  end

  # def amount
  #   amount
  # end

  # def kei
  #   kei = 0
  # end
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

