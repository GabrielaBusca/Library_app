class BooksController < ApplicationController

	def new
		@book = Book.new
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

	private
		def book_params
	      params.require(:book).permit(:id, :titlu, :cod_isbn, :data_adaugare, :data_aparitie, :id_domeniu, :id_autor, :id_editura, :descriere, :imagine_coperta)
	    end

end
