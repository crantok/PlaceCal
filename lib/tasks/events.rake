# frozen_string_literal: true

namespace :import do
  # No data for calendar of type `other` right now.
  task all_events: :environment do
    Calendar.without_type(:other).each do |calendar|
      import_events_from_source(calendar.id, Date.current.beginning_of_day)
    end
  end

  task :events_from_source, [:calendar_id] => [:environment] do |_t, args|
    import_events_from_source(args[:calendar_id], Date.current.beginning_of_day)
  end

  # calendar_id - object id of calendar to be imported.
  # from - import events starting from this date. Must use format 'yyyy-mm-dd'.

  task :past_events_from_source, %i[calendar_id from] => [:environment] do |_t, args|
    date = Date.parse(args[:from])
    from = DateTime.parse(date)

    import_events_from_source(args[:calendar_id], from)
  end
end

def import_events_from_source(calendar_id, from)
  calendar = Calendar.find(calendar_id)

  puts "Importing events for calendar #{calendar.name} for #{calendar.place.try(:name)}"

  calendar.import_events(from)
rescue StandardError => e
  # TODO: Inform admin(s) when this fails
  error = "Could not automatically import data for calendar #{calendar.name} (id #{calendar_id}):  #{e}"
  puts error
  Rollbar.error error
  nil
end
