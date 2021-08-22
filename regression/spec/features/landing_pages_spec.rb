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
            email = 'qateam@mdlive.com'
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
        it 'should register successfully' do
            eligible_member = CSV_ELIGIBLE_MEMBER
            eligible_members_endpoint(eligible_member)
            visit('https://stage.mdlive.com/en/surveymonkey/register')
            fill_in("What's your email?", with: eligible_member[:email])
            fill_in('Create a password', with: eligible_member[:password])
            fill_in("What's your first name?", with: eligible_member[:first_name])
            fill_in("What's your last name?", with: eligible_member[:last_name])
            find(:xpath, '//*[@id="__next"]/div[2]/main/div/div/form/div[4]/div/label[2]/div/div').click
            find('#dobMonth').find(:xpath, "//*[@id='dobMonth']/option[#{eligible_member[:month].to_i+1}]").click
            fill_in('Day', with: eligible_member[:day])
            fill_in('Year', with: eligible_member[:year])
            fill_in("What's your home ZIP code?", with: eligible_member[:zip])
            click_on('Create account')
            expect(page).to have_content(eligible_member[:first_name].capitalize)
        end
    end

    context 'When affiliation is Hybrid' do
        it 'should register user successfully' do
            visit('https://stage.mdlive.com/en/bcbsil/register/monikers')
            eligible_member = CSV_ELIGIBLE_MEMBER
            eligible_member[:aff_name] = 'bcbsil' #known as hybrid affiliation
            eligible_members_endpoint(eligible_member)
            fill_in('Insurance Member ID', with: eligible_member[:unique_id])
            find('#dobMonth').find(:xpath, "//*[@id='dobMonth']/option[#{eligible_member[:month].to_i+1}]").click
            fill_in('Day', with: eligible_member[:day])
            fill_in('Year', with: eligible_member[:year])
            click_on('Continue')
            fill_in("What's your email?", with: eligible_member[:email])
            fill_in('Create a password', with: eligible_member[:password])
            click_on('Create account')
            expect(page).to have_content(eligible_member[:first_name].capitalize)
        end
    end
end
