def login_port(user)
    fill_in('Username', with: user[:username])
    fill_in('Password', with: user[:password])
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

def hash_month_names(month)
    hash_months = {
        '01'=> 'January',
        '02'=> 'February',
        '03'=> 'March',
        '04'=> 'April',
        '05'=> 'May',
        '06'=> 'June',
        '07'=> 'July',
        '08'=> 'August',
        '09'=> 'September',
        '10'=> 'October',
        '11'=> 'November',
        '12'=> 'December',
    }
    hash_months[month]
end

def generate_mock_270
    visit('https://stage-af.mdlive.com/affiliation_configurators/sign_in')
    aff_manager_admin_login
    find(:xpath, '//*[@id="mdlive-nav"]/div/div[2]/ul/li[6]/a').click
    click_link('Manage 271 Patients Data')
    click_link('UnRegistered Patients Data')
    click_link('Add UnRegistered Patient Data')
    select 'QA 270 Primary', from: 'select_hets_template'
    click_on('Submit')

end

def generate_mock_270_bcbsil
    visit('https://stage-af.mdlive.com/affiliation_configurators/sign_in')
    aff_manager_admin_login
    find(:xpath, '//*[@id="mdlive-nav"]/div/div[2]/ul/li[6]/a').click
    click_link('Manage 271 Patients Data')
    click_link('UnRegistered Patients Data')
    click_link('Add UnRegistered Patient Data')
    select 'Automation BCBSIL Primary', from: 'select_hets_template'
    click_on('Submit')

end