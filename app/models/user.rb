class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :cardview, :avatar
  
  has_attached_file :avatar, :styles => {:asd => "250x250px", :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"  
  # validates :first_name, :presence => true
  # validates :last_name, :presence => true
  # validates :email, :presence => true, :uniqueness => true
  # validates :password, :presence => true, :on => :create

  has_many :assignments
  has_many :events, through: :assignments
   
  # validates_attachment :avatar, :presence => true,
  # :content_type => { :content_type => "image/jpg" },
  # :size => { :in => 0..10.kilobytes }

	def name
		"#{first_name} #{last_name}"
	end

  def firstname
    "#{first_name}"
  end

  def available_events
    x = self.events
    if x.present?
      Event.where("id NOT IN (?)", x)
    else
      Event.all
    end
  end

  def self.get_random_user(number_of_cards)
    # find(:all).sample(1)
    User.order("random()").first(number_of_cards.to_i)
  end

  def self.from_omniauth(auth)
    user = where(auth.slice("provider", "uid")).first_or_initialize

    # raise auth.info.inspect

    %w(first_name last_name email).each do |s|
      user.send("#{s}=".to_sym, auth.info.send(s.to_sym))
    end

    user.first_name = auth.info.first_name
    user.picture_url = auth.info.image
    user.token = auth.credentials.token
    user.secret = auth.credentials.secret
    user.save!

    return user

    # user.first_name = auth.info.first_name
    # user.last_name = auth.info.last_name
    # user.picture_url = auth.info.picture_url
    # user.email = auth.info.email

    # || create_from_omniauth(auth)
  end
  
  # def self.create_from_omniauth(auth)
  #   raise "wut"
  #   raise auth.info.inspect
  #   create! do |user|
  #     user.provider = auth["provider"]
  #     user.uid = auth["uid"]
  #     user.first_name = auth.info.first_name
  #     user.last_name = auth.info.last_name
  #     user.picture_url = auth.info.picture_url
  #     user.email = auth.info.email
  #     user.token = auth.credentials.token
  #     user.secret = auth.credentials.secret
  #   end
  # end

end


# what raise.info.inspec returns:
# # <OmniAuth::AuthHash::InfoHash 
# description="Financial Analyst - Canadian Pension Plan Investment Board" 
# email="christine.jinae@gmail.com" 
# first_name="Christine J. Lee," 
# image="http://m3.licdn.com/mpr/mprx/0_TLYPQjyyVDFUz8dqT322QxDg4HrNB8dqiGE2Qxj8FDXkeXONDimxH0Wm9QKwqbH486ySW47LtwyO" 
# last_name="CA" 
# location=#<OmniAuth::AuthHash 
# country=#<OmniAuth::AuthHash code="ca"> 
# name="Toronto, Canada Area"> 
# name="Christine J. Lee, CA" 
# nickname="Christine J. Lee, CA" 
# urls=#<OmniAuth::AuthHash public_profile="http://www.linkedin.com/pub/christine-j-lee-ca/24/413/735">
# >
