require 'rails_helper'

RSpec.describe 'the admin shelters show page' do 
  before :each do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create!(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald')
    @pet_2 = @shelter_1.pets.create!(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster')
    @app = Application.create!(name: "Taylor Swift", street_address: "22 Blank Space Ln", city: "Denver", state: "CO", zip_code: 80230, status: "Pending", description: "I love cats")
    @pet_app_1 = PetApplication.create(pet: @pet_1, application: @app)
    @pet_app_2 = PetApplication.create(pet: @pet_2, application: @app)
  end
  describe 'when a visitor visits the show page' do 
    it 'has a button to approve each pet that the application is for' do
      visit "/admin/applications/#{@app.id}"
   
      within "#pet_app_#{@pet_app_1.id}" do
        expect(page).to have_content(@pet_1.name)
        expect(page).to have_button("Accept #{@pet_1.name}")
      end

      within "#pet_app_#{@pet_app_2.id}" do
        expect(page).to have_content(@pet_2.name)
        expect(page).to have_button("Accept #{@pet_2.name}")
      end
    end

    it 'replaces the accept button with an indicator of acceptance when the button is pressed' do
      visit "/admin/applications/#{@app.id}"

      within "#pet_app_#{@pet_app_1.id}" do
        click_button "Accept #{@pet_1.name}"
      end

      expect(page).to have_current_path("/admin/applications/#{@app.id}")
      
      within "#pet_app_#{@pet_app_1.id}" do
        expect(page).not_to have_button("Accept #{@pet_1.name}")
        expect(page).to have_content('Accepted')
      end
    end

    it 'has a button to reject each pet that the application is for' do
      visit "/admin/applications/#{@app.id}"

      within "#pet_app_#{@pet_app_1.id}" do
        expect(page).to have_content(@pet_1.name)
        expect(page).to have_button("Reject #{@pet_1.name}")
      end

      within "#pet_app_#{@pet_app_2.id}" do
        expect(page).to have_content(@pet_2.name)
        expect(page).to have_button("Reject #{@pet_2.name}")
      end
    end

    it 'replaces the reject button with an indicator of rejection when the button is pressed' do
      visit "/admin/applications/#{@app.id}"

      within "#pet_app_#{@pet_app_1.id}" do
        click_button "Reject #{@pet_1.name}"
      end

      expect(page).to have_current_path("/admin/applications/#{@app.id}")
      
      within "#pet_app_#{@pet_app_1.id}" do
        expect(page).not_to have_button("Reject #{@pet_1.name}")
        expect(page).to have_content('Rejected')
      end
    end
  end 

  describe 'accepting or rejecting a pet on one application does not affect the status of the pet on other applications' do
    before :each do
      @app_2 = Application.create!(name: "Allison Grey", street_address: "123 Something St", city: "Denver", state: "CO", zip_code: 80200, status: "Pending", description: "I want a friend")
      @pet_app_3 = PetApplication.create(pet: @pet_1, application: @app_2)
    end
    it 'does not affect the pet status on other applications when a pet is accepted on one application' do
      visit "/admin/applications/#{@app.id}"

      within "#pet_app_#{@pet_app_1.id}" do
        click_button "Accept #{@pet_1.name}"
      end

      expect(page).to have_current_path("/admin/applications/#{@app.id}")
      
      within "#pet_app_#{@pet_app_1.id}" do
        expect(page).not_to have_button("Accept #{@pet_1.name}")
        expect(page).to have_content('Accepted')
      end

      visit "/admin/applications/#{@app_2.id}"

      within "#pet_app_#{@pet_app_3.id}" do
        expect(page).to have_button("Accept #{@pet_1.name}")
        expect(page).not_to have_content('Accepted')
      end
    end

    it 'does not affect the pet status on other applications when a pet is rejected on one application' do
      visit "/admin/applications/#{@app.id}"

      within "#pet_app_#{@pet_app_1.id}" do
        click_button "Reject #{@pet_1.name}"
      end

      expect(page).to have_current_path("/admin/applications/#{@app.id}")
      
      within "#pet_app_#{@pet_app_1.id}" do
        expect(page).not_to have_button("Reject #{@pet_1.name}")
        expect(page).to have_content('Rejected')
      end

      visit "/admin/applications/#{@app_2.id}"

      within "#pet_app_#{@pet_app_3.id}" do
        expect(page).to have_button("Reject #{@pet_1.name}")
        expect(page).not_to have_content('Rejected')
      end
    end
  end
end 