require 'csv'

namespace :query_trace_summary do
  desc "Prints CSV-formatted summary for queries in log file(s)"
  task :csv do |t|
    file_names = ARGV[1..-1]
    if file_names.length == 0
      puts "Usage: rake #{t.name} <log-file>..."
      exit
    end

    summaries = QueryTraceSummary::EventSummary.parse_files(*file_names)
    csv = CSV.generate do |csv|
      csv << ['Total time', 'Calls', 'Action', 'Model', 'Location']
      summaries.each do |s|
        csv << [s.total_time, s.calls, s.action, s.model, s.location]
      end
    end

    puts csv
    exit
  end
end
