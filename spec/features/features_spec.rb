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
