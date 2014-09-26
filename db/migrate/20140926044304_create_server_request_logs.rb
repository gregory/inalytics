Sequel.migration do
  change do
    create_table :server_request_logs do
      primary_key :id
      String :url
      String :referrer, null: true
      DateTime :created_at
      String :hash
    end
  end
end
