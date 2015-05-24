class WelcomeController < ApplicationController

	def index
=begin
		@employees = ActiveRecord::Base.connection.exec_query("select p.afiseaza() as short_description from carte p").to_a
		print @employees
=end

	end

end
