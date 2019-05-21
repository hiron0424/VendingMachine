# 初期化（自動販売機インスタンスを作成して、vmという変数に代入する）
# irbを起動
# require './vending_machine.rb'
# vm = VendingMachine.new


# 作成した自動販売機に100円を入れる
# vm.put_money (100)

# 作成した自動販売機に入れたお金がいくらかを確認する（表示する）
# vm.current_money

# 作成した自動販売機に入れたお金を返してもらう
# vm.return_money

# ドリンクの補充（コーラを５本補充する場合）
# vm.supply_drink(Drink.cola, 5)

class VendingMachine
  # ステップ０　お金の投入と払い戻しの例コード
  # ステップ１　扱えないお金の例コード

  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze

  # 投入金額と売り上げ合計の読み込みメソッドを自動的に定義
  attr_reader :current_money, :drink_sales

  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @current_money = 0
    @drink_sales = 0
    @drink_stock = {}
    # コーラを５本格納する
    supply_drink(Drink.cola, 5)
  end

  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
  def put_money(money)
    # 想定外のもの（１円玉や５円玉。千円札以外のお札、そもそもお金じゃないもの（数字以外のもの）など）
    # が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。
    return false unless MONEY.include?(money)
    @current_money += money
  end

  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    # 返すお金の金額を表示する
    puts "返金額: #{@current_money}円"
    # 自動販売機に入っているお金を0円に戻す
    @current_money = 0
  end

  # ドリンクを補充する
  # 任意の本数補充が可能、デフォルトは1本
  def supply_drink(drink, number = 1)
    number.times do
      unless @drink_stock.has_key?(drink.name)
        @drink_stock[drink.name] = { price: drink.price, drinks: []}
      end
        @drink_stock[drink.name][:drinks] << drink
    end
  end

  def drink_info
    @drink_stock.map {|name, other|
              [name, { price: other[:price],
              stock: other[:drinks].size }]
    }.to_h
  end

  def can_buy?(drink_name)# (:cola)のようにシンボルで入力する
    @drink_stock.has_key?(drink_name) &&
    show_price(drink_name) <= @current_money &&
    show_stock(drink_name) >= 1
  end

  def can_buy_list
    @drink_stock.select do |name, other|
      other[:price] <= current_money && other[:drinks].empty? != true
      puts "#{name}が購入可能です。"
    end
  end

  # ドリンクを購入する
  def buy(drink_name)
    price = show_price(drink_name)

    if can_buy?(drink_name)
      @current_money -= price
      @drink_sales += price
      item = decrease_stock(drink_name)
      refund = return_money
      puts "商品:#{item}"
    else
      puts "#{drink_name}を買う事が出来ません。投入金額を確認してください。"
    end
  end

  # 飲み物別の値段を表示
  def show_price(drink_name)
    @drink_stock[drink_name][:price]
  end

  # 飲み物別の在庫数を表示
  def show_stock(drink_name)
    @drink_stock[drink_name][:drinks].size
  end

  private

  # 飲み物の在庫を減らす（先入れ先出し）
  def decrease_stock(drink_name)
    @drink_stock[drink_name][:drinks].shift
  end
end

class Drink
  attr_reader :name, :price

  def initialize(name, price)
    @name = name.to_sym
    @price = price.to_i
  end

  def self.cola
    self.new(:cola, 120)
  end

  def self.water
    self.new(:water, 100)
  end

  def self.redbull
    self.new(:redbull, 200)
  end

  def self.coffee
    self.new(:coffee,130)
  end
end