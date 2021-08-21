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

    context 'When affiliation is CSV' do
        let(:first_name){ "test#{rand(1..10000)}"}
        let(:last_name){"test#{rand(1..10000)}"}
        let(:day){"#{rand(1..30)}"}
        let(:year){"#{rand(1910..2000)}"}
        let(:month){"#{([*1..12] - [2]).sample}"}
        let(:dob){"#{month}/#{day}/#{year}"}
        let(:gender){'Male'}
        let(:aff_name){'mdl'}
        let(:zip){'33325'}
        let(:unique_id){"test#{rand(1000..99999)}"}
        let(:email){'mgarcia@mdlive.com'}
        let(:password){'mdlive123'}
        let(:member_id){"#{unique_id}"}

        it 'should register successfully' do
            eligible_members_endpoint
            visit('/register')
            fill_in("Email", with: email)
            fill_in('Password', with: password)
            find('#dobMonth').find(:xpath, "//*[@id='dobMonth']/option[#{month.to_i+1}]").click
            fill_in('Day', with: day)
            fill_in('Year', with: year)
            click_on('Create account', wait:10)
            fill_in("First Name", with: first_name)
            fill_in("Last Name", with: last_name)
            find(:xpath, '//*[@id="__next"]/main/div/div/form/div[2]/label[2]/div/div').click
            fill_in("What's your home ZIP code?", with: zip)
            click_on('Submit')
            expect(page).to have_content(first_name.capitalize)
        end
    end
end
