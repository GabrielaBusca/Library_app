class InstancesController < ApplicationController
	helper_method :book

	def new
		book
		@instance = Instance.new
		sql_query = "select b.nume as nume, b.returneaza_adresa() as adresa, b.id as id_biblioteca
						from biblioteca b"
		@libraries = ActiveRecord::Base.connection.exec_query(sql_query).to_a
	end

	def create
		@instance = Instance.new(instance_params)

		@instance.id = Instance.next_id_sequence
		@instance.id_carte = params[:book_id]
		@old_instance = Instance.where("id_biblioteca = #{@instance.id_biblioteca} and 
						id_carte = #{@instance.id_carte}").first
		if @old_instance
			@old_instance.destroy
		end

		respond_to do |format|
	      if @instance.save
	        format.html {redirect_to book_path(params[:book_id]), :notice => "Cartea a fost adaugata cu succes!" }
	      else
	        format.html { render :new }
	      end
	    end
	end

	def book
		@book = Book.find(params[:book_id])
	end

	private
		def instance_params
	      params.require(:instance).permit(:id, :id_carte, :id_biblioteca, :nr_exemplare)
	    end

end
