class BorrowsController < ApplicationController

	def new
		@borrow = Borrow.new
		@users = User.where("user_type is null")

		sql_query = "select e.*, b.nume as biblioteca, c.titlu, a.returneaza_nume_intreg() as autor, e.nume as editura, d.nume as domeniu, c.cod_isbn
					from exemplar ex, biblioteca b, carte c, autor a, domeniu d, editura e
					where ex.id_carte = c.id
					and ex.id_biblioteca = b.id
					and c.id_autor = a.id
					and c.id_editura = e.id
					and c.id_domeniu = d.id
					order by c.id"
		@books = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@books = @books.paginate(:page => params[:page], :per_page => 5)
	end

	def create
		@borrow = Borrow.new(borrow_params)
		@borrow.id = Borrow.next_id_sequence
		respond_to do |format|
	      if @borrow.save
	        format.html {redirect_to new_borrow_path, :notice => "Imprumutul a fost facut cu succes" }
	      else
	        format.html { render :new }
	      end
	    end
	end

	private
		def borrow_params
	      params.require(:borrow).permit(:id, :id_user, :id_carte, :data_imprumut, 
	      		:data_returnare, :data_inapoiere )
	    end

end
