class VenuesController < ApplicationController 
	before_action :authenticate_user!, only: :new
	# after_action :verify_authorized
	
	def new
		@venue = Venue.new
		# authorize User
	end

	def create 
		@venue = Venue.new(venue_params)
		@venue.user = current_user
		# authorize User
		if @venue.save
			flash[:notice] = "Venue was successfully registered"
			redirect_to venue_path(@venue)
		else
			render 'new'
		end
	end

	def edit
		# authorize User
		@venue = Venue.find(params[:id])
	end

	def update
		@venue = Venue.find(params[:id])
		# authorize User
		raise "not authorized" unless UserPolicy.new(current_user, @venue).update?
		if @venue.update(venue_params)
			flash[:notice] = "Venue details were successfully updated"
			redirect_to venue_path(@venue)
		else
			render 'edit'
		end
	end

	def show 
		@venue = Venue.find(params[:id])
	end

	def index
		@venues = Venue.all
	end

	def destroy
		@venue = Venue.find(params[:id])
		# authorize User
		@venue.destroy
		flash[:notice] = "Venue was successfully deleted"
		redirect_to venues_path
	end

private 
	def venue_params
		params.require(:venue).permit(:name, :description, :address, :phone_number, :image)
	end

end