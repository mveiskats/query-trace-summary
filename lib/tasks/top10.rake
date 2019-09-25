namespace :query_trace_summary do
  desc "Prints top 10 time-consuming queries in log file(s)"
  task :top10 do |t|
    file_names = ARGV[1..-1]
    if file_names.length == 0
      puts "Usage: rake #{t.name} <log-file>..."
      exit
    end

    summaries = QueryTraceSummary::EventSummary.parse_files(*file_names)
    summaries = summaries[0..9]

    lines = summaries.map do |s|
      [
        "#{s.total_time}ms",
        "#{s.calls} calls",
        s.action,
        s.model,
        s.location
      ]
    end

    # Align output columns
    lengths = lines.map { |l| l.map(&:length) }
    col_widths = lengths.transpose.map(&:max)

    lines.each do |l|
      l[0] = l[0].rjust(col_widths[0])
      l[1] = l[1].rjust(col_widths[1])
      l[2] = l[2].ljust(col_widths[2])
      l[3] = l[3].ljust(col_widths[3])

      puts l.join(' ')
    end

    exit
  end
end
