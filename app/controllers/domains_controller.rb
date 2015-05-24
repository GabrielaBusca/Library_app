class DomainsController < ApplicationController

	helper_method :get_domain_books

	def index
		@domains = Domain.all
	end

	def get_domain_books domain_id
		sql_query = "select * 
					from ( select * from carte c 
					       where id_domeniu = " + domain_id.to_s + "
					       order by data_aparitie desc )
					where rownum < 2"
		return ActiveRecord::Base.connection.exec_query(sql_query).to_a
	end

end
