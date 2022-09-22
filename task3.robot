*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Change to AUD/JPY
    Click Element     //*[@class="cq-symbol-select-btn"]
    Click Element    //*[@class="sc-mcd__filter__item " and contains(text(),'Forex')]
    Click Element    //*[@class="sc-mcd__item sc-mcd__item--frxAUDJPY "]

Change Contract Type
   Click Element    //*[@id="dt_contract_dropdown"]
    Wait Until Page Contains Element    dt_contract_high_low_item    10
    Click Element    dt_contract_high_low_item

*** Test Cases ***
Buy Lower Contract
    
    #Login 
    Open Browser    https://app.deriv.com/    chrome
    Maximize Browser Window
    Wait Until Page Contains Element    //div[@class='btn-purchase__text_wrapper' and contains(.,'Rise')]    60
    Click Element    dt_login_button 
    Wait Until Page Contains Element    //input[@type='email']    10
    Input Text    //input[@type='email']    esther@besquare.com.my    # to remove
    Input Text    //input[@type='password']    Esther@970630          # to remove
    Click Element    //button[@type='submit'] 
    Wait Until Page Does Not Contain Element    //*[@aria-label="Loading interface..."]    10
    Wait Until Page Contains Element    dt_core_account-info_acc-info    30
    Wait Until Page Contains Element    //*[@class='dc-icon acc-info__id-icon acc-info__id-icon--usd']    30
    Wait Until Element Is Visible    //button[@class='dc-btn dc-btn__effect dc-btn--primary acc-info__button']     30   
    Click Element     dt_core_account-info_acc-info
    Click Element    dt_core_account-switcher_demo-tab
    Click Element    //span[@class="acc-switcher__id"]
    Wait Until Page Does Not Contain Element    //*[@aria-label="Loading interface..."]    10
    Wait Until Element Is Visible    //*[@class="dc-icon acc-info__id-icon acc-info__id-icon--virtual"]    30

    # Change to AUD/JPY
    Change to AUD/JPY
    Wait Until Page Does Not Contain Element    //*[@aria-label="Loading interface..."]    10

    # Change contract type
    Wait Until Page Contains Element    //*[@class="sidebar__items"]    10
    Change Contract Type
 
    # Input Days
    Click Element    //*[@class="dc-input__field"]
    Press Keys    //*[@class="dc-input__field"]    \ue003\ue003
    Input Text    //*[@class="dc-input__field"]    4

    # Click payout
    Click Element    dc_payout_toggle_item
    Click Element    //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input"]
    Press Keys    //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input"]    \ue003\ue003
    Input Text    //*[@class="dc-input-wrapper__input input--has-inline-prefix input input--error trade-container__input"]    15.50

    # Buy 
    Wait Until Page Contains Element    //*[@class="btn-purchase btn-purchase--2"]    10 
    Click Element    //*[@class="btn-purchase btn-purchase--2"]



