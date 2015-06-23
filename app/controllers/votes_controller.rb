class VotesController < ApplicationController

	def index
		sql_query = "select decode(avg(vot), null, 0, avg(vot) ) as vot
					from vot 
					where id_carte = " + params[:book_id].to_s
		@vote = ActiveRecord::Base.connection.exec_query(sql_query).to_a.first
		render :json => { :vote => @vote["vot"] }
	end

	def create
	  if current_user.user_type then
	  	render :json => { :message => "Nu sunteti autorizat sa votati !" }
	  else
	  	old_vote = Vote.where("id_user = #{current_user.id} and id_carte = #{params[:book_id]}")
	  	if old_vote.length != 0 then
	  		render :json => { :message => "Ati votat deja !" }
	  	else
		  	vote = Vote.new
		  	vote.id = Vote.next_id_sequence
		  	vote.id_carte = params[:book_id].to_i
		  	vote.id_user = current_user.id
		  	vote.vot = params[:vote_number]
		  	if vote.save then
		  		render :json => { :message => "Votul a fost adaugat cu succes !" }
		  	else
		  		render :json => { :message => "A aparut o problema, va rugam reincercati!" }
		  	end
		  end
	  end
	end

end
