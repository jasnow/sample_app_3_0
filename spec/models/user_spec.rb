require 'spec_helper'

describe User, :type => :model do
  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    expect(no_name_user).not_to be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    expect(no_email_user).not_to be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    expect(long_name_user).not_to be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      expect(valid_email_user).to be_valid
    end
  end

  it "should accept invalad email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => :email))
      expect(valid_email_user).not_to be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create(@attr)
    user_with_duplicate_email = User.new(@attr)
    expect(user_with_duplicate_email).not_to be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    expect(user_with_duplicate_email).not_to be_valid
  end

  describe "relationships" do
    before(:each) do
      @user = User.create!(@attr)
      @followed = FactoryBot.create(:user)
    end

    it "should have a relationships method" do
      expect(@user).to respond_to(:relationships)
    end

    it "should have a following method" do
      expect(@user).to respond_to(:following)
    end

    it "should have a following? method" do
      expect(@user).to respond_to(:following?)
    end

    it "should have a follow! method" do
      expect(@user).to respond_to(:follow!)
    end

    it "should follow another user" do
      @user.follow!(@followed)
      expect(@user).to be_following(@followed)
    end

    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      expect(@user.following).to include(@followed)
    end

    it "should have a unfollow! method" do
      expect(@followed).to respond_to(:unfollow!)
    end

    it "should unfollow a user" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      expect(@user).not_to be_following(@followed)
    end

    it "should have a reverse_relationships method" do
      expect(@user).to respond_to(:reverse_relationships)
    end

    it "should have a followers method" do
      expect(@user).to respond_to(:followers)
    end

    it "should include the follower in the followers array" do
      @user.follow!(@followed)
      expect(@followed.followers).to include(@user)
    end
  end

  describe "password validations" do

    it "should require a password" do
      expect(User.new(@attr.merge(:password => "", :password_confirmation => ""))).not_to be_valid
    end

    it "should require a matching password confirmation" do
      expect(User.new(@attr.merge(:password_confirmation => "invalid"))).not_to be_valid
    end

    it "Good: should accept just long enough passwords" do
      pw = "a" * 6
      hash = @attr.merge(:password => pw, :password_confirmation => pw)
      expect(User.new(hash)).to be_valid
    end

    it "Bad: should reject too short passwords" do
      tooshort = "a" * 5
      hash = @attr.merge(:password => tooshort, :password_confirmation => tooshort)
      expect(User.new(hash)).not_to be_valid
    end

    it "Good: should reject almost too long passwords" do
      pw = "a" * 40
      hash = @attr.merge(:password => pw, :password_confirmation => pw)
      expect(User.new(hash)).to be_valid
    end

    it "Bad: should reject too long passwords" do
      toolong = "a" * 41
      hash = @attr.merge(:password => toolong, :password_confirmation => toolong)
      expect(User.new(hash)).not_to be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attributes" do
      expect(@user).to respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      expect(@user.encrypted_password).not_to be_blank
    end

    it "should be true if the passwords match" do
      expect(@user.has_password?(@attr[:password])).to be_truthy
    end

    it "should be false if the passwords do not match" do
      expect(@user.has_password?("invalid")).to be_falsey
    end
  end

  describe "password authenticate" do
    it "should return nil on email/password mismatch" do
      wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
      expect(wrong_password_user).to be_nil
    end

    it "should return nil for an email with no user" do
      nonexistent_password_user = User.authenticate("bar@foo.com", @attr[:password])
      expect(nonexistent_password_user).to be_nil
    end

    it "should return the user on email/password match" do
      wrong_password_user = User.authenticate(@attr[:email], @attr[:password])
      expect(wrong_password_user).to eq(@user)
    end
  end

  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      expect(@user).to respond_to(:admin)
    end

    it "should not be an admin by default" do
      expect(@user).not_to be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin) # true <=> false
      expect(@user).to be_admin
    end
  end

  describe "micropost associations" do
    before(:each) do
      @user = User.create(@attr)
      @mp1 = FactoryBot.create(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = FactoryBot.create(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      expect(@user).to respond_to(:microposts)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts).to eq([@mp2, @mp1])
    end

    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        expect(Micropost.find_by_id(micropost.id)).to be_nil
      end
#      lambda do # page 422
#        Micropost.find(micropost.id)
#      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    describe "status feed" do

      it "should have a feed" do
        expect(@user).to respond_to(:feed)
      end

      it "should include the user's microposts" do
        expect(@user.feed).to include(@mp1)
        expect(@user.feed).to include(@mp2)
      end

      it "should not include a different user's microposts" do
        mp3 = FactoryBot.create(:micropost,
                      :user => FactoryBot.create(:user, :email => FactoryBot.generate(:email)))
        expect(@user.feed).not_to include(mp3)
      end

      it "should include the microposts of followed users" do
        followed = FactoryBot.create(:user, :email => FactoryBot.generate(:email))
        mp3 = FactoryBot.create(:micropost, :user => followed)
        @user.follow!(followed)
        expect(@user.feed).to include(mp3)
      end
    end
  end
end
