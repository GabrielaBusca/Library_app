class ContactController < ApplicationController

	def index
		sql_query = "select b.id, b.nume, b.returneaza_adresa() as adresa, b.returneaza_telefoane() as telefoane, b.email  from biblioteca b"
		@libraries = ActiveRecord::Base.connection.exec_query(sql_query).to_a
	end

end
