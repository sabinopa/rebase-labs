require 'spec_helper'
require 'capybara/rspec'

describe 'Search for Exam', type: :system do
  it 'encontra o exame pelo token' do
    visit '/'
    fill_in 'search-token', with: 'IQCZ17'
    click_button 'Buscar'

    expect(page).to have_content('Exame encontrado')
    expect(page).to have_content('IQCZ17')
  end

  it 'exibe mensagem de erro para token inválido' do
    visit '/'
    fill_in 'search-token', with: 'INVALIDO'
    click_button 'Buscar'

    expect(page).to have_content('Exame não encontrado')
  end
end
