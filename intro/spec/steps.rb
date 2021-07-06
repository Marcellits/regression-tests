def login_port(username, password)
    fill_in('Username', with: username)
    fill_in('Password', with: password)
    click_on 'Sign in'
end

def login_aff_manager(email, password)
    fill_in('Email', with: email)
    fill_in('Password', with: password)
    click_on 'Log in'
end

def aff_manager_search(affiliation)
    visit('https://stage-af.mdlive.com/affiliation_configurators/sign_in')
    aff_manager_admin_login
    find(:xpath, '//*[@id="select-search"]/option[2]').click
    fill_in('affiliation-search-field', with: affiliation)
    click_on('Search')
end


