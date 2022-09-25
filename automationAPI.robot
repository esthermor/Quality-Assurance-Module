*** Settings ***
Library    SeleniumLibrary   

*** Variables ***
${createButton}    //*[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-btn__button-group da-api-token__button"]
${tokenTextfield}    //*[@name='token_name']
${copyIcon}    //*[@class="dc-icon dc-clipboard"]

*** Keywords ***
User to delete Token
    Wait Until Element Is Enabled    //*[@class="dc-icon dc-clipboard da-api-token__delete-icon"]
    Click Element    //*[@class="dc-icon dc-clipboard da-api-token__delete-icon"]
    Wait Until Element Is Enabled    //*[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button"]  
    Click Element    //*[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button"]  

User to click “Create” button
    Click Element    ${tokenTextfield}
    Press Keys    ${tokenTextfield}    CTRL+a\ue003
    Input Text    ${tokenTextfield}    BeSquareToken
    Element Should Be Enabled    ${createButton}
    Click Element    ${createButton}  

*** Test Cases ***
Login To Deriv
    Open Browser    https://app.deriv.com/account/api-token    chrome
    Maximize Browser Window
    Wait Until Page Contains Element    //input[@type='email']    10

Log in with Email and Password
    Input Text    //input[@type='email']    <YOUREMAIL>    # to remove
    Input Text    //input[@type='password']    <YOURPASSWORD>          # to remove
    Click Element    //button[@type='submit'] 

Verify Real Account
    Wait Until Page Does Not Contain Element    //*[@aria-label="Loading interface..."]    10
    Wait Until Page Contains Element    dt_core_account-info_acc-info    30
    Wait Until Page Contains Element    //*[@class='dc-icon acc-info__id-icon acc-info__id-icon--usd']    30
    Wait Until Element Is Visible    //button[@class='dc-btn dc-btn__effect dc-btn--primary acc-info__button']     30  

Switch to Demo Account 
    Click Element     dt_core_account-info_acc-info
    Click Element    dt_core_account-switcher_demo-tab
    Click Element    //span[@class="acc-switcher__id"]
    Wait Until Page Does Not Contain Element    //*[@aria-label="Loading interface..."]    30
    Wait Until Element Is Visible    //*[@class="dc-icon acc-info__id-icon acc-info__id-icon--virtual"]    30

Checkbox for "Read" scope
    Wait Until Page Does Not Contain Element    //*[@class="initial-loader__barspinner barspinner barspinner-light"]    10
    Wait Until Element Is Visible    //*[@class="da-api-token__checkbox-wrapper"]    10
    Wait Until Element Is Enabled    //*[@class="da-api-token__checkbox-wrapper"]    10
    Click Element    //*[@name="read"]//parent::label
    Wait Until Page Contains Element    //*[@name='read' and @value='true']//parent::label  
    
Checkbox for "Trade" scope
    Wait Until Page Does Not Contain Element    //*[@class="initial-loader__barspinner barspinner barspinner-light"]    10
    Wait Until Element Is Visible    //*[@class="da-api-token__checkbox-wrapper"]    10
    Wait Until Element Is Enabled    //*[@class="da-api-token__checkbox-wrapper"]    10
    Click Element    //*[@name="trade"]//parent::label

Verify if "Trade" checkbox is checked
    Wait Until Page Contains Element    //*[@name='trade' and @value='true']//parent::label  


Checkbox for "Payments" scope
    Wait Until Page Does Not Contain Element    //*[@class="initial-loader__barspinner barspinner barspinner-light"]    10
    Wait Until Element Is Visible    //*[@class="da-api-token__checkbox-wrapper"]    10
    Wait Until Element Is Enabled    //*[@class="da-api-token__checkbox-wrapper"]    10
    Click Element    //*[@name="payments"]//parent::label

Verify if "Payments" checkbox is checked
    Wait Until Page Contains Element    //*[@name='payments' and @value='true']//parent::label  

Checkbox for "Trading information" scope
    Wait Until Page Does Not Contain Element    //*[@class="initial-loader__barspinner barspinner barspinner-light"]    10
    Wait Until Element Is Visible    //*[@class="da-api-token__checkbox-wrapper"]    10
    Wait Until Element Is Enabled    //*[@class="da-api-token__checkbox-wrapper"]    10
    Click Element    //*[@name="trading_information"]//parent::label

Verify if "Trading information" checkbox is checked
    Wait Until Page Contains Element    //*[@name='trading_information' and @value='true']//parent::label  

Checkbox for "Admin" scope
    Wait Until Page Does Not Contain Element    //*[@class="initial-loader__barspinner barspinner barspinner-light"]    10
    Wait Until Element Is Visible    //*[@class="da-api-token__checkbox-wrapper"]    10
    Wait Until Element Is Enabled    //*[@class="da-api-token__checkbox-wrapper"]    10
    Click Element    //*[@name="admin"]//parent::label

Verify if "Admin" checkbox is checked
    Wait Until Page Contains Element    //*[@name='admin' and @value='true']//parent::label  

# Token Name
No input from user
    Click Element    ${tokenTextfield}
    Element Should Be Disabled    ${createButton}

User to input valid Token Name
    Click Element    ${tokenTextfield}
    Input Text    ${tokenTextfield}    BeSquareToken
    ${tokenName}    Get Value    ${tokenTextfield}
    Element Should Be Enabled    ${createButton}

# On "Create" Button
    User to click “Create” button
    Wait Until Page Contains Element    //*[@class="da-api-token__table"]    10
    
# Compare user input and generated Token Name
    Wait Until Page Contains Element    //*[@class="dc-text" and contains(text(),'BeSquareToken')]
    ${tokenNameCreated}    Get Text        //*[@class="dc-text" and contains(text(),'BeSquareToken')]
    Should Be Equal    ${tokenName}    ${tokenNameCreated}
    # User to delete Token

User to input symbols, special characters 
    Click Element    ${tokenTextfield}
    Press Keys    ${tokenTextfield}    CTRL+a\ue003
    Input Text    ${tokenTextfield}    !!@#@#!#
    Wait Until Page Contains Element    ${createButton}    10
    Element Should Be Disabled    ${createButton}

User to input less than 2 characters
    Click Element    ${tokenTextfield}
    Press Keys    ${tokenTextfield}    CTRL+a\ue003
    Input Text    ${tokenTextfield}    a
    Element Should Be Disabled    ${createButton}

User to input more than 32 characters
    Click Element    ${tokenTextfield}
    Press Keys    ${tokenTextfield}    CTRL+a\ue003
    Input Text    ${tokenTextfield}    abcdefrgthujiknmclopdervhyhjildlpoijhytr
    Element Should Be Disabled    ${createButton}

# On "Copy" Icon
User to copy masked Token 
    Wait Until Page Contains Element    //*[@class="da-api-token__pass-dot-container"]    10
    Element Should Be Enabled    ${copyIcon}
    Click Element    ${copyIcon}
    Element Should Be Enabled    //*[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button"]
    Click Element    //*[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button"]
    Page Should Contain Element    //*[@class="dc-text dc-popover__bubble__text" and contains(text(),'Token copied!')]

User to copy unmasked Token 
    Element Should Be Enabled    //*[@class="dc-icon da-api-token__visibility-icon"]
    Wait Until Page Contains Element    //div[@class="da-api-token__clipboard-wrapper"]   10
    Element Should Be Enabled    ${copyIcon}
    Click Element    ${copyIcon}
    Element Should Be Enabled    //*[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button"]
    Click Element    //*[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button"]
    Page Should Contain Element    //*[@class="dc-text dc-popover__bubble__text" and contains(text(),'Token copied!')]

User to click on “Cancel” for delete
    Wait Until Element Is Enabled    //*[@class="dc-icon dc-clipboard da-api-token__delete-icon"]
    Click Element    //*[@class="dc-icon dc-clipboard da-api-token__delete-icon"]
    Wait Until Element Is Enabled    //*[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large dc-dialog__button"]  
    Click Element    //*[@class="dc-btn dc-btn__effect dc-btn--secondary dc-btn__large dc-dialog__button"]

Compare tokens with same Token Name
    Wait Until Page Does Not Contain Element    //*[@class="initial-loader__barspinner barspinner barspinner-light"]    10
    Wait Until Element Is Visible    //*[@class="da-api-token__checkbox-wrapper"]    10
    Wait Until Element Is Enabled    //*[@class="da-api-token__checkbox-wrapper"]    10
    Click Element    //*[@name="read"]//parent::label
    Wait Until Page Contains Element    //*[@name='read' and @value='true']//parent::label 
    User to click “Create” button
    User to delete Token
    
    # Compare Token with Token Name 'BeSquare'
    Wait Until Element Is Visible   //*[@class="dc-icon da-api-token__visibility-icon"]    10
    # Click Element    //*[@class="dc-icon da-api-token__visibility-icon"]
    Should Be Equal    //*[@class="da-api-token__pass-dot-container"]    //*[@class="da-api-token__pass-dot-container"]

Compare tokens with different Token Name
    # To select scopre "Read" first
    Wait Until Page Does Not Contain Element    //*[@class="initial-loader__barspinner barspinner barspinner-light"]    10
    Wait Until Element Is Visible    //*[@class="da-api-token__checkbox-wrapper"]    10
    Wait Until Element Is Enabled    //*[@class="da-api-token__checkbox-wrapper"]    10
    Click Element    //*[@name="read"]//parent::label
    Wait Until Page Contains Element    //*[@name='read' and @value='true']//parent::label 
    
    # Create token 'QA123'
    Click Element    ${tokenTextfield}
    Input Text    ${tokenTextfield}    QA123
    Wait Until Page Contains Element    ${createButton}    10
    Element Should Be Enabled    ${createButton}
    Click Element    ${createButton} 
    
    # Compare Token with Token Name 'BeSquare' and 'QA123'
    Click Element    //*[@class="dc-icon da-api-token__visibility-icon"]
    Should Be Equal    //*[@class="da-api-token__pass-dot-container"]    //*[@class="da-api-token__pass-dot-container"]

Verify Scopes of Token
    ${scopeCreated}    Get Text    //*[@class="da-api-token__table-scope-cell" and contains(text(),'Read')]
    ${scope}    Get Text    //*[@name='read' and @value='true']//parent::label 
    Should Be Equal    ${scopeCreated}    ${scope}
    User to delete Token

    
