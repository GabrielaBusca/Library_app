class Author < ActiveRecord::Base

  # specify schema and table name
  self.table_name = "licenta.autor"
  # specify primary key name
  self.primary_key = "id"
  # specify sequence name
  #self.sequence_name = "licenta.carte_seq"

end
