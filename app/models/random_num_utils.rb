class RandomNumUtils
  def self.random_0_100
    case rand(3)
    when 0 then 0
    when 1 then rand(1..99)
    when 2 then 100
    end
  end
end
