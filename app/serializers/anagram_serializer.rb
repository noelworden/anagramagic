class AnagramSerializer < ActiveModel::Serializer
  attributes :word, :today

  def today
    Date.today
  end
end
