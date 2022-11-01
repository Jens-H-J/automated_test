*** Settings ***
Library           Browser
Library           OperatingSystem
#Library           Dialogs

*** Variables ***
${fleet_ip}       10.51.164.228
${robot_ip}       10.52.164.29
${fleet_name}     fleet
${fleet_site}     site
${fleet_sw}       software
${work_dir}       C:\\E2E_testing\\
${import_site_file}    test_site_MiR_Test_Development_v3-0-1-90-g3b0d5849c13a-master_2022-09-02.site
${exported_site}    ${fleet_site}_${fleet_name}_${fleet_sw}_${time}.site
${upgrade_file}    MiRFleet_Server-3.0.5-rc.1.zip

*** Test Cases ***
Fleet Login
    #Login to UI and verify
    Open Login Page
    Enter Credentials
    Wait For Elements State    (//*[name()='svg'][@class='header-icon'])[1]    visible    # User icon is visible
    #Post test result to TestRail
    #API Session
    #Add results    1173    179043    1    API test again

Fleet Upgrade UI
    Open Login Page
    Enter Credentials
    Go to settings Software versions
    Click    //button[normalize-space()='Upload']
    ${promise}=    Promise To Upload File    ${work_dir}${upgrade_file}
    Click    //button[normalize-space()='Choose file']
    ${upload_result}=    Wait For    ${promise}
    Click    //div[@class='d-inline-block']//button[@type='button'][normalize-space()='Upload']
    Sleep    5s
    Wait For Elements State    //ul[@class='notification-holder slide-in-offset']    detached    timeout=3000 s

Fleet Export Site
    Open Login Page
    Enter Credentials
    Go to setup Maps
    Click    //button[normalize-space()='Create/Edit']    #Create/Edit button
    Click    div.inline-editor:not(div.mb-4) > div > div.col.col-auto.pl-0 > div > button > i    #3 dot button
    ${dl_promise}    Promise To Wait For Download    C:\\E2E_testing\\${exported_site}
    Click    //div[@class='wrapper nav bottom']//div//nav[@class='uses-custom-vertical-scrollbar']//div[@class='title'][normalize-space()='Export']
    ${file_obj}=    Wait For    ${dl_promise}

Fleet Import Site
    Open Login Page
    Enter Credentials
    Go to setup Maps
    Click    //button[normalize-space()='Create/Edit']    #Create/Edit button
    ${promise}=    Promise To Upload File    ${work_dir}${import_site_file}
    Click    //button[normalize-space()='Import site']    #Import site button
    ${upload_result}=    Wait For    ${promise}
    Get Text    //span[normalize-space()='test_site']    ==    test_site

Fleet Activate Site
    #TODO
    Open Login Page
    Enter Credentials
    Go to setup Maps
    Click    //button[normalize-space()='Create/Edit']    #Create/Edit button

Fleet Factory Reset
    #TODO - Check reset
    Open Login Page
    Enter Credentials
    Go to Settings System
    Click    (//div[@class='card box pb-2 text-center'])[6]    #Restart and reset button
    Click    //button[normalize-space()='Factory reset']    #Factory reset button
    Click    //button[normalize-space()='Reset']    #Reset button

Fleet Add Robots Reset
    #TODO - Factory reset and active
    Open Login Page
    Enter Credentials
    Go to setup Robots
    Click    //button[normalize-space()='Add a robot manually']
    Fill text    //div[@class='form-field']//input[@class='input']    ${robot_ip}
    Click    //button[@class='toggle primary off']    #Factroy reset toggle
    Click    //button[normalize-space()='Add']    #Add button

Fleet Add Robots
    #TODO - Active only
    Open Login Page
    Enter Credentials
    Go to setup Robots
    Click    //button[normalize-space()='Add a robot manually']
    Fill text    //div[@class='form-field']//input[@class='input']    ${robot_ip}
    Click    //button[normalize-space()='Add']    #Add button

Fleet Site Sync
    #TODO

Fleet Link to Robot
    #TODO

Create Empty Mission
    Open Login Page
    Enter Credentials
    Go to setup Missions
    Click    //button[normalize-space()='Create']
    Fill text    //*[@id="create-mission-form"]/div[1]/input    RF_Test_Mission
    Click    //button[@type='submit']
    Get Text    //*[@id="app"]/div[1]/main/section/header/div/div/div[1]/div[1]/h1    ==    RF_Test_Mission

Fleet Schedule mission
    #TODO
    Open Login Page
    Enter Credentials
    Go to setup Mission scheduler
    Click    //button[normalize-space()='Schedule mission']

*** Keywords ***
Open Login Page
    New Browser    chromium    headless=True
    #${fleet_ip} =    Get Value From User    Input the ip address of the fleet used for testing.    10.51.164.0
    New Page    http://${fleet_ip}/

Enter Credentials
    Fill text    //*[@id="login-page"]/div/div[2]/div[1]/div[2]/div/section[1]/form/input    service
    Fill text    //*[@id="login-page"]/div/div[2]/div[1]/div[2]/div/section[1]/form/div[1]/input    mir4service
    Click    //button[.//text() = 'Sign in']

Get Fleet Name
    ${text} =    Get Text    //div[@id='login-page']//div//div//div//div//div//h1
    Set Global Variable    ${text}

Get Fleet SW
    ${text} =    Get Text    //span[@class='text-primary']
    Set Global Variable    ${text}

Get Fleet Site
    ${text} =    Get Text    div.inline-editor:not(div.mb-4) > div > div:nth-child(1) > span
    Set Global Variable    ${text}

API Session
    #Create Session    testrail    https://mirrobots.testrail.net    headers={'Authorization': 'Basic YWNockBtaXItcm9ib3RzLmNvbTpValVpT1ZiNng1aWM0bVRwcG9mUA==', 'Content-Type': 'application/json'}

Add Results
    #[Arguments]    ${test_run_nr}    ${case_id}    ${status_id}    ${comment}
    #${data}=    catenate    {    "results": [    {    "case_id": ${case_id},    "status_id": ${status_id},    "comment": "${comment}"    }    ]    }
    #${resp}=    POST On Session    testrail    /index.php?/api/v2/add_results_for_cases/${test_run_nr}    data=${data}

Go to setup ${arg1}
    Click    .icon-setup
    Click    //div[normalize-space()='${arg1}']

Go to settings ${arg1}
    Click    .icon-settings
    Click    //div[contains(text(),'${arg1}')]
