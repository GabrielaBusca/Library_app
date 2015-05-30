class BooksController < ApplicationController

	helper_method :instances

	def index
		sql_query = "select c.*, d.nume as domeniu, e.nume as editura, a.returneaza_nume_intreg() as autor
					from carte c, editura e, domeniu d, autor a
					where c.id_autor = a.id and 
					c.id_editura = e.id and 
					c.id_domeniu = d.id
					order by c.data_aparitie desc"
		@books = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@books = @books.paginate(:page => params[:page], :per_page => 5)
		@domains = Domain.all
		@publishers = Publisher.all
	end

	def new
		@book = Book.new
		@domains = Domain.all
		@publishers = Publisher.all
		@authors = Author.all
	end

	def create
		@book = Book.new(book_params)
		print book_params
		respond_to do |format|
	      if @book.save
	        format.html {redirect_to new_book_path, :notice => "Cartea a fost adaugata cu succes!" }
	      else
	        format.json { render json: @book.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def show 
		sql_query = "select c.id, c.titlu, c.cod_isbn, c.data_adaugare, c.data_aparitie, d.nume as domeniu, a.returneaza_nume_intreg() as autor, e.nume as editura,
					      c.imagine_coperta, c.descriere
					from carte c, editura e, domeniu d, autor a
					where c.id_autor = a.id and 
					c.id_editura = e.id and 
					c.id_domeniu = d.id  and 
					c.id = " + params[:id]
		@book = ActiveRecord::Base.connection.exec_query(sql_query).to_a.first
	end

	def instances
		sql_query = "select b.nume as nume, b.returneaza_adresa() as adresa, e.nr_exemplare as exemplare, id_carte
					from biblioteca b, exemplar e
					where b.id = e.id_biblioteca
					and e.id_carte = " + params[:id]
		ActiveRecord::Base.connection.exec_query(sql_query).to_a
	end

	private
		def book_params
	      params.require(:book).permit(:id, :titlu, :cod_isbn, :data_adaugare, :data_aparitie, :id_domeniu, :id_autor, :id_editura, :descriere, :imagine_coperta)
	    end

end
