class ApartmentsController < ApplicationController
  def index
		@pages = (params[:pages] || 1).to_i
		@sort = params[:sort] || "price_asc"

		if params[:search].present?

			@apartments = OlxScraperService.new(pages: @pages).call
			
			@total = @apartments.count

			@apartments = 
			case @sort
			when 'price_asc' then @apartments.sort_by {|apt| apt[:price].to_i}				
			when 'price_desc' then @apartments.sort_by {|apt| apt[:price].to_i}.reverse
			when 'title' then @apartments.sort_by {|apt| apt[:price]}
			else @apartments
			end	
		else
			@apartments = []
			@total = 0 
		end
	end
end
