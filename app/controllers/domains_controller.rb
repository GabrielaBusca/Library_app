class DomainsController < ApplicationController

	helper_method :domain

	def index
		sql_query = "select MAX(c.data_adaugare) as data_adaugare, d.nume as domeniu, titlu,imagine_coperta, 
							data_aparitie, id_domeniu
					from carte c, domeniu d
					where c.data_adaugare = ( select MAX(data_adaugare)
					                           from carte ca
					                           where ca.id_domeniu = c.id_domeniu )
					and d.id = c.id_domeniu
					group by id_domeniu, d.nume, titlu, imagine_coperta, data_aparitie, id_domeniu
					order by 1"
		@domains = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@domains = @domains.paginate(:page => params[:page], :per_page => 6)

	end

	def show
		sql_query = "select c.id, c.titlu, c.cod_isbn, c.data_adaugare, c.data_aparitie, a.returneaza_nume_intreg() as autor,
					       e.nume as editura, c.imagine_coperta
					from carte c, autor a, editura e 
					where id_domeniu = " + params[:id] + "
					and c.id_autor = a.id
					and c.id_editura = e.id"
		@books = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@books = @books.paginate(:page => params[:page], :per_page => 5)
	end

	def domain
		@domain ||= Domain.find(params[:id])
	end

end
