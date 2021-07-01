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


