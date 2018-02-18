class AnagramSerializer < ActiveModel::Serializer
  attributes :anagrams

  def anagrams
    limit = @instance_options[:limit].to_i
    base = object.word

    sorted_object = base.split("").sort.join
    anagram = Anagram.where(sorted_word: sorted_object).pluck(:word) - [base]
    if limit == 0
      anagram.sort
    else
      anagram.sort.first(limit)
    end
  end
end
