class UsersController < ApplicationController

	helper_method :user, :prelungire, :user_extension

	def index
		@users = User.where("user_type is null")
		@users = @users.paginate(:page => params[:page], :per_page => 5)
	end

	def show
		if current_user.user_type == 'employee' then
			sql_query = "select i.*, c.titlu as carte, c.id as id_carte, b.nume as biblioteca
						from imprumut i, carte c, biblioteca b
						where i.id_carte = c.id
						and b.id = i.id_biblioteca
						and data_returnare is null
						and i.id_user = " + params[:id]
			@books = ActiveRecord::Base.connection.exec_query(sql_query).to_a

			sql_query = "select r.*, c.titlu as carte, c.id as id_carte, b.nume as biblioteca
						from rezervare r, carte c, biblioteca b
						where r.id_carte = c.id
						and b.id = r.id_biblioteca
						and r.id_user = " + params[:id]
			@reserved_books = ActiveRecord::Base.connection.exec_query(sql_query).to_a

			sql_query = "select i.*, c.titlu as carte, c.id as id_carte, b.nume as biblioteca
						from imprumut i, carte c, biblioteca b
						where i.id_carte = c.id
						and b.id = i.id_biblioteca
						and data_returnare is not null
						and i.id_user = " + params[:id]
			@history_books = ActiveRecord::Base.connection.exec_query(sql_query).to_a

		else 
			sql_query = "select i.*, c.titlu as carte, c.id as id_carte, b.nume as biblioteca
						from imprumut i, carte c, biblioteca b
						where i.id_carte = c.id
						and b.id = i.id_biblioteca
						and data_returnare is null
						and i.id_user = " + current_user.id.to_s
			@books = ActiveRecord::Base.connection.exec_query(sql_query).to_a

			sql_query = "select r.*, c.titlu as carte, c.id as id_carte, b.nume as biblioteca
						from rezervare r, carte c, biblioteca b
						where r.id_carte = c.id
						and b.id = r.id_biblioteca
						and r.id_user = " + current_user.id.to_s
			@reserved_books = ActiveRecord::Base.connection.exec_query(sql_query).to_a
		end
	end

	def user
		User.find(params[:id])
	end

	def prelungire id_imprumut
		sql_query = "select data_prelungire from prelungire where id_imprumut = " + id_imprumut.to_s
		@prelungire = ActiveRecord::Base.connection.exec_query(sql_query).to_a.first
	end

	def user_extension id_imprumut
		Extension.where("id_imprumut = #{id_imprumut}")
	end

end
