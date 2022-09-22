*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Login To Deriv
    Open Browser    https://app.deriv.com/    chrome
    Maximize Browser Window
    Wait Until Page Contains Element    //div[@class='btn-purchase__text_wrapper' and contains(.,'Rise')]    60
    Click Element    dt_login_button 
    Wait Until Page Contains Element    //input[@type='email']    10
    Input Text    //input[@type='email']    esther@besquare.com.my    # to remove
    Input Text    //input[@type='password']    Esther@970630          # to remove
    Click Element    //button[@type='submit'] 

    # Task 1
    Wait Until Page Does Not Contain Element    //*[@aria-label="Loading interface..."]    10
    Wait Until Page Contains Element    dt_core_account-info_acc-info    30
    Wait Until Page Contains Element    //*[@class='dc-icon acc-info__id-icon acc-info__id-icon--usd']    30
    Wait Until Element Is Visible    //button[@class='dc-btn dc-btn__effect dc-btn--primary acc-info__button']     30   
    Click Element     dt_core_account-info_acc-info
    Click Element    dt_core_account-switcher_demo-tab
    Click Element    //span[@class="acc-switcher__id"]
    Wait Until Page Does Not Contain Element    //*[@aria-label="Loading interface..."]    10
    Wait Until Element Is Visible    //*[@class="dc-icon acc-info__id-icon acc-info__id-icon--virtual"]    30

    # Task 2
    Click Element    //*[@class="cq-symbol-select-btn"]
    Wait Until Page Contains Element    //*[@class="sc-mcd__item__name"]    10
    Wait Until Element Is Visible    //*[@class="ic-icon ic-1HZ10V"]    10
    Click Element    //*[@class="sc-mcd__item sc-mcd__item--1HZ10V "]
    Wait Until Page Contains Element    //*[@class="cq-symbol" and contains(text(),'Volatility 10 (1s) Index')]    10    #volatility check
    Wait Until Page Contains Element    //*[@name="contract_type" and contains(text(),'Rise/Fall')]    10    #Rise/Fall check
    Wait Until Page Contains Element    //button[@class="dc-btn dc-btn__toggle dc-button-menu__button dc-button-menu__button--active"]    10    #Check is it Ticks
    Wait Until Page Contains Element    //*[@id='dt_range_slider_label' and contains(text(),'5 Ticks')]    10    # Check is it 5 ticks
    Wait Until Page Contains Element    //*[@class="dc-btn dc-btn__toggle dc-button-menu__button dc-button-menu__button--active"]    10    #Check is it Stake
    Wait Until Page Contains Element    //*[@class='dc-input-wrapper__input input--has-inline-prefix input trade-container__input' and @value='10']    10    #Check is it Stake of 10
    ${before}    Get Text    //*[@class="acc-info__balance"]
    Click Button    dt_purchase_call_button
    Wait Until Page Contains Element    //*[@class="dc-result__caption-wrapper"]    10
    ${after}    Get Text    //*[@class="acc-info__balance"]
    Should Not Be Equal    ${before}    ${after}
    Close Browser


    


