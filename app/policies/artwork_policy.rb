class ArtworkPolicy < ApplicationPolicy
	attr_reader :current_user, :model

	def initialize(current_user, model)
		@current_user = current_user
		@user = model
	end

	def new
		true 
	end

	def create
		@current_user.artist? || @current_user.admin? 
	end

	def edit
		@current_user.artist? || @current_user.admin? 
	end

	def update
		@current_user.artist? || @current_user.admin? 
	end

	def destroy
		@current_user.admin? 
	end

	def index?
		true 
	end

	def show?
		true 
	end

end