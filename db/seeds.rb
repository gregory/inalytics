# Required Urls
class LogGenerator
  URLS = %w(
    http://apple.com
    https://apple.com
    https://www.apple.com
    http://developer.apple.com
    http://en.wikipedia.org
    http://opensource.org
  )

  # Required Referrers
  REFERRERS = %w(
    http://apple.com
    https://apple.com
    https://www.apple.com
    http://developer.apple.com
  ).push(nil)

  # 24 Random times in the day
  TIMES = (0..24).inject([]) do |array, hour|
    min = rand(0..60)
    array.push [hour, min]
  end

  DEFAULTS = {
    batch_size: 10_000,
    db_commit_every: 1000
  }

  attr_reader :total_rows, :distinct_date, :batch_size, :db_commit_every

  def initialize(opts={})
    @distinct_date = opts.fetch(:distinct_date) { 10 } # By default, generate logs on 10 days from now
    @total_rows = opts.fetch(:total_rows) { 1_000_000 } # By default, generate 1M logs
    @batch_size = opts.fetch(:batch_size) { DEFAULTS[:batch_size] }
    @db_commit_every = opts.fetch(:db_commit_every) { DEFAULTS[:db_commit_every] }
  end

  def generate_logs
    puts "Generating logs for the past #{distinct_date} days..."
    (distinct_date.days.ago.to_date..Date.today.to_date).each_with_index do |date, day_x|
      payload = {
        day_x: day_x,
        total_logs: logs_per_day
      }
      generate_logs_for_date(date, payload)
    end

  end

  def generate_logs_for_date(date, opts={})
    # By default, lets shuffle the data
    urls      = opts.fetch(:urls){ URLS.shuffle }
    referrers = opts.fetch(:referrers){ REFERRERS.shuffle }
    times     = opts.fetch(:times){ TIMES.shuffle }

    total_logs = opts.fetch(:total_logs)


    (1..total_logs).each_slice(batch_size).each do |batch|
      logs = batch.each_with_object([]) do |i, array|

        time = times[i%times.size]

        payload = {
          url: urls[i%urls.size],
          referrer: referrers[i%referrers.size],
          created_at: (date + time[0].hour + time[1].minutes).to_datetime
        }
        payload[:id] = (opts[:day_x]*logs_per_day  + i) if opts[:day_x].present?  #TODO: dependency with the day_x - improve
        payload[:hash] = ServerRequestLog.digest_hash(payload)

        array.push(payload)
      end
      ServerRequestLog.multi_insert(logs, commit_every: db_commit_every)
    end


    if opts[:day_x].present?
      puts "#{logs_per_day} logs has been generated for #{date} - total: #{(opts[:day_x]+1)*logs_per_day}"
    end
  end

private

  def logs_per_day
    @logs_per_day ||= total_rows/distinct_date # TODO: avoid 0 division
  end
end

LogGenerator.new.generate_logs


