feature 'List of links' do

  let!(:user) do
  User.create(email: 'james@example.com',
              password: 'password',
              password_confirmation: 'password')
            end
    scenario 'viewing the list on the homepage' do
    sign_in(email: user.email,   password: user.password)
    Link.create(url: 'https://www.reddit.com', title: 'Reddit')

    visit '/links'
    expect(page.status_code).to eq 200
      expect(page).to have_content('www.reddit.com')
    end
  end

# As a time-pressed user
# So that I can save a website
# I would like to add the site's address and title to my bookmark manager

feature 'adding links to the bookmark manager' do
  let!(:user) do
  User.create(email: 'james@example.com',
              password: 'password',
              password_confirmation: 'password')
            end
  scenario 'adding www.bbc.co.uk/news to the bookmark manager' do

    sign_in(email: user.email,   password: user.password)
    visit '/links/new'
    fill_in 'url',   with: 'http://www.bbc.com/'
    fill_in 'title', with: 'BBC Homepage'
    click_button 'Create link'

      expect(current_path).to eq '/links'
      expect(page).to have_content('BBC Homepage')
    end
  end

# As a time-pressed user
# So that I can organise my many links into different categories for ease of search
# I would like to tag links in my bookmark manager

feature 'organise links via tags' do
  scenario 'tagging bbc.co.uk with news tag' do
    visit '/links/new'
    fill_in 'url', with: 'http://www.bbc.com'
    fill_in 'title', with: 'BBC Homepage'
    fill_in 'tags', with: 'news'

    click_button 'Create link'
    link = Link.first
    expect(link.tags.map(&:name)) .to include('news')
  end
end

# As a time-pressed user
# So that I can quickly find links on a particular topic
# I would like to filter links by tag

feature 'filter links by tag' do
  scenario 'filter links by news tag and check via bubbles' do
    visit '/links/new'
    fill_in 'url', with: 'http://www.bbc.com'
    fill_in 'title', with: 'BBC Homepage'
    fill_in 'tags', with: 'news'
    click_button 'Create link'
    visit '/links/new'
    fill_in 'url', with: 'http://www.reddit.com'
    fill_in 'title', with: 'Reddit'
    fill_in 'tags', with: 'entertainment'
    click_button 'Create link'
    visit '/links/new'
    fill_in 'url', with: 'http://www.bubblebutts.com'
    fill_in 'title', with: 'Bubble Butts'
    fill_in 'tags', with: 'bubbles'
    click_button 'Create link'
    visit '/tags/bubbles'
    expect(page).to have_content 'Bubble Butts'
    expect(page).not_to have_content 'BBC Homepage'
    expect(page).not_to have_content 'Reddit'
  end
end

# As a time-pressed user
# So that I can organise my links into different categories for ease of search
# I would like to add tags to the links in my bookmark manager
feature 'add tags to the links' do
  scenario 'adding the news tag to BBC' do
    visit '/links/new'
    fill_in 'url', with: 'http://www.bbc.com'
    fill_in 'title', with: 'BBC Homepage'
    fill_in 'tags', with: 'news sports'
    click_button 'Create link'
    link = Link.first
    expect(link.tags.map(&:name)).to(include 'news') && 'sports'
  end
end

feature 'User sign up' do
  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, james@example.com')
    expect(User.first.email).to eq('james@example.com')
  end
end

feature 'Confirms passwords match' do
  scenario 'james signs in with password' do
    visit '/users/new'
    expect(page.status_code).to eq(200)
    fill_in :email,    with: 'james@example.com'
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'passwood'
    expect { password_mismatch }.to change(User, :count).by(0)
    expect(current_path).to eq '/users'
    expect(page).to have_content 'Password does not match the confirmation'
  end
  scenario 'another password confirmation test' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq '/users'
    expect(page).to have_content 'Password does not match the confirmation'
  end
end

feature 'user cannnot sign up without an email address' do
  scenario 'user tries to sign up without an email address' do
    expect { sign_up(email: ' ') }.not_to change(User, :count)
  end
end

feature 'user cannot sign up without a VALID email address' do
  scenario 'user tries to sign up with an invalid email address' do
    expect { sign_up(email: 'james@examplemail') }.not_to change(User, :count)
  end
end

feature 'user cannot sign up with the same email address twice' do
  scenario 'user james tries to sign up twice with the same address' do
    sign_up
    visit '/'
    expect { sign_up }.to_not change(User, :count)
    expect(page).to have_content('Email is already taken')
  end
end

feature 'User can sign in' do

  let!(:user) do
  User.create(email: 'james@example.com',
              password: 'password',
              password_confirmation: 'password')
            end
  scenario 'user signs in with correct credentials' do
    sign_in(email: user.email,   password: user.password)
    expect(page).to have_content "Welcome, #{user.email}"
  end
end

feature 'User can log out' do
  let!(:user) do
  User.create(email: 'james@example.com',
              password: 'password',
              password_confirmation: 'password')
            end
  scenario 'allows a signed in use to log out' do
    sign_in(email: user.email,   password: user.password)
    click_button 'Log out'
    expect(page).to have_content 'You have been logged out'
    expect(page).not_to have_content('Welcome, james@example.com')
    end
  end

def sign_up(email: 'james@example.com',
            password: 'password',
            password_confirmation: 'password')
  visit '/users/new'
  expect(page.status_code).to eq(200)
  fill_in :email,    with: email
  fill_in :password, with: password
  fill_in :password_confirmation, with: password_confirmation
  click_button 'Sign up'
end

def sign_in(email:, password:)
  visit '/sessions/new'
  fill_in :email, with: email
  fill_in :password, with: password
  click_button 'Sign in'
end

def password_mismatch
  visit '/users/new'
  expect(page.status_code).to eq(200)
  fill_in :email,    with: 'james@example.com'
  fill_in :password, with: 'password'
  fill_in :password_confirmation, with: 'passwood'
  click_button 'Sign up'
end
