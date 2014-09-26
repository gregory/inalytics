class ServerRequestLogsController < ApplicationController
  respond_to :json

  def top_urls
    report = TopUrlsReport.build
    respond_with report
  end

  def top_referrers
    report = TopReferrerReport.build
    respond_with report
  end
end
