# app/components/paginator/paginator_component.rb
class PaginatorComponent < MountainView::Presenter
  properties :pointer, :period, :steps, :path, :sort

  DEFAULT_STEPS = 7
  TODAY = Date.today

  # Which day are we doing our calculations based on?
  def pointer
    if period == 1.week
      properties[:pointer].beginning_of_week
    else
      properties[:pointer]
    end
  end

  # What field are we using to sort?
  def sort
    properties[:sort] || false
  end

  # How far does each step take us?
  def period
    properties[:period] == 'week' ? 1.week : 1.day
  end

  # Create URLs
  def create_event_url(dt)
    "/#{path}/#{dt.year}/#{dt.month}/#{dt.day}#{url_suffix}"
  end

  # Link array
  def paginator # rubocop:disable Metrics/AbcSize
    pages = []
    # Create backward arrow link
    pages << ['←', create_event_url(pointer - period)]
    # Create in-between links according to steps requested
    (0..steps).each do |i|
      day = pointer + period * i
      pages << [format_date(day), create_event_url(day)]
    end
    # Create forwards arrow link
    pages << ['→', create_event_url(pointer + period)]
  end

  def title
    if period <= 1.day
      # Thursday 14 September, 2017
      pointer.strftime('%A %e %B, %Y')
    else
      # Thursday 14 September - 21 September 2017
      t = pointer.strftime('%A %e %B')
      t += ' - '
      # FIXME: 1.day needs sorting when we add in month views
      t + (pointer + period - 1.day).strftime('%A %e %B %Y')
    end
  end

  # Number of steps for the paginator to have
  def steps
    (properties[:steps] || DEFAULT_STEPS) - 1
  end

  # Format date according to context
  def format_date(date)
    if period <= 1.day
      todayify(date)
    else
      weekify(date)
    end
  end

  private

  # Formatting for if we are seeing less than a day's worth of events
  def todayify(date)
    date_fmt = date.strftime('%a %e %b')
    # Show day name e.g. "Fri 15th Sep"
    if date == TODAY
      "Today (#{date_fmt})"
    elsif date == TODAY + 1.day
      "Tomorrow (#{date_fmt})"
    else
      date_fmt
    end
  end

  def weekify(date)
    # Format the date
    end_date = date + period
    date_fmt = if date.month == end_date.month
                 date.strftime('%e') + '-' + end_date.strftime('%e %b')
               else
                 # Show date range e.g. "15 Sep - 22 Sep"
                 date.strftime('%e %b') + ' – ' + end_date.strftime('%e %b')
               end
    # Add in note if it's the current week
    if date == TODAY.beginning_of_week
      "This week (#{date_fmt})"
    else
      date_fmt
    end
  end

  # Base URL
  def path
    properties[:path] || 'events'
  end

  # URL params to add back in
  def url_suffix
    str = []
    str << 'period=week' if period == 1.week
    str << "sort=#{sort}" if sort
    '?' + str.join('&') if str.any?
  end
end