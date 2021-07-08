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


def eligible_members_endpoint
    response = HTTP.post('https://stage-app.mdlive.com/qa/eligible_members', :json => {
        "eligible_member": {
          "first_name": first_name,
          "last_name": last_name,
          "birthdate": dob,
          "gender": gender,
          "zip": zip,
          "affiliation_name": aff_name,
          "unique_id": unique_id
        }
    })
    p JSON.parse(response)
end