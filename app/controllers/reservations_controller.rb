class ReservationsController < ApplicationController

	helper_method :user, :library, :book

	def create
		reservation = Reservation.new
		reservation.id = Reservation.next_id_sequence
		reservation.id_biblioteca = params[:library_id]
		reservation.id_carte = params[:book_id]
		reservation.id_user = current_user.id
		reservation.data_rezervare = Time.now
		respond_to do |format|
	      if reservation.save
	        format.html {redirect_to :back, :notice => "Rezervarea a fost facuta cu succes" }
	      else
	        format.html { render :back }
	      end
	    end

	end

	def new_borrow
		@reservation = Reservation.find(params[:reservation_id])
		@borrow = Borrow.new
	end

	def create_borrow 
		reservation = Reservation.find(params[:reservation_id])
		@borrow = Borrow.new(borrow_params)
		@borrow.id = Borrow.next_id_sequence
		@borrow.data_imprumut = Time.now
		@borrow.id_user = reservation.id_user.to_i
		@borrow.id_biblioteca = reservation.id_biblioteca.to_i
		@borrow.id_carte = reservation.id_carte.to_i
		respond_to do |format|
	      if @borrow.save
	        format.html {redirect_to user_path(@borrow.id_user), :notice => "Imprumutul a fost facut cu succes" }
	      	reservation.destroy
	      else
	        format.html { render :new_borrow }
	      end
	    end
	end


	def user
		User.find(@reservation.id_user)
	end

	def destroy
		reservation = Reservation.find(params[:id]).destroy
		redirect_to :back
	end

	def book
		Book.find(@reservation.id_carte)
	end

	def library
		sql_query = "select b.nume, b.id, b.returneaza_adresa() as adresa, b.returneaza_telefoane() as telefoane 
					 from biblioteca b where id = " + @reservation.id_biblioteca.to_s
		ActiveRecord::Base.connection.exec_query(sql_query).to_a.first
	end

	private

		def borrow_params
	      params.require(:borrow).permit(:id, :id_user, :id_carte, :data_imprumut, 
	      		:data_returnare, :data_inapoiere, :id_biblioteca )
	    end

		def reservation_params
	      params.require(:reservation).permit(:id, :id_user, :id_carte, :id_biblioteca, 
	      				 :data_rezervare )
	    end

end
