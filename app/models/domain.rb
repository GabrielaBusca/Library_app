class Domain < ActiveRecord::Base

  # specify schema and table name
  self.table_name = "licenta.domeniu"
  # specify primary key name
  self.primary_key = "id"
  # specify sequence name
  self.sequence_name = "licenta.domeniu_seq"

end
