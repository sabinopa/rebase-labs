require 'spec_helper'
require 'capybara/rspec'

describe 'Exam Details', type: :system do
  it 'navega para a página de detalhes do exame ao clicar no link' do
    visit '/'
    click_link 'IQCZ17' # Supondo que IQCZ17 seja um token na lista

    expect(page).to have_content('Detalhes do Exame')
    expect(page).to have_content('IQCZ17')
  end
end
