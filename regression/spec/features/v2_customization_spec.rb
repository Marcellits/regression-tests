require 'spec_helper'
require_relative '../steps.rb'
require_relative '../pws.rb'


feature "Affiliation's Customization" do
    scenario 'When Affiliation has customized color' do 
        visit('https://stage-af.mdlive.com/affiliation_configurators/sign_in')
        login_aff_manager(AFF_MANAGER_ADMIN)
        fill_in('affiliation-search-field', with: 'conehealth')
        click_on('Search')
        click_on('Actions')
        click_link('Org Params')
        primary_color = page.find(:xpath, '//*[@id="org-param-65139"]/td[2]').text
        visit('/sign-in')
        login_port(CONEHEALTH_USER)
        background_color = page.find(:xpath, '/html/body/div[4]').native.css_value('background')
        if background_color.include? 'rgb(0, 153, 170)'
            background_color = '#0099aa'
        end
        expect(background_color).to eq(primary_color)
    end

    scenario 'When Affiliation has logo added' do
        visit('https://stage-af.mdlive.com/affiliation_configurators/sign_in')
        login_aff_manager(AFF_MANAGER_ADMIN)
        fill_in('affiliation-search-field', with: 'conehealth')
        click_on('Search')
        click_on('Actions')
        click_link('Affiliation Images')
        image_link = page.find(:xpath, '//*[@id="affiliation-image-2286"]/td[2]').text
        visit('/sign-in')
        login_port(CONEHEALTH_USER)
        logo_port = page.find(:xpath, '//*[@id="affiliationLogo"]', visible: false)['src']
        expect(logo_port).to eq(image_link)
    end
end    