require 'spec_helper'
require 'capybara/rspec'

describe 'Exam View', type: :system do
  it 'carrega a página inicial' do
    visit '/'
    expect(page).to have_content 'EXAMES'
  end

  it 'mostra a lista de exames' do
    visit '/'
    expect(page).to have_selector('table tbody tr', count: 10)
  end
end
