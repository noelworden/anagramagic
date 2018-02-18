require 'rails_helper'

RSpec.describe Anagram, type: :model do
  #TODO get presence_of tests to pass
  it { should validate_presence_of(:word) }
  it { should validate_uniqueness_of(:word) }
  it { should validate_presence_of(:letter_count) }
end
