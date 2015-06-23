class Instance < ActiveRecord::Base

  # specify schema and table name
  self.table_name = "licenta.exemplar"
  
  self.primary_key = "id"

  def self.next_id_sequence
    sql_query = "SELECT exemplar_seq.nextval AS next_id from dual"
    result = ActiveRecord::Base.connection.exec_query(sql_query).to_a.first
  	result["next_id"]
  end

end
