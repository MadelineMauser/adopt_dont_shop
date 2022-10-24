require 'rails_helper' 

RSpec.describe Application, type: :model do 
  describe 'relationships' do 
   it {should have_many :pet_applications}
   it {should have_many(:pets).through(:pet_applications)}
  end

  describe 'validations' do 
    it { should validate_presence_of(:name)}
    it { should permit(:description).for(:show)}
  end
end