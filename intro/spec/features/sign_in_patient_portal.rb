require 'spec_helper'
require_relative '../steps.rb'
require_relative '../pws.rb'

feature 'Login Page: Validate Page Elements' do

    background do
        visit '/sign-in'
    end

    scenario 'Sign in on Patient Portal NEXT' do
        expect(page).to have_content('Sign in to your account')
     end

    scenario 'User log in succesfully' do 
        roberta_login 
        expect(page).to have_content('Who needs help today?')
        expect(page).to have_content ('Roberta')
    end
end    