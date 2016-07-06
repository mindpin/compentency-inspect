require 'yaml'
module SearchBox
  class Parser
    def self.get_questions
      questions = YAML.load_file(Rails.root.join("csm/search_box/questions.yaml"))
      questions.map do |question|
        question["keywords"] = question["keywords"].split(" ")
        question["title"]    = question["question"]
        question
      end
    end

    def self.get_releated_keywords_by_keyword(keywords)
      questions = keywords.map do |keyword|
        self.get_qustions_by_keywords([keyword])
      end.flatten.uniq
      ks = questions.map {|q| q["keywords"]}.flatten.uniq
      ks - keywords
    end

    def self.get_qustions_by_keywords(keywords)
      get_questions.select do |question|
        bing_arr = question["keywords"] & keywords
        bing_arr.count == keywords.count
      end
    end

    def self.get_hot_sorted_keywords
      questions = self.get_questions
      hot_record_hash = {}
      questions.each do |question|
        question["keywords"].each do |keyword|
          if hot_record_hash[keyword] == nil
            hot_record_hash[keyword] = 1
          else
            hot_record_hash[keyword] += 1
          end
        end
      end

      hot_record_hash.to_a.sort{|i,j|j[1] <=> i[1]}.map do |item|
        item[0]
      end
    end
  end
end
