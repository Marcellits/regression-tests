require 'spec_helper'
require_relative '../steps.rb'
require_relative '../pws.rb'
require 'http'

describe 'Next registration' do
    context 'When affiliation is 270' do
        it 'should register user successfully' do
            generate_mock_270_bcbsil
            patient_name = find(:xpath, '/html/body/div/p[1]').text.split(' ')
            first_name = patient_name[2]
            last_name = patient_name[3]
            dob = find(:xpath, '/html/body/div/p[2]').text.split(' ')[2]
            year = dob.split("-")[0]
            month = dob.split("-")[1]
            day = dob.split("-")[2]
            member_id = find(:xpath, '/html/body/div/p[3]').text.split(' ')[2]
            gender = find(:xpath, '/html/body/div/p[4]').text.split(' ')[1]
            zip = '33325'
            email = 'mgarcia@mdlive.com'
            password = 'mdlive123' 
            visit('/register')
            fill_in("Email", with: email)
            fill_in('Password', with: password)
            month_name = hash_month_names(month)
            select month_name, from: 'dobMonth'
            fill_in('Day', with: day)
            fill_in('Year', with: year)
            click_on('Create account')
            fill_in("First Name", with: first_name)
            fill_in("Last Name", with: last_name)

            if gender == 'Male'
                find(:xpath, '//*[@id="__next"]/main/div/div/form/div[2]/label[2]/div/div').click
            elsif gender == 'Female'
                find(:xpath, '//*[@id="__next"]/main/div/div/form/div[2]/label[1]/div/div').click
            elsif gender == 'Non-binary'
                find(:xpath, '//*[@id="__next"]/main/div/div/form/div[2]/label[3]/div/div').click
            end

            fill_in("What's your home ZIP code?", with: zip)
            click_on('Submit')
            find(:xpath, '//*[@id="affiliationSearch-input"]').click
            find(:xpath, '//*[@id="affiliationSearch-item-3"]').click
            
            click_on('Next')
            fill_in('Insurance Member ID', with: member_id)
            find(:xpath, '//*[@id="__next"]/main/div/div/form/div[2]/label[2]/div/div').click
            click_on('Submit')
            expect(page).to have_content(first_name.capitalize)
        end
    end
end
