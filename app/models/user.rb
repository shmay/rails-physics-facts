class User < ActiveRecord::Base
  before_save { self.email = email.downcase if email }
  validates :username, presence: true, length: { maximum: 50 }

  has_many :votes, dependent: :destroy
  has_many :tags
  has_many :taggings, through: :tags

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, length:{ minimum: 6 }, allow_blank:true

  has_secure_password

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    # unless user
    #     user = User.create(name: data["name"],
    #        email: data["email"],
    #        password: Devise.friendly_token[0,20]
    #     )
    # end
    user
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end


  private
  
  def friendly_token
    SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz')
  end
end
