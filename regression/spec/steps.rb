CSV_ELIGIBLE_MEMBER = {
    first_name: "test#{rand(1..10000)}",
    last_name: "test#{rand(1..10000)}",
    day: "#{rand(1..30)}",
    year: "#{rand(1910..2000)}",
    month: "#{([*1..12] - [2]).sample}",
    gender: 'Male',
    aff_name:'mdl',
    zip: '33325',
    unique_id: "test_unique_id#{rand(1000..99999)}",
    email: 'qateam@mdlive.com',
    password: 'mdlive123',
    #member_id: "#{:unique_id}"
}



def login_port(user)
    fill_in('Username', with: user[:username])
    fill_in('Password', with: user[:password])
    click_on 'Sign in'
end

def login_aff_manager(user)
    fill_in('Email', with: user[:username])
    fill_in('Password', with: user[:password])
    click_on 'Log in'
end

def aff_manager_search(affiliation)
    visit('https://stage-af.mdlive.com/affiliation_configurators/sign_in')
    login_aff_manager(AFF_MANAGER_ADMIN)
    find(:xpath, '//*[@id="select-search"]/option[2]').click
    fill_in('affiliation-search-field', with: affiliation)
    click_on('Search')
end


def eligible_members_endpoint(eligible_member)
    response = HTTP.post('https://stage-app.mdlive.com/qa/eligible_members', :json => {
        "eligible_member": {
          "first_name": eligible_member[:first_name],
          "last_name": eligible_member[:last_name],
          "birthdate": "#{eligible_member[:month]}/#{eligible_member[:day]}/#{eligible_member[:year]}",
          "gender": eligible_member[:gender],
          "zip": eligible_member[:zip],
          "affiliation_name": eligible_member[:aff_name],
          "unique_id": eligible_member[:unique_id]
        }
    })
    if response[:status] = 201 
        p "Eligible member record created" 
        p JSON.parse(response)
    else
        response.status
    end
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
    login_aff_manager(AFF_MANAGER_ADMIN)
    find(:xpath, '//*[@id="mdlive-nav"]/div/div[2]/ul/li[6]/a').click
    click_link('Manage 271 Patients Data')
    click_link('UnRegistered Patients Data')
    click_link('Add UnRegistered Patient Data')
    select 'QA 270 Primary', from: 'select_hets_template'
    click_on('Submit')

end

def generate_mock_270_bcbsil
    visit('https://stage-af.mdlive.com/affiliation_configurators/sign_in')
    login_aff_manager(AFF_MANAGER_ADMIN)
    find(:xpath, '//*[@id="mdlive-nav"]/div/div[2]/ul/li[6]/a').click
    click_link('Manage 271 Patients Data')
    click_link('UnRegistered Patients Data')
    click_link('Add UnRegistered Patient Data')
    select 'Automation BCBSIL Primary', from: 'select_hets_template'
    click_on('Submit')
end
