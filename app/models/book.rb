class Book < ActiveRecord::Base

	# specify schema and table name
  self.table_name = "licenta.carte"
  # specify primary key name
  self.primary_key = "id"
  # specify sequence name
  self.sequence_name = "licenta.carte_seq"

  mount_uploader :imagine_coperta, BookUploader

end
