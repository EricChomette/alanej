module ApplicationHelper
  def undegeuify(string)
    string.split(',').map { |s| s.gsub(/[^0-9]/, '')}
  end

  def time_conversion(minutes)
    hours = minutes / 60
    rest = minutes % 60
    rest = "0#{rest}" if rest < 10
    return "#{hours}h#{rest}"
  end

  def humanize(date)
    date.strftime('%d %B %Y')
  end
end
