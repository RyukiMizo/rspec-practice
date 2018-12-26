#describe / it / expect の役割を理解する
describe '四則演算' do
  it '1 + 1 は 2 になること' do
    expect(1 + 1).to eq 2
  end
end

#複数の example
describe '四則演算' do
  it '1 + 1 は 2 になること' do
    expect(1 + 1).to eq 2
  end
  it '10 - 1 は 9 になること' do
    expect(10 - 1).to eq 9
  end
end

#複数のエクスペクテーション
describe '四則演算' do
  it '全部できること' do
    expect(1 + 2).to eq 3
    expect(10 - 1).to eq 9
    expect(4 * 8).to eq 32
    expect(40 / 5).to eq 8
  end
end

#ネストした describe

describe '四則演算' do
  describe '足し算' do
    it '1 + 1 は 2 になること' do
      expect(1 + 1).to eq 2
    end
  end
  describe '引き算' do
    it '10 - 1 は 9 になること' do
      expect(10 - 1).to eq 9
    end
  end
end

#context と before でもう少し便利に

class User
  def initialize(name:, age:)
    @name = name
    @age = age
  end
  def greet
    if @age <= 12
      "ぼくは#{@name}だよ。"
    else
      "僕は#{@name}です。"
    end
  end
end

describe User do
  describe '#greet' do
    it '12歳以下の場合、ひらがなで答えること' do
      user = User.new(name: 'たろう', age: 12)
      expect(user.greet).to eq 'ぼくはたろうだよ。'
    end
    it '13歳以上の場合、漢字で答えること' do
      user = User.new(name: 'たろう', age: 13)
      expect(user.greet).to eq '僕はたろうです。'
    end
  end
end

describe User do
  describe '#greet' do
    context '12歳以下の場合' do
      it 'ひらがなで答えること' do
        user = User.new(name: 'たろう', age: 12)
        expect(user.greet).to eq 'ぼくはたろうだよ。'
      end
    end
    context '13歳以上の場合' do
      it '漢字で答えること' do
        user = User.new(name: 'たろう', age: 13)
        expect(user.greet).to eq '僕はたろうです。'
      end
    end
  end
end

#before で共通の前準備をする
describe User do
	describe '#greet' do
		before do
			@params = {name: 'たろう'}
		end
		context '12歳以下の場合' do
			it 'ひらがなで答えること' do
				user = User.new(@params.merge(age: 12))
				expect(user.greet).to eq 'ぼくはたろうだよ。'
			end
		end
		context '13歳以上の場合' do
			it '漢字で答えること' do
				user = User.new(@params.merge(age: 13))
				expect(user.greet).to eq 'ぼくはたろうです。'
			end
		end
	end
end

#ネストした describe や context の中で before を使う

describe User do
	describe '#greet' do
		before do
			@params = {name: 'たろう'}
		end
		context '12歳以下の場合' do
			before do
				@params.merge!(age: 12)
			end
			it 'ひらがなで答えること' do
				user = User.new(@params)
				expect(user.greet).to eq 'ぼくはたろうだよ。'
			end
		end
		context '13歳以上の場合' do
			before do
				@params.merge!(age: 13)
			end
		 it '漢字で答えること' do
			 user = User.new(@params)
				expect(user.greet).to eq '僕はたろうです。'
			end
		end
	end
end

