describe User do
	describe '#greet' do
		let(:params) {{name: 'たろう'}}
		context '12歳以下の場合' do
			before do
				params.merge!(age: 12)
			end
			it 'ひらがなで答えること' do
				user = User.new(params)
				expect(user.greet).to eq 'ぼくはたろうだよ。'
			end
		end
		context '13歳以上の場合' do
			before do
				params.merge!(age: 13)
			end
			it '漢字で答えること' do
				user = User.new(params)
				expect(user.greet).to eq '僕はたろうです。'
			end
		end
	end
end

#userをletにする
describe User do
	describe '#greet' do
		let(:user) {User.new(params)}
		let(:params){{name: 'たろう'}}
		context '12歳以下の場合' do
			before do
				params.merge!(age: 12)
			end
			it 'ひらがなで答えること' do
				expect(user.greet).to eq 'ぼくはたろうだよ。'
			end
		end
		context '13歳以上の場合' do
			before do
				params.merge!(age: 13)
			end
			it '漢字で答えること' do
				expect(user.greet).to eq 'ぼくはたろうです。'
			end
		end
	end
end

#let(:params) {{name: 'たろう', age: age}}
#let (:age) {12}
#letは遅延評価

#DRY

describe User do
	describe '#greet' do
		let(:user) {User.new(params)}
		let(:params) {{name: 'たろう', age: age}}
		subject {user.greet}
		context '12歳以下の場合' do
			let(:age) {12}
			it 'ひらがなで答えること' do
				is_expected.to eq 'ぼくはたろうだよ。'
			end
		end
		context '13歳の場合' do
			let(:age) {13}
			it '漢字で答えること' do
				is_expected.to eq '僕はたろうです。'
			end
		end
	end
end

#itの省略
describe User do
	describe '#greet' do
		let(:user) {User.new(params)}
		let{:params) {{name: 'たろう', age: age}}
		subject {user.greet}
		context '12歳以下の場合' do
			let(:age) {12}
			it {is_expected.to eq 'ぼくはたろうだよ。'}
		end
		context '13歳以上の場合' do
			let(:age) {13}
			it {is_expected.to eq '僕はたろうです。'}
		end
	end
end

#リファクタリング

describe User do
	describe '#greet' do
		let(:user) {User.new(name: 'たろう', age: age)}
		subject {user.greet)
		context '12歳以下の場合' do
			let(:age) {12}
			it {is_expected.to eq 'ぼくはたろうだよ。'}
		end
		context '13歳以上の場合' do
			let(:age) {13}
			it {is_expected.to eq '僕はたろうです。'
		end
	end
end

#example の再利用: shared_examples と it_behaves_like

describe User do
	describe '#greet' do
		let(:user) {User.new(name: 'たろう', age: age)}
		subject {user.greet}

		context 'when 0 years old' do
			let(:age) {0}
			it {is_expected.to eq 'ぼくはたろうだよ。'}
		end
		context '12歳の場合' do
			let(:age) {12}
			it {is_expected.to eq 'ぼくはたろうだよ。'}
		end

		context '13歳の場合' do
			let(:age) {13}
			it {is_expected.to eq '僕はたろうです。'}
		end
		context '100歳の場合' do
			let(:age) {100}
			it {is_expected.to eq '僕はたろうです。'}
		end
	end
end

describe User do
	describe '#greet' do
		let(:user) {User.new(name: 'たろう', age: age)}
		subject{user.greet}

		shared_examples '子どもの挨拶' do
			it {is_expected.to eq '僕はたろうだよ。'}
		end
		context '0歳の場合' do
			let(:age) {0}
			it_behaves_like '子どもの挨拶'
		end
		context '12歳の場合' do
			let(:age) {12}
   it_behaves_like '子どもの挨拶'
		end

		shared_examples '大人の挨拶' do
			it {is_expected.to eq '僕はたろうです。'}
		end
		context '13歳の場合' do
			let(:age) {13}
			it_behaves_like '大人の挨拶'
		end
		context '100歳の場合' do
			let(:age) {100}
			it_behaves_like '大人の挨拶'
		end
	end
end

#context の再利用: shared_context と include_context

class User
	def initialize(name:, age:)
		@name = name
		@age = age
	end
	def greet
		if child?
			"ぼくは#{@name}だよ。"
		else
			"ぼくは#{@name}です。"
		end
	end

	def child?
		@age <= 12
	end
end

describe User do
	describe '#greet' do
		let(:user) {User.new(name: 'たろう', age: age)}
		subject {user.greet}
		context '12歳以下の場合' do
			let(:age) {12}
			it {is_expected.to eq 'ぼくはたろうだよ。'}
		end
		context '13歳以上の場合' do
			let(:age) {13}
			it {is_expected.to eq 'ぼくはたろうです。'}
		end
	end
 
	describe '#child?' do
		let(:user) {User.new(name: 'たろう', age: age)}
		subject {user.child?}
		context '12歳以下のばあい' do
			let(:age) {12}
			it {is_expected.to eq true}
		end
		context '13歳以上の場合' do
			let(:age) {13}
			it {is_expected.to eq false}
		end
	end
end

#shared_context と include_context を使うと、 context を再利用することができる

shared_context '12歳の場合' do
	let(:age) {12}
end

include_context '12歳の場合'

#遅延評価される let と事前に実行される let!
#たとえば、Railsで次のような Blog モデルのテストを書くとテストが失敗する

describe Blog do
	let(:blog) {Blog.create(title: 'RSpec必勝法', content: '後で書く')}
	it 'ブログの取得ができること' do
		expect(Blog.first).to eq blog
	end
end
#Blog.first が nil を返す

describe Blog do
	let(:blog) {Blog.create(title: 'RSpec必勝法', content: '後で書く')}
	before do
		blog 
	end
	it 'ブログの取得ができること' do
		expect(Blog.first).to eq blog
	end
end

#let! を使うと example の実行前に let! で定義した値が作られる

describe Blog do
	let!(:blog) {Blog.create(title: 'RSpec必勝法', content: '後で書く')
	it 'ブログの取得ができること' do
		expect(Blog.first).to eq blog
	end
end

#どうしても動かないテストに保留マークを付ける: pending

describe '繊細なクラス' do
	it '繊細なテスト' do
		expect(1+2).to eq 3

		pending 'この先はなぜかテストが失敗するのであとで直す'
		# パスしないエクスペクテーション（実行される）
		expect(foo).to eq bar
	end
end

#問答無用でテストの実行を止める: skip

describe '何らかの理由で実行したくないクラス' do
	it '実行したくないテスト' do
		expect(1+2).to eq 3

		skip 'とりあえずここで実行を保留'
		#実行されない
		expect(foo).to eq bar
	end
end

#手っ取り早くexample全体をskipさせる: xit

describe '何らかの理由で実行したくないクラス' do
	xit '実行したくないテスト' do
		expect(1+2).to eq 3
		expect(foo).to eq bar
	end
end

#ループ全体をまとめてskipさせる: xdescribe / xcontext

xdescribe '四則演算' do
	it '1+1は2' do
		expect(1+1).to eq 2
	end
	it '10-1は9' do
		expect(10-1).to eq 9
	end
end

describe User do
	describe '#good_bye' do
		context '12歳以下のばあい' do
			it 'ひらがなでさよならすること'
		end
		context '13歳以上の場合' do
			it '感じでサヨナラすること'
		end
	end
end

#pending のテストとしてマークされる






