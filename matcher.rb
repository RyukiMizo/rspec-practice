#to / not_to / to_not
expect(1+2).to eq 3
expect(1+2).not_to eq 1
expect(1+2).to_not eq 1

#be
expect(1+2).to be >= 3

message = 'Hello'
expect([message].first).to be message

#同じ値でもインスタンスが異なる場合はテストは失敗

message_1 = 'Hello'
message_2 = 'Hello'
expect([message_1].first).to be message_2 #=>error
#一方、be の代わりに eq を使うと == を使って比較する
expect([message_1].first).to eq message_2

expect(true).to be true
expect(false).to be false
expect(nil).to be nil
# 整数値やシンボルは、同じ値はいつでも同じインスタンス
expect(1+!).to be 2
expect(:foo).to be :foo

#be_xxx (predicateマッチャ)

expect([]).to be_empty
#このコードは意味的に次のコードと同じ
expect([].empty?).to be true

#Railsのmodelにバリデーションエラーが発生していないことを検証する

user = User.new(name: 'Tom', email: 'tom@example.com')
expect(user).to be_valid
# userが妥当であるかどうかを確認

#戻り値として true / false を返すメソッドの場合

class User < ActiveRevord::Base
	validates :name, :email, presence: true
end

user = User.new
expect(user.save).to be_falsey

user.name = 'Tom'
user.email = 'tom@example.com'
expect(user.save).to be_truthy

#be_truthy / be_falsey と be true / be false との違い

expect(1).to be_truthy
expect(nil).to be_falsey

#error
expect(1).to be true
expect(nil). to be false
#error
expect(1).to eq true
expect(nil).to eq false


#change matcher
x = [1,2,3]
expect(x.size).to eq 3
x.pop
expect(x.size).to eq 2

x = [1,2,3]
expect{x.pop}.to change{x.size}.from(3).to(2)
#by
expect{x.pop}.to change{x.size}.by(-1)
expect{x.push(10)}.to change{x.size}.by(1)

#changeの応用
class User < ActiveRecord::Base
	has_many :blogs, dependent: :destroy
end

class Blog < ActiveRecord::Base
	belongs_to :user
end

it 'userを削除すると、userが書いたblogも削除されること' do
	user = User.create(name: 'Tom', email: 'tom@example.com')
	user.blogs.create(title: 'RSpec必勝法', content: "後で書く")

	expect{user.destroy}.to change{Blog.count}.by(-1)
end


#include

x = [1,2,3]
expect(x).to include 1
expect(x).to include 1,3


#raise_error

expect{1/0}.to raise_error ZeroDivisionError

class ShoppingCart
	def initialize
		@items = []
 end
	def add(item)
		raise 'Item is nil.' if item.nil?
		@items << item
	end
end

it 'nilを追加するとエラーが発生すること' do
	cart = ShoppingCart.new
	expect{cart.add nil}.to raise_error 'Item is nil.'
end

class Lottery
	KUJI = %w(あたり 外れ 外れ 外れ)
	def initialize
		@result = KUJI.sample
	end
	def win?
		@result == 'あたり'
	end
	def self.generate_results(count)
		Array.new(count){self.new}
	end
end

#self.newでinitializeでランダムにくじを引く
#ary = Array.new(3){|index| "hoge#{index}"}
#p ary   => ["hoge0", "hoge1", "hoge2"]

it '当選確率が約25%になっていること' do
	results = Lottery.generate_results(10000)
	win_count= results.count(&:win?)
	probability = win_count.to_f / 10000 * 100
	expect(probability).to be_within(1.0)of(25.0)
end
#前後1%のゆらぎを許容
#results.count(&:win?) は results.count{|r| r.win?}

expect{you.read_this_entry}.to change{your.matcher_expert?}.from(be_falsey).to(be_truthy)


