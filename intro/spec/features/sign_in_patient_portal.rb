require 'spec_helper'

feature 'Login Page: Validate Page Elements' do
    background do
        visit '/sign-in'
    end

    scenario 'Sign in on Patient Portal NEXT' do
        expect(page).to have_content('Sign in to your account')
     end

    scenario 'User log in succesfully' do 
        fill_in 'Username or Email', with: 'robertafake'
        fill_in 'Password', with: 'mdlive2020'
        click_on 'Sign in'
        expect(page).to have_content('Who needs help today?')
        expect(page).to have_content ('Roberta')
    end
end    