require 'rails_helper'

feature 'ログインとログアウト' do
	background do
		#ユーザを作成
		User.create!(email: 'a@example.com', password: 'aa')
	end
	scenario ログインする' do
		visit root_path
		fill_in 'Email', with: 'a@example.com'
		fill_in 'Password', with: 'aa'
		click_on 'ログイン'
		expect(page).to have_content 'ログインしました'
		end
end

#特定のページへ移動する
visit root_path
visit new_user_path

#現在のページを再読み込み（リロード）する
visit current_path

#submitボタンやbuttonタグをクリック
<input type="submit" nmae="commit" value="Save">
#or
<button>Save</button>
click_button 'Save'

#CSSによって見た目がボタンっぽくなっていても、HTML上はaタグになっている場合は「リンク」と見なされるので注意が必要
<a href="/users/new">New User</a>
click_link 'New User'

#リンクまたはボタンをクリックする
<a href="/users/new">New User</a>
<input type="submit" name="commit" value="Save">
click_on 'New User'
click_on 'Save'

#画像のalt属性を利用してリンクをクリックする
<a href="/users/1">
 <img alt="Alice" src="./profile.jpg">
</a>
click_on 'Alice'

#テキストボックスまたはテキストエリアに文字を入力する
<label for="blog_title">タイトル</label>
<input type="text" value="" name="blog[title]" id="blog_title">
fill_in 'タイトル', with: 'こんにちは'

<label for="japanese_calendar">和暦</label>
<select name="japanese_calendar" id="japanese_calendar">
  <option value="0">明治</option>
  <option value="1">大正</option>
  <option value="2">昭和</option>
  <option value="3">平成</option>
</select>

select '平成', from: '和暦'

<label for="mailmagazine">
    <input type="checkbox" name="mailmagazine" id="mailmagazine" value="1">
    メールマガジンを購読する
</label>

check 'メールマガジンを購読する'
uncheck 'メールマガジンを購読する'

<label>
  <input id="user_sex_male" name="user[sex]" type="radio" value="male" checked="checked">
  男性
</label>
<label>
  <input id="user_sex_female" name="user[sex]" type="radio" value="female">
  女性
</label>

choose '女性'

#ファイルを添付する

attach_file 'プロフィール画像', "#{Rails.root}/spec/factories/profile_image.jpg"
<input type="hidden" name="secret_value" id="secret_value">
find('#select_value', visible: false).set('secret!!')

#ページ内に特定の文字列が表示されていることを検証する
expect(page).to have_content 'ユーザーが作成されました。'

<h1 class="information" id="information">大事なお知らせ</h1>
expect(page).to have_selecter 'h1', text: '大事なお知らせ'

expect(page).to have_selector '.information', text: '大事なお知らせ'
# または
expect(page).to have_selector '#information', text: '大事なお知らせ'
# タグとクラスを組み合わせるのも可
expect(page).to have_selector 'h1.information', text: '大事なお知らせ'

<a href="contacts/1" data-method="delete">delete</a>
expect(page).to have_selecter 'a[data-method=delete]', text: 'delete'

expect(page).to have_selector 'h1', text: /^大事なお知らせ$/

#ページ内に特定のボタンが表示されていることを検証する
	<input type="submit" name="commit" value="Save">
expect(page) have_button 'Save'

<a href="/users/sign_up">会員登録はこちら</a>
expect(page).to have_link '会員登録はこちら'

<div class="field_with_errors">
 <input type="texy" value="" name="blog[title]" id="blog_title">
</div>

visit new_blog_path
click_on 'Create Blog'
expect(page).to have_css '.field_with_errors'

<label for="blog_title">タイトル</label>
<input type="text" value="あけましておめでとうございます。" name="blog[title]" id="blog_title">

click_link 'Edit'
expect(page).to have_field 'タイトル', with: '明けましておめでとうございます。'

チェックボックスがチェックされていること/いないことを検証する

<label>
    <input type="checkbox" name="mailmagazine" id="mailmagazine" value="yes" checked="checked">
    メールマガジンを購読する
</label>

expect(page).to have_checked_field('メールマガジンを購読する')
expect(page).to have_unchecked_field('メールマガジンを購読する')
expect(page).to have_field('メールマガジンを購読する')

#セレクトボックスで特定の項目が選択されていることを検証する
<label for="japanese_calendar">和暦</label>
<select name="japanese_calendar" id="japanese_calendar">
  <option value="明治">明治</option>
  <option value="大正">大正</option>
  <option selected="selected" value="昭和">昭和</option>
  <option value="平成">平成</option>
</select>

expect(page).to have_select('和暦', selected: '昭和')

<label for="japanese_calendar">和暦</label>
<select name="japanese_calendar" id="japanese_calendar">
  <option value="明治">明治</option>
  <option value="大正">大正</option>
  <option value="昭和">昭和</option>
  <option value="平成">平成</option>
</select>

expect(page).to have_select('和暦', options: ['明治', '大正', '昭和'])
expect(page).to have_select('和暦', selected: '昭和', options: ['明治', '大正', '昭和', '平成'])

#（応用） セレクトボックスでselectedになっている項目がないことを検証する
within find_field('和暦') do
	all('option').each do |option|
		expect(option['selected']).to be_blank
	end
end

# selected になっていなくても、画面上に表示されている項目のvalueは取得できる
expect(find_field('和暦').value).to eq 'meiji'

<label>
  <input id="user_sex_male" name="user[sex]" type="radio" value="male" checked="checked">
  男性
</label>
<label>
  <input id="user_sex_female" name="user[sex]" type="radio" value="female">
  女性
</label>

#ラジオボタンで特定の項目が選択されていることを検証する

expect(page).to have_checked_field('男性')

#titleタグの文言を検証する
<html>
<head>
<title>My favorite songs</title>

expect(page).to have_title 'My favorite songs'

#「表示されていないこと」や「選択されていないこと」を検証する
expect(page).to_not have_content '秘密のパスワード'

expect(page).to have_no_content 'password'

