class AuthorsController < ApplicationController

	helper_method :author

	def index 
		sql_query = "select a.id as id_autor, MAX(a.returneaza_nume_intreg()) as nume_autor, count(*) as numar_carti
					from autor a, carte c
					where c.id_autor = a.id
					group by a.id"
		@authors = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@authors = @authors.paginate(:page => params[:page], :per_page => 10)
	end

	def show
		sql_query = "select c.id, c.titlu, c.cod_isbn, c.data_adaugare, c.data_aparitie, 
					      d.nume as domeniu, a.returneaza_nume_intreg() as nume_autor, e.nume as editura,
					      c.imagine_coperta, a.descriere as descriere_autor
					from carte c, domeniu d, editura e, autor a
					where c.id_autor = a.id and 
					c.id_editura = e.id and 
					c.id_domeniu = d.id  and 
					id_autor = " + params[:id]
		@books = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@books = @books.paginate(:page => params[:page], :per_page => 5)
	end

	def author
		@author = Author.find(params[:id])
	end

end
