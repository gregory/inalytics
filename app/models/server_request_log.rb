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
    last_x_days = opts.fetch(:last_x_days) { 5 }
    visits.having { [day >= last_x_days.days.ago.to_date, day <= 1.day.ago.to_date] }
  end

  def self.referrer_visits
    selectors = [
      Sequel.lit("DATE(created_at)").as(:day),
      :url,
      :referrer,
      Sequel.lit("count(referrer)").as(:visits)
    ]
    select(*selectors).group(:day, :url, :referrer)
  end

  def self.referrer_visits_for_the_last_days(opts={})
    last_x_days = opts.fetch(:last_x_days) { 5 }
    referrer_visits.having { [day >= last_x_days.days.ago.to_date, day <= 1.day.ago.to_date] }
  end
end
