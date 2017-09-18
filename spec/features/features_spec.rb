feature 'List of links' do
  scenario 'viewing the list on the homepage' do
    expect(page).to have_content '1. Pornhub.com'
  end
end
