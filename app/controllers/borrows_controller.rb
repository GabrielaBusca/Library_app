class BorrowsController < ApplicationController

	def new
		@borrow = Borrow.new
		@users = User.where("user_type is null")

		sql_query = "select e.*, b.nume as nume, b.returneaza_adresa() as adresa, b.id as id_biblioteca
						from exemplar e, biblioteca b
						where id_carte = " + params[:book_id] + "
						and e.id_biblioteca = b.id
						and nr_exemplare <> ( select count(*)
						                      from imprumut 
						                      where id_carte = " + params[:book_id] + " and
						                      data_returnare is null 
						                      and id_biblioteca = e.id_biblioteca) + 
						                      ( select count(*)
						                      from rezervare 
						                      where id_carte = " + params[:book_id] + "
						                      and id_biblioteca = e.id_biblioteca
                      )"
		@libraries = ActiveRecord::Base.connection.exec_query(sql_query).to_a
	end

	def create
		@borrow = Borrow.new(borrow_params)
		@borrow.id = Borrow.next_id_sequence
		@borrow.data_imprumut = Time.now
		@borrow.id_carte = params[:book_id].to_i
		respond_to do |format|
	      if @borrow.save
	        format.html {redirect_to book_path(params[:book_id]), :notice => "Imprumutul a fost facut cu succes" }
	      else
	        format.html { render :new }
	      end
	    end
	end

	def update
		@borrow = Borrow.find(params[:id])
		@borrow.data_returnare = Time.now
		if @borrow.save then
			redirect_to :back
		end
	end

	def extension 
		borrow = Borrow.find(params[:id])
		borrow.data_inapoiere = borrow.data_inapoiere + 7.days

		extensions = Extension.where("id_imprumut = #{params[:id]}")
		extensions.each do |extension|
			extension.destroy
		end

		if borrow.save then
			redirect_to :back
		end
	end

	def borrow
		Borrow.find(params[:id])
	end

	private
		def borrow_params
	      params.require(:borrow).permit(:id, :id_user, :id_carte, :data_imprumut, 
	      		:data_returnare, :data_inapoiere, :id_biblioteca )
	    end

end
