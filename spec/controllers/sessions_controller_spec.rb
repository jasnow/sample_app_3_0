require 'spec_helper'

describe SessionsController, :type => :controller do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      expect(response).to be_success
    end

    it "should have the right title" do
      get :new
      expect(response).to have_selector('title', :content => "Sign in")
    end
  end

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        @attr = { :email => "", :password => "" }
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        expect(response).to render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        expect(response).to have_selector('title', :content => "Sign in")
      end

      it "should have an error message" do
        post :create, :session => @attr
        expect(flash.now[:error]).to match(/invalid/i)
      end
    end

    describe "success" do
      before(:each) do
        @user = FactoryBot.create(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should sign the user in" do
        post :create, :session => @attr
        expect(controller.current_user).to eq(@user)
        expect(controller).to be_signed_in
      end

      it "should redirect to the user show page" do
        post :create, :session => @attr
        expect(response).to redirect_to(user_path(@user))
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "should sign a user out" do
      test_sign_in(FactoryBot.create(:user))
      delete :destroy
      expect(controller).not_to be_signed_in
      expect(response).to redirect_to(root_path)
    end
  end
end
