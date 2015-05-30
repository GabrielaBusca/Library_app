class PublishersController < ApplicationController

	helper_method :publisher

	def index
		sql_query = "select MAX(c.data_adaugare) as data_adaugare, nume as editura, titlu, imagine_coperta, 
							data_aparitie, id_editura
					from carte c, editura e
					where c.data_adaugare = ( select MAX(data_adaugare)
					                           from carte ca
					                           where ca.id_editura = c.id_editura )
					and e.id = c.id_editura
					group by id_editura, nume, titlu, imagine_coperta, data_aparitie, id_editura
					order by 2"
		@publishers = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@publishers = @publishers.paginate(:page => params[:page], :per_page => 6)
	end

	def show
		sql_query = "select c.id, c.titlu, c.cod_isbn, c.data_adaugare, c.data_aparitie, a.returneaza_nume_intreg() as autor,
						       d.nume as domeniu, c.descriere, c.imagine_coperta
						from carte c, autor a, domeniu d 
						where id_editura = " + params[:id] + "
						and c.id_autor = a.id
						and c.id_domeniu = d.id"
		@books = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		@books = @books.paginate(:page => params[:page], :per_page => 5)
	end

	def publisher 
		@publisher ||= Publisher.find(params[:id])
	end

end
