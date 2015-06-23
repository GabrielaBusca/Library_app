class ExtensionsController < ApplicationController

	def create
		extension  = Extension.new
		extension.id = Extension.next_id_sequence
		extension.id_imprumut = params[:id]
		extension.data_prelungire = Time.now
		respond_to do |format|
	      if extension.save
	        format.html {redirect_to :back, :notice => "Prelungirea a fost facuta cu succes" }
	      else
	        format.html { render :back }
	      end
	    end
	end

	private
		def extension_params
	      params.require(:extension).permit(:id, :data_prelungire, :id_imprumut )
	    end

end
