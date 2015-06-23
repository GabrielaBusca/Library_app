class Vote < ActiveRecord::Base
	# specify schema and table name
  self.table_name = "licenta.vot"
  # specify primary key name
  self.primary_key = "id"

  def self.next_id_sequence
    sql_query = "SELECT vot_seq.nextval AS next_id from dual"
    result = ActiveRecord::Base.connection.exec_query(sql_query).to_a.first
  	result["next_id"]
  end
end
