require 'spec_helper'
require_relative '../steps.rb'
require_relative '../pws.rb'
require 'http'

describe 'Next registration on Landing Pages' do
    context 'When affiliation is 270' do
        it 'should register user successfully' do
            generate_mock_270
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
            
            visit('https://stage.mdlive.com/en/bcbsil-mmai/register')
            fill_in("What's your email?", with: email)
            fill_in('Create a password', with: password)
            fill_in("What's your first name?", with: first_name)
            fill_in("What's your last name?", with: last_name)

            if gender == 'Male'
                find(:xpath, '//*[@id="__next"]/div[2]/main/div/div/form/div[4]/div/label[2]/div/div').click
            elsif gender == 'Female'
                find(:xpath, '//*[@id="__next"]/div[2]/main/div/div/form/div[4]/div/label[1]/div/div').click
            elsif gender == 'Non-binary'
                find(:xpath, '//*[@id="__next"]/div[2]/main/div/div/form/div[4]/div/label[3]/div/div').click
            end
          
            month_name = hash_month_names(month)
            select month_name, from: 'dobMonth'
            fill_in('Day', with: day)
            fill_in('Year', with: year)
            fill_in("What's your home ZIP code?", with: zip)
            click_on('Create account')
            fill_in('Insurance Member ID', with: member_id)
            find(:xpath, '//*[@id="__next"]/div[2]/main/div/div/form/div[2]/label[2]/div/div').click
            click_on('Submit')
            expect(page).to have_content(first_name.capitalize)
        end
    end

    context 'When affiliation is CSV' do
        let(:first_name){ "test#{rand(1..10000)}"}
        let(:last_name){"test#{rand(1..10000)}"}
        let(:day){"#{rand(1..31)}"}
        let(:year){"#{rand(1910..2000)}"}
        let(:dob){"03/#{day}/#{year}"}
        let(:gender){'male'}
        let(:aff_name){'mdl'}
        let(:zip){'33325'}
        let(:unique_id){"test#{rand(1000..99999)}"}
        let(:email){'mgarcia@mdlive.com'}
        let(:password){'mdlive123'}

        it 'should register successfully' do
            eligible_members_endpoint
            visit('https://stage.mdlive.com/en/surveymonkey/register')
            fill_in("What's your email?", with: email)
            fill_in('Create a password', with: password)
            fill_in("What's your first name?", with: first_name)
            fill_in("What's your last name?", with: last_name)
            find(:xpath, '//*[@id="__next"]/div[2]/main/div/div/form/div[4]/div/label[2]/div/div').click
            select 'March', from: 'dobMonth'
            fill_in('Day', with: day)
            fill_in('Year', with: year)
            fill_in("What's your home ZIP code?", with: zip)
            click_on('Create account')
            expect(page).to have_content(first_name.capitalize)
        end
    end

    context 'When affiliation is Hybrid' do
        let(:first_name){ "test#{rand(1..10000)}"}
        let(:last_name){"test#{rand(1..10000)}"}
        let(:day){"#{rand(1..31)}"}
        let(:year){"#{rand(1910..2000)}"}
        let(:dob){"03/#{day}/#{year}"}
        let(:gender){'male'}
        let(:aff_name){'bcbsil'}
        let(:zip){'33325'}
        let(:unique_id){"test#{rand(1000..99999)}"}
        let(:email){'mgarcia@mdlive.com'}
        let(:password){'mdlive123'}

        it 'should register user successfully' do
            visit('https://stage.mdlive.com/en/bcbsil/register/monikers')
            eligible_members_endpoint
            fill_in('Insurance Member ID', with: unique_id)
            select 'March', from: 'dobMonth'
            fill_in('Day', with: day)
            fill_in('Year', with: year)
            click_on('Continue')
            fill_in("What's your email?", with: email)
            fill_in('Create a password', with: password)
            click_on('Create account')
            expect(page).to have_content('Who needs help today?')
        end
    end
end
