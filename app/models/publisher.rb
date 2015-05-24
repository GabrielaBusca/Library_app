class Publisher < ActiveRecord::Base

  # specify schema and table name
  self.table_name = "licenta.editura"
  # specify primary key name
  self.primary_key = "id"
  # specify sequence name
  self.sequence_name = "licenta.editura_seq"

end
