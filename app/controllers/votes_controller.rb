class VotesController < ApplicationController

	def create
	  #@sub_comment = SubComment.new params['subcomment']
	  #if @sub_comment.save
	    render :json => { :vote => params[:vote] } # send back any data if necessary
	  #else
	    #render :json => { }, :status => 500
	  #end
	end

end
