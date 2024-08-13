require 'spec_helper'
require 'capybara/rspec'

describe 'Pagination', type: :system do

  it 'avança para a próxima página' do
    visit '/'
    click_link 'Next'
    expect(page).to have_selector('table tbody tr')
    expect(page).to have_content('Página 2')
  end

  it 'retorna para a página anterior' do
    visit '/'
    click_link 'Next'
    click_link 'Previous'
    expect(page).to have_selector('table tbody tr')
    expect(page).to have_content('Página 1')
  end
end
