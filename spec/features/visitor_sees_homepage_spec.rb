# frozen_string_literal: true

require 'rails_helper'

feature 'Visitor sees homepage' do
  it 'displays welcome text' do
    visit root_path

    expect(page).to have_content 'Hello World'
  end
end
