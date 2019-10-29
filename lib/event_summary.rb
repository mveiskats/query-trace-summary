require 'bigdecimal'

module QueryTraceSummary
  class EventSummary
    attr_accessor :model, :action, :location, :total_time, :calls

    ASCII_COLOR_RX = /\e\[\d+m/
    EVENT_RX = /([A-Z][A-Za-z0-9_:]+) (Create|Load|Update|Destroy) \((\d+(?:\.\d+)?)ms\)/

    LOCATION_PREFIX_RX = /Query Trace:$/

    # Assumes conservative file naming
    LOCATION_RX = /([a-zA-Z0-9_.\-\/]+:\d+:in `.+')$/

    def initialize(model, action, location)
      @model = model
      @action = action
      @location = location
      @total_time = @calls = 0
    end

    # Gathers all of the events in provided files
    # and returns array of event summaries
    # sorted in descending order by their total time
    def self.parse_files(*file_names)
      events = {}

      event_match = nil

      each_line(*file_names) do |line|
        # Previous line was an event
        if event_match
          location_match = LOCATION_RX.match(line)
          if location_match
            model, action, time = event_match.captures
            location = location_match.captures.first

            key = "#{model}/#{action}/#{location}"

            event = events[key] ||= new(model, action, location)
            event.calls += 1
            event.total_time += time.to_d

            event_match = nil

            next
          elsif LOCATION_PREFIX_RX.match(line)
            next
          end
        end

        event_match = EVENT_RX.match(line)
      end

      events.values.sort_by { |summary| -summary.total_time }
    end

    private

    def self.each_line(*file_names)
      file_names.each do |file_name|
        File.foreach(file_name) do |line|
          # Strip ASCII color codes
          line = line.gsub(ASCII_COLOR_RX, '')
          yield line
        end
      end
    end
  end
end
