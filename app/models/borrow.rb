class Borrow < ActiveRecord::Base

	# specify schema and table name
  self.table_name = "licenta.imprumut"
  # specify primary key name
  self.primary_key = "id"

  def self.next_id_sequence
    sql_query = "SELECT imprumut_seq.nextval AS next_id from dual"
    result = ActiveRecord::Base.connection.exec_query(sql_query).to_a
  	result[0]["next_id"]
  end


end
