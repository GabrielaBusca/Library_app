class Library < ActiveRecord::Base

  # specify schema and table name
  self.table_name = "licenta.biblioteca"
  # specify primary key name
  self.primary_key = "id"
  # specify sequence name
  self.sequence_name = "licenta.biblioteca_seq"

end
