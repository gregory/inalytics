class ServerRequestLog < Sequel::Model
  def self.digest_hash(hash)
    Digest::MD5.hexdigest(hash.to_s)
  end

  def self.visits
    selectors = [
      Sequel.lit("DATE(created_at)").as(:day),
      :url,
      Sequel.lit("count(url)").as(:visits)
    ]
    select(*selectors).group(:day, :url)
  end

  def self.visits_for_the_last_days(opts={})
    last_x_days = opts.fetch(:last_x_days) { 6.days } # Default to 5 days ago since we reject today's date
    visits.having { [day >= last_x_days.ago.to_date, day < Date.today] }
  end
end
