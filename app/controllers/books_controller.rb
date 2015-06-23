class BooksController < ApplicationController

	def index
		sql_query = "select c.*, d.nume as domeniu, e.nume as editura, a.returneaza_nume_intreg() as autor
					from carte c, editura e, domeniu d, autor a
					where c.id_autor = a.id and 
					c.id_editura = e.id and 
					c.id_domeniu = d.id"
		if params[:title] && params[:title] != "" then
			sql_query += " and titlu like '%#{params[:title]}%' "
		end
		if params[:publisher] && params[:publisher] != "" then
			sql_query += " and e.id = '#{params[:publisher]}' "
		end
		if params[:domain] && params[:domain] != "" then
			sql_query += " and d.id = '#{params[:domain]}' "
		end
		if params[:author] && params[:author] != "" then
			sql_query += " and a.id = '#{params[:author]}' "
		end
		sql_query += " order by c.data_aparitie desc"
		@books = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@books = @books.paginate(:page => params[:page], :per_page => 5)
		
		@domains = Domain.all
		@publishers = Publisher.all
		@authors = Author.all
	end

	def news
		sql_query = "select top.*
					from ( SELECT c.*, d.nume AS domeniu, e.nume AS editura, a.returneaza_nume_intreg() AS autor
					        FROM carte c, editura e, domeniu d, autor a
					        WHERE c.id_autor = a.id AND
					        c.id_editura = e.id AND
					        c.id_domeniu = d.id 
					        ORDER BY c.data_aparitie DESC, c.data_adaugare DESC) top
					where rownum < 10"
		@news_books = ActiveRecord::Base.connection.exec_query(sql_query).to_a
	end

	def new
		@book = Book.new
		@domains = Domain.all
		@publishers = Publisher.all
		@authors = Author.all
	end

	def create
		@book = Book.new(book_params)
		@book.id = Book.next_id_sequence
		respond_to do |format|
	      if @book.save
	        format.html {redirect_to new_book_path, :notice => "Cartea a fost adaugata cu succes!" }
	      else
	        format.json { render json: @book.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def edit
		@book = Book.find(params[:id])
		@domains = Domain.all
		@publishers = Publisher.all
		@authors = Author.all
	end

	def update
		@book = Book.find(params[:id])
    	if @book.update(book_params)
      		redirect_to @book
    	else
      		render 'edit'
    	end
	end

	def destroy
		@book = Book.find(params[:id]).destroy
		redirect_to books_path
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

		sql_query = "select c.nr_inchirieri(b.id) as imprumuturi, c.nr_rezervari(b.id) as rezervari, 
					c.nr_total(b.id) as total, b.id as id_biblioteca, b.returneaza_adresa() as adresa, b.nume as nume
					from carte c, biblioteca b
					where c.id = " + params[:id]
		@details = ActiveRecord::Base.connection.exec_query(sql_query).to_a

		if user_signed_in? and current_user.user_type == 'employee' then
			sql_query = "select i.*, s.name as nume, s.surname as prenume, b.nume as biblioteca 
						from imprumut i, users s, biblioteca b
						where data_returnare is null
						and id_carte = " +params[:id].to_s+" and
						i.id_user  = s.id and
						b.id = i.id_biblioteca"
			@borrowed_books = ActiveRecord::Base.connection.exec_query(sql_query).to_a

			sql_query = "select i.*, s.name as nume, s.surname as prenume, b.nume as biblioteca 
						from rezervare i, users s, biblioteca b
						where id_carte = " +params[:id].to_s+" and
						i.id_user  = s.id and
						b.id = i.id_biblioteca"
			@reserved_books = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		end
	end

	private
		def book_params
	      params.require(:book).permit(:id, :titlu, :cod_isbn, :data_adaugare, :data_aparitie, 
	      	:id_domeniu, :id_autor, :id_editura, :descriere, :imagine_coperta)
	    end

end
