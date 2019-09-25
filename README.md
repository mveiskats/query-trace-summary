Generates summary of time consumed by database queries.
Helpful to pinpoint where to focus optimization efforts.

## Usage

1. Add and initialize [active-record-query-trace](https://github.com/brunofacca/active-record-query-trace) gem.
2. Add `gem 'query-trace-summary', group: :development` to your Gemfile
3. Remove previous logs
4. Run the problematic code
5. Pipe summary `rake query_trace_summary:csv <log-file>...` into a file
6. Open the file with your favorite spreadsheet program
7. Optimize away

Brief summary of top 10 most time intensive queries can also be generated with
`rake query_trace_summary:top10` command

If you're using Rails >= 5.2, `ActiveRecord::Base.verbose_query_logs = true`
setting is sufficient to gather query statistics.
The active-record-query-trace gem can still be helpful when figuring out
what is causing the queries.

## Gotchas

It assumes project file names do not contain spaces or any special characters.

Rake tasks cannot be chained

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).
