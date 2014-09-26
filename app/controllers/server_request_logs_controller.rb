class ServerRequestLogsController < ApplicationController
  respond_to :json

  def top_urls
    report = TopUrlsReport.build
    respond_with report
  end
end
