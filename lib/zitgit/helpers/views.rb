module ViewsHelpers
  def strip_message(text, length)
    text.length > length ? text[0, length] + '...' : text
  end
  
  def summ_line(line)
    line.match(/@@\s+-([^\s]+)\s+\+([^\s]+)\s+@@/)
    [Regexp.last_match(1), Regexp.last_match(2)].map{|item|
      parts = item.split(',')
      if parts.count == 2
        parts[0] + '-' + (parts[0].to_i + parts[1].to_i).to_s
      else
        item
      end
    }.join(' -> ')
  end
end
