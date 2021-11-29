module ApplicationHelper
  def undegeuify(string)
    string.split(',').map { |s| s.gsub(/[^0-9]/, '')}
  end
end
