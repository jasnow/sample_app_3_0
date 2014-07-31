require 'spec_helper'

describe "FriendlyForwardings", :type => :request do

  describe "GET /friendly_forwardings" do
    it "should forward to the requested page after signin" do
      user = FactoryGirl.create(:user)
      visit edit_user_path(user)
      fill_in :email,    :with => user.email
      fill_in :password, :with => user.password
      click_button
      expect(response).to render_template('users/edit')

      visit signout_path
      visit signin_path
      fill_in :email,    :with => user.email
      fill_in :password, :with => user.password
      click_button
      expect(response).to render_template('users/show')
    end
  end
end
