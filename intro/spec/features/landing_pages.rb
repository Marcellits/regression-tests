require 'spec_helper'
require_relative '../steps.rb'
require_relative '../pws.rb'
require 'http'

describe 'Next registration on Landing Pages' do
    context 'When affiliation is CSV' do
        let(:first_name){ "test#{rand(1..10000)}"}
        let(:last_name){"test#{rand(1..10000)}"}
        let(:day){"#{rand(1..28)}"}
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
end
