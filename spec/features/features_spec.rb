feature 'List of links' do
  scenario 'viewing the list on the homepage' do
    Link.create(url: 'https://www.reddit.com', title: 'Reddit')

    visit '/links'
    expect(page.status_code).to eq 200

    within 'ul#links' do
      expect(page).to have_content('www.reddit.com')
    end
  end
end

# As a time-pressed user
#So that I can save a website
# I would like to add the site's address and title to my bookmark manager

feature  'adding links to the bookmark manager' do
  scenario 'adding www.bbc.co.uk/news to the bookmark manager' do
  visit '/links/new'
   fill_in 'url',   with: 'http://www.bbc.com/'
   fill_in 'title', with: 'BBC Homepage'
   click_button 'Create link'

   expect(current_path).to eq '/links'

   within 'ul#links' do
   expect(page).to have_content('BBC Homepage')
  end
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
  expect(link.tags.map(&:name)).to include 'news' and 'sports'
  end
end
