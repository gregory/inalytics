class ServerRequestLog < Sequel::Model
  def self.digest_hash(hash)
    Digest::MD5.hexdigest(hash.to_s)
  end
end
