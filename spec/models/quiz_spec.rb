require 'rails_helper'

RSpec.describe Quiz, type: :model do
  describe 'validations' do
    subject { build(:quiz) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:time_limit) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(255) }
  end

  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:quiz)).to be_valid
    end
  end

  describe '#total_questions' do
    it 'returns the total number of questions in the quiz' do
      quiz = create(:quiz)
      # Create questions without using the factory's association
      3.times do
        create(:question, quiz: quiz)
      end
      
      expect(quiz.total_questions).to eq(3)
    end
  end
end 