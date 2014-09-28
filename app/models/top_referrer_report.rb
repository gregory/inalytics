class TopReferrerReport
  DEFAUTLS = {
    top_x_urls: 10,
    top_x_referrers: 5,
    last_x_days: 5
  }

  unless defined?(Struct::UrlLogs)
    Struct.new("UrlReport", :url, :logs) do
      # Total visits for this particular url
      def visits
        @visits ||= logs.inject(0) { |sum, log| sum + log[:visits] }
      end

      # Top referrers for this particular url
      def referrers
        logs.take(DEFAUTLS[:top_x_referrers]).map{ |log| Struct::ReferrerReport.new(log.referrer, log[:visits]) }
      end

      def as_json(*args)
        {
          url: url,
          visits: visits,
          referrers: referrers
        }
      end

      Struct.new("ReferrerReport", :url, :visits)
    end
  end

  def self.build
    #Group logs by day
    logs_with_referrers = self.new.top_referrers.to_a.group_by{ |row| row[:day] }

    reports_by_day = logs_with_referrers.map do |day, logs|
      [day, self.reports_for_logs(logs)]
    end

    Hash[reports_by_day]
  end

  def self.reports_for_logs(logs)
    reports = logs.group_by(&:url).map do |url, url_logs|
      # For each url, create a report
      Struct::UrlReport.new(url, url_logs)
    end

    sorted_reports = reports.sort!{|a,b| a.visits <=> b.visits}

    sorted_reports.take(DEFAUTLS[:top_x_urls])
  end

  def top_referrers
    top_urls = top_10_urls
    ServerRequestLog.referrer_visits_for_the_last_days(last_x_days: DEFAUTLS[:last_x_days]).where(url: top_urls).where('referrer is not null').
      order(:day, :url, Sequel.desc(:visits))
  end

  def top_10_urls
    return @top_10_urls if @top_10_urls

    urls_for_last_days = ServerRequestLog.visits_for_the_last_days(last_x_days: DEFAUTLS[:last_x_days]).
      order(:day, Sequel.desc(:visits)).to_a.group_by{ |log| log[:day] }

    @top_10_urls = urls_for_last_days.each_with_object([]) do |(_, logs), array|
      array.push logs[(0..(DEFAUTLS[:top_x_urls]-1))].map(&:url)
    end.flatten.uniq
  end
end
