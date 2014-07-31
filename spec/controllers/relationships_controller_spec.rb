require 'spec_helper'

describe RelationshipsController, :type => :controller do

  describe "access control" do

    it "should require signin for create" do
      post :create
      expect(response).to redirect_to(signin_path)
    end

    it "should require signin for destroy" do
      delete :destroy, :id => 1
      expect(response).to redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(FactoryGirl.create(:user))
      @followed = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
    end

    it "should create a relationship" do
      expect do
        post :create, :relationship => { :followed_id => @followed }
        expect(response).to be_redirect
      end.to change(Relationship, :count).by(1)
    end

    it "should create a relationship using Ajax" do
      expect do
        xhr :post, :create, :relationship => { :followed_id => @followed }
        expect(response).to be_success
      end.to change(Relationship, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = test_sign_in(FactoryGirl.create(:user))
      @followed = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
      @user.follow!(@followed)
      @relationship = @user.relationships.find_by_followed_id(@followed)
    end

    it "should destroy a relationship" do
      expect do
        delete :destroy, :id => @relationship
        expect(response).to be_redirect
      end.to change(Relationship, :count).by(-1)
    end

    it "should destroy a relationship using Ajax" do
      expect do
        xhr :delete, :destroy, :id => @relationship
        expect(response).to be_success
      end.to change(Relationship, :count).by(-1)
    end
  end
end
