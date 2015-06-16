class LibrariesController < ApplicationController

	helper_method :library

	def index
		sql_query = "select b.id, b.nume, b.returneaza_adresa() as adresa, b.returneaza_telefoane() as telefoane, b.email
					from biblioteca b"
		@libraries = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@libraries = @libraries.paginate(:page => params[:page], :per_page => 5)
	end

	def show
		sql_query = "select c.*, d.nume as domeniu, e.nume as editura, a.returneaza_nume_intreg() as autor, e.NR_EXEMPLARE
					from carte c, editura e, domeniu d, autor a, exemplar e, biblioteca b 
					where c.id_autor = a.id and 
					c.id_editura = e.id and 
					c.id_domeniu = d.id and
          			e.id_carte = c.id and 
          			e.id_biblioteca = b.id and
					e.id_biblioteca = " + params[:id] + "
					order by c.data_aparitie desc"
		@books = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@books = @books.paginate(:page => params[:page], :per_page => 5)
	end

	def library
		@library = Library.find(params[:id])
	end

end
