class User < ApplicationRecord
	has_many :artworks 
	has_many :venues 

	has_many :friendships
	has_many :friends, :through => :friendships

    has_many :conversations
    has_many :notifications, foreign_key: :recipient_id

	enum role: [:admin, :artist, :venue_owner, :collector, :private_dealer, :educator, :art_student, :media]
	after_initialize :set_default_role, :if => :new_record?

	def set_default_role 
		self.role ||= :artist
	end

	has_and_belongs_to_many :roles

  	devise :database_authenticatable, :registerable, 
           :recoverable, :rememberable, :trackable, :validatable

    acts_as_messageable 

	def mailboxer_email(object)
		self.email
	end

	has_attached_file :profile, styles: { thumb: "150x150#" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :profile, content_type: /\Aimage\/.*\z/
	# validates_attachment_content_type :profile, :content_type => ["jpg", "jpeg", "png", "gif"]

	has_many :likes
    has_many :liked_artworks, :through => :likes, :source => :artwork

	def likes?(artwork)
		artwork.likes.where(user_id: id).any?
	end

  	def role?(role)
      return !!self.roles.find_by_name(role.to_s.camelize)
  	end

    def not_friends_with?(friend_id)
    	friendships.where(friend_id: friend_id).count < 1 
    end

    def except_current_user(users)
    	users.reject { |user| user.id == self.id }
    end

    def self.search(param)
    	return User.none if param.blank?

    	# param.strip!
    	(city_matches(param) + country_matches(param)).uniq
    end

    def self.name_matches(param)
    	matches('name', param)
    end

    def self.email_matches(param)
    	matches('email', param)
    end

    def self.city_matches(param)
        matches('city', param)
    end

    def self.country_matches(param)
        matches('country', param)
    end

    def self.matches(field_name, param)
    	where("lower(#{field_name}) like ?", "%#{param}%")
    end
end
