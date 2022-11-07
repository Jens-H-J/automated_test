*** Settings ***
Library           BuiltIn
Library           OperatingSystem
Library           Browser

*** Variables ***
${Fleet_IP}       10.51.164.108    #Change to the desired fleet to update
${Test_Case}      1. Dock to a marker    #Test case
${Edit_button}    1    #Edit a mission: mus chance each new mission
${PLC_Register}    1
${PLC_Value}      1    #Values + TestID
${PLC_TestID}     197204
${Marker_Id}      VL-Marker
${Docking_marker}    X
${Loop_Iterations}    10
${Relative_move_X}    1
${Relative_move_Y}    1
${Relative_move_O}    1
${Move_Position}    x

*** Test Cases ***
login to the robot
    browser page robot
    Login

Before PLC Case
    Set Suite Variable    ${Edit_button}    1
    Set Suite Variable    ${PLC_Rigister}    20
    Set suite Variable    ${PLC_Value}    1

Before relative move
    Set Suite Variable    ${Edit_button}    1
    Set Suite Variable    ${Relative_move_X}    1
    Set Suite Variable    ${Relative_move_Y}    1
    Set suite Variable    ${Relative_move_O}    1

Create Docker mission
    browser page robot
    Login
    Go to missions
    Create empty Mission
    Set Suite Variable    ${Edit_button}    1
    Set Suite Variable    ${PLC_Register}    20
    Set suite Variable    ${PLC_Value}    0
    PLC
    Set Suite Variable    ${Edit_button}    2
    Set Suite Variable    ${PLC_Register}    21
    Set suite Variable    ${PLC_Value}    0
    PLC
    Set Suite Variable    ${Edit_button}    3
    Set Suite Variable    ${PLC_Register}    22
    Set Suite Variable    ${PLC_Value}    0
    PLC
    Try/catch
    Set Suite Variable    ${Edit_button}    5
    loop
    Set Suite Variable    ${Edit_button}    6
    Set Suite Variable    ${Docking_marker}    MiR Charge 24V
    Docker move
    Set Suite Variable    ${Edit_button}    7
    Set Suite Variable    ${Relative_move_X}    -5
    Set Suite Variable    ${Relative_move_Y}    0
    Set suite Variable    ${Relative_move_O}    0
    Relative move
    Set Suite Variable    ${Edit_button}    8
    Set Suite Variable    ${Move_Position}    Staging position
    Move
    Click    (//div[normalize-space()='Try'])[1]
    Set Suite Variable    ${Edit_button}    9
    Set Suite Variable    ${PLC_Register}    20
    Set suite Variable    ${PLC_Value}    1
    PLC
    Set Suite Variable    ${Edit_button}    10
    Set Suite Variable    ${PLC_Register}    21
    Set suite Variable    ${PLC_Value}    1
    PLC
    Set Suite Variable    ${Edit_button}    11
    Set Suite Variable    ${PLC_Register}    22
    Set Suite Variable    ${PLC_Value}    197204
    PLC
    Click    (//div[normalize-space()='Catch'])[1]
    Set Suite Variable    ${Edit_button}    12
    Set Suite Variable    ${PLC_Register}    20
    Set suite Variable    ${PLC_Value}    1
    PLC
    Set Suite Variable    ${Edit_button}    13
    Set Suite Variable    ${PLC_Register}    21
    Set suite Variable    ${PLC_Value}    5
    PLC
    Set Suite Variable    ${Edit_button}    14
    Set Suite Variable    ${PLC_Register}    22
    Set Suite Variable    ${PLC_Value}    197204
    PLC
    Save

*** Keywords ***
browser page robot
    New Browser    chromium    headless=False    # Open New Browser
    New Page    http://${Fleet_IP}/    # Go to Robot IP

Login
    Type Text    //*[@id="login-page"]/div/div[2]/div[1]/div[2]/div/section[1]/form/input    service    #username
    Type Text    //*[@id="login-page"]/div/div[2]/div[1]/div[2]/div/section[1]/form/div[1]/input    mir4service    #password
    Click    //button[contains(text(),'Sign in')]

Login Fail
    Type Text    //*[@id="login-page"]/div/div[2]/div[1]/div[2]/div/section[1]/form/input    #noinput
    Type Text    //*[@id="login-page"]/div/div[2]/div[1]/div[2]/div/section[1]/form/div[1]/input    #nopassword

Go to missions
    Click    //body/div[@id='app']/div[1]/main[1]/aside[1]/nav[1]/section[1]/a[2]
    Click    //body/div[@id='app']/div[1]/main[1]/aside[1]/nav[2]/section[1]/a[8]

Create empty Mission
    Click    //button[contains(text(),'Create')]
    Type Text    //*[@id="create-mission-form"]/div/input    ${Test_case}
    Select options by    //body/div[@id='app']/div[1]/main[1]/section[1]/section[1]/div[4]/aside[1]/section[1]/form[1]/div[2]/div[1]/select[1]    Text    Jens
    Select options by    //body/div[@id='app']/div[1]/main[1]/section[1]/section[1]/div[4]/aside[1]/section[1]/form[1]/div[3]/div[1]/select[1]    Text    YOYO_Test
    Click    //body/div[@id='app']/div[1]/main[1]/section[1]/section[1]/div[4]/aside[1]/footer[1]/div[1]/button[1]

Docker move
    Click    //body/div[@id='app']/div[@template-display='main']/main/section/section/nav/div/ul/li[1]/div[1]/button[1]
    Click    (//button[normalize-space()='Docking'])[1]
    Click    (//button[@title="Edit"])[${Edit_button}]
    Select options by    (//select[@class='select'])[1]    Text    ${Docking_marker}
    Click    (//button[normalize-space()='Update'])[1]

Try/catch
    Click    //body/div[@id='app']/div[@template-display='main']/main/section/section/nav/div/ul/li[4]/div[1]/button[1]
    Click    //button[normalize-space()='Try/Catch']
    Click    (//div[normalize-space()='Try'])[1]

Save
    Click    //button[normalize-space()='Save']

Loop
    Click    //body/div[@id='app']/div[@template-display='main']/main/section/section/nav/div/ul/li[3]/div[1]/button[1]
    Click    //button[normalize-space()='Loop']
    Click    (//button[@title="Edit"])[${Edit_button}]
    Click    (//button[@class='toggle primary on'])[1]
    Type text    (//input[@type='text'])[1]    ${Loop_Iterations}
    Click    (//button[normalize-space()='Update'])[1]
    Click    (//div[@class='scope-head small'])[1]

PLC
    Click    //body/div[@id='app']/div[@template-display='main']/main/section/section/nav/div/ul/li[6]/div[1]/button[1]
    Click    (//button[normalize-space()='Set PLC register.'])[1]
    Click    (//button[@title="Edit"])[${Edit_button}]
    Select options by    (//select)[1]    Text    ${PLC_Register}
    Type text    (//input[@type='text'])[1]    ${PLC_Value}
    Click    //button[normalize-space()='Update']

Relative move
    Click    //body/div[@id='app']/div[@template-display='main']/main/section/section/nav/div/ul/li[1]/div[1]/button[1]
    Click    (//button[normalize-space()='Relative move'])[1]
    Click    (//button[@title="Edit"])[${Edit_button}]
    Type text    (//input[@type='text'])[1]    ${Relative_move_X}
    Type text    (//input[@type='text'])[2]    ${Relative_move_Y}
    Type text    (//input[@type='text'])[3]    ${Relative_move_O}
    Click    (//button[normalize-space()='Update'])[1]

Move
    Click    //body/div[@id='app']/div[@template-display='main']/main/section/section/nav/div/ul/li[1]/div[1]/button[1]
    Click    (//button[@type='button'][normalize-space()='Move'])[2]
    Click    (//button[@title="Edit"])[${Edit_button}]
    Select options by    (//select[@class='select'])[1]    Text    ${Move_position}
    Click    (//button[normalize-space()='Update'])[1]
