require "rails_helper"

describe "Visitor sees homepage", type: :feature, js: true do
  it "displays welcome text" do
    visit root_path

    expect(page).to have_content "Yay!"
  end
end
