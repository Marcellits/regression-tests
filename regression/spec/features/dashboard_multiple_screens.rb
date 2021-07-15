require 'spec_helper'
require_relative '../steps.rb'
require_relative '../pws.rb'

describe "Dashboard multiple screens section" do
    context 'When affiliation has all cards services enabled' do
        #known dtc has all services available
        it 'should display all cards' do
            visit('/sign-in')
            roberta_login
            find(:xpath, '//*[@id="legacyLayoutApplication"]/div[2]/div/div/div[2]/section/label[2]/img').click
            expect(page).to have_content('Urgent Care'&& 'Wellness Visit' && 'Therapist' && 'Psychiatrist' && 'Dermatologist')
        end
    end

    context 'When affiliation is BH only' do
        #known Molina is BH only
        it 'should display only therapy and psychiatry cards' do
            visit('/sign-in')
            molina_user_login
            find(:xpath, '//*[@id="legacyLayoutApplication"]/div[2]/div/div/div[2]/section/label/img').click
            expect(page).to have_content('Psychiatrist' && 'Therapist') 
        end
    end

    context 'When affiliation does not have dermatology' do
        #known Avmed doesn't have dermatology enabled
        it 'should display all services except dermatology' do
            visit('/sign-in')
            avmed_user_login
            click_on('Confirm')
            find(:xpath, '//*[@id="legacyLayoutApplication"]/div[2]/div/div/div[2]/section/label[1]/img').click
            expect(page).to have_no_content('Dermatologist') 
        end
    end

    context 'When affiliation does not have Primary Care nor A. Wellness enabled' do
        #known Avmed doesn't have PC nor A.W. enabled
        it 'should display all services except Annual Wellness' do
            visit('/sign-in')
            avmed_user_login
            click_on('Confirm')
            find(:xpath, '//*[@id="legacyLayoutApplication"]/div[2]/div/div/div[2]/section/label[1]/img').click
            expect(page).to have_no_content('Primary Care' && 'Wellness Visit') 
        end
    end

    context 'When affiliation has Primary Care, but not Annual Wellness' do
        #known Cone Health doesn't have annual wellness set in stage
        it 'should display Primary Care card' do
            visit('/sign-in')
            conehealth_user_login
            find(:xpath, '//*[@id="legacyLayoutApplication"]/div[2]/div/div/div[2]/section/label/img').click
            expect(page).to have_content('Primary Care') && have_no_content('Wellness Visit')
        end
    end

    context 'When rule authorize_service_amount is disabled' do
        it 'should display prices based on plan' do
            aff_manager_search('88')
            click_on('View')
            product = find(:xpath, '/html/body/div/div[1]/div[2]/dl/dd[4]').text
            click_on('Data')
            click_link('Products')
            fill_in('Search for product', with: product)
            click_on('Search')
            click_link('Edit', :match => :first)
            urgent_care_price = find('#product_consult_price').value.to_i
            psychiatry_price = find('#product_psychiatry_consult_price').value.to_i
            psychiatry_recurring_price = find('#product_recurring_psychiatry_price').value.to_i
            therapy_price = find('#product_therapy_consult_price').value.to_i
            therapy_recurring_price = find('#product_recurring_therapy_price').value.to_i
            derm_price =find('#product_derm_consult_price').value.to_i
            visit('/sign-in')
            mdlive_user_login
            find(:xpath, '//*[@id="legacyLayoutApplication"]/div[2]/div/div/div[2]/section/label[1]/img').click
            urgent_care_card_price = (find(:xpath, "//*[@id='price_for_provider_type_3']/b").text)[1..-1].to_i
            therapy_card_price = (find(:xpath, "//*[@id='price_for_provider_type_5']/b").text)[1..-1].to_i
            psychiatry_card_price = (find(:xpath, "//*[@id='price_for_provider_type_6']/b").text)[1..-1].to_i
            derm_card_price = (find(:xpath, "//*[@id='price_for_provider_type_12']/b").text)[1..-1].to_i
            expect(urgent_care_card_price).to eq(urgent_care_price)
            expect(therapy_card_price).to eq(therapy_price || therapy_recurring_price)
            expect(psychiatry_card_price).to eq(psychiatry_price || psychiatry_recurring_price)
            expect(derm_card_price).to eq(derm_price)
        end
    end

    context ' When rule authorize_service_charge_amount is enabled' do
        #known Geha has the rule set in aff manager
        it 'should display prices based on service amount in affiliation details' do
            aff_manager_search('970')
            click_on('Actions')
            click_link('Edit')
            urgent_care_price = find('#affiliation_charge_amount').value.to_i
            psychiatry_price = find('#affiliation_psychiatry_charge_amount').value.to_i
            therapy_price = find('#affiliation_therapy_charge_amount').value.to_i
            derm_price =find('#affiliation_dermatology_charge_amount').value.to_i
            visit('/sign-in')
            geha_user_login
            click_on('Confirm')
            find(:xpath, '//*[@id="legacyLayoutApplication"]/div[2]/div/div/div[2]/section/label/img').click
            urgent_care_card_price = (find(:xpath, "//*[@id='price_for_provider_type_3']/b").text)[1..-1].to_i
            therapy_card_price = (find(:xpath, "//*[@id='price_for_provider_type_5']/b").text)[1..-1].to_i
            psychiatry_card_price = (find(:xpath, "//*[@id='price_for_provider_type_6']/b").text)[1..-1].to_i
            expect(urgent_care_card_price).to eq(urgent_care_price)
            expect(therapy_card_price).to eq(therapy_price)
            expect(psychiatry_card_price).to eq(psychiatry_price)
        end
    end
end    