class MultiPieChartData
  def initialize(hash)
    @result = []
    @un_flatten_array = [hash]
    fix
    @flatten_array    = @un_flatten_array
    process_flatten
  end

  def result
    @result
  end

  def process_flatten
    push_flatten_array_info_to_result()
    while can_flatten?
      flatten
      push_flatten_array_info_to_result()
    end
  end

  def flatten
    @flatten_array = @flatten_array.map do |item|
      if item[:children].blank?
        {
          name:  "",
          value: item[:value],
          count: item[:count],
          display: false
        }
      else
        item[:children]
      end
    end.flatten
  end

  def push_flatten_array_info_to_result
    array = []
    @flatten_array.each do |item|
      hash = {}
      hash[:name]    = item[:name]
      hash[:count]   = item[:count]
      hash[:display] = item[:display]
      array.push hash
    end
    result.push array
  end

  def fix
    fix_digui(@un_flatten_array[0], 100)
  end

  def fix_digui(item, count)
    item[:count] = item[:value] * count / 100
    item[:display] = true
    item[:children] ||= []
    item[:children].each do |child|
      fix_digui(child, item[:count])
    end
  end

  def fix_children(item)
    if item[:children].blank?
      empty_item = {
        name:  "",
        value: 100,
        display: false
      }
      item[:children] = [empty_item]
    end
  end

  def can_flatten?
    @flatten_array.each do |item|
      if !item[:children].blank?
        return true
      end
    end
    return false
  end
end
