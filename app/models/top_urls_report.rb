class TopUrlsReport

  Struct.new("UrlReport", :url, :day, :visits) do
  end

  def self.build
    logs = ServerRequestLog.visits_for_the_last_days
    reports = logs.map do |log|
      payload = [
        log[:url],
        log[:day],
        log[:visits]
      ]
      Struct::UrlReport.new(*payload)
    end

    reports.group_by{ |log| log.day }
  end


  class UrlReport
    attr_reader :day, :url
  end
end
