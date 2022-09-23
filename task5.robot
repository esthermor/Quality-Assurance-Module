*** Settings ***
Library    SeleniumLibrary   
Library    String

*** Variables ***
${dealCancellationFee}    //*[@class="trade-container__price-info-currency"]  
${valueOne}=    1
   

*** Keywords ***
Change Volatility
    Click Element     //*[@class="cq-symbol-select-btn"]
    Wait Until Page Contains Element    //*[@class="sc-mcd__filter__item sc-mcd__filter__item--selected"]    10
    Click Element    //*[@class="sc-mcd__item sc-mcd__item--R_50 "]

Change Contract Type
    Click Element    //*[@id="dt_contract_dropdown"]
    Wait Until Page Contains Element    dt_contract_multiplier_item    10
    Click Element    dt_contract_multiplier_item         

*** Test Cases ***
Login To Deriv
    Open Browser    https://app.deriv.com/    chrome
    Maximize Browser Window
    Wait Until Page Contains Element    //div[@class='btn-purchase__text_wrapper' and contains(.,'Rise')]    60
    Click Element    dt_login_button 
    Wait Until Page Contains Element    //input[@type='email']    10

Log in with Email and Password
    Input Text    //input[@type='email']        # to remove
    Input Text    //input[@type='password']             # to remove
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

Change Volatility to 50
    Change Volatility
    Wait Until Page Does Not Contain Element    //*[@aria-label="Loading interface..."]    10
    Wait Until Page Contains Element    //*[@class="stx-holder stx-panel-chart"]    10

Change Contract Type to Multiplier
    Wait Until Page Contains Element    //*[@class="sidebar__items"]    10
    Change Contract Type

Verify Stake
    Wait Until Page Contains Element    //*[@class="trade-container__fieldset-info trade-container__fieldset-info--left" and contains(text(),'Stake')]    10

Verify Take Profit
    Wait Until Page Contains Element    //*[@class="dc-text dc-checkbox__label take_profit-checkbox__label" and contains(text(),'Take profit')]    10

Verify Stop Loss
    Wait Until Page Contains Element    //*[@class="dc-text dc-checkbox__label stop_loss-checkbox__label" and contains(text(),'Stop loss')]    10

Verify Deal Cancellation
    Wait Until Page Contains Element    //*[@class="dc-text dc-checkbox__label" and contains(text(),'Deal cancellation')]    10

Verify Multiplier
    Click Element    //*[@class="dc-dropdown__display dc-dropdown__display--no-border"]
    Wait Until Page Contains Element    //*[@class="dc-themed-scrollbars dc-themed-scrollbars__autohide"]    10
    Wait Until Page Contains Element    //*[@class="dc-list__item dc-list__item--selected" and @id='20']    10

    FOR  ${id}  IN  40    60    100    200
        Page Should Contain Element    //*[@class="dc-list__item" and @id='${id}']
    END

Verify Correlation between Cancellation Fee and Stake
# Deal Cancellation Fee when Stake is 10 USD
    Click Element    //*[@class="dc-checkbox"]
    Wait Until Page Contains Element    ${dealCancellationFee}    10
    ${stake10}=    Get Text    ${dealCancellationFee}
    ${stake10}=    Replace String    ${stake10}    USD    ${EMPTY}       

# Deal Cancellation Fee when Stake is 15 USD
    Click Element    //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input"]
    Press Keys       //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input"]    CTRL+a\ue003
    Input Text    //*[@class="dc-input-wrapper__input input--has-inline-prefix input input--error trade-container__input"]    15
    Wait Until Element Is Enabled    dt_purchase_multup_button    10
    ${stake15}=    Get Text    ${dealCancellationFee} 
    ${stake15}=    Replace String    ${stake15}    USD    ${EMPTY}   

   Should Be True   ${stake15}>${stake10}
   
Verify Maximum Stake is 2000 USD
    Click Element    //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input"]
    Press Keys       //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input"]    CTRL+a\ue003
    ${more_Than_2000USD}    Input Text    //*[@class="dc-input-wrapper__input input--has-inline-prefix input input--error trade-container__input"]    2001
    Should Not Be True   ${more_Than_2000USD}       

Verify Mimimum Stake is 1 USD
    Click Element    //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input"]
    Press Keys       //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input"]    CTRL+a\ue003
    ${less_Than_1USD}    Input Text    //*[@class="dc-input-wrapper__input input--has-inline-prefix input input--error trade-container__input"]    0
    Should Not Be True   ${less_Than_1USD} 

Verify Single Click on Plus Button of Take Profit
    Click Element    //*[@class="dc-checkbox take_profit-checkbox__input"]
    Click Element    //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input"]
    ${originalValue}    Get Value    //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input" and @value='0']
    Click Element    dc_take_profit_input_add
    ${clickPlus}    Get Value    //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input" and @value='1']
    ${clickPlus}    Convert To Number    ${clickPlus}
    ${addByOne}    Evaluate    ${originalValue}+${valueOne}    
    Should Be Equal    ${clickPlus}  ${addByOne}    

Verify Single Click on Minus Button of Take Profit
    ${clickPlus}    Get Value    //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input" and @value='1']
    Click Element    dc_take_profit_input_sub
    ${clickMinus}    Get Value    //*[@class="dc-input-wrapper__input input--has-inline-prefix input trade-container__input" and @value='0']
    ${clickMinus}    Convert To Number    ${clickMinus}
    ${minusByOne}    Evaluate    ${clickPlus}-${valueOne}
    Should Be Equal    ${clickMinus}  ${minusByOne}    

Verify Deal Cancellation Parameter
    Click Element    //*[@class="dc-checkbox"]
    Click Element    //*[@class="dc-text dc-dropdown__display-text" and contains(text(),'60 minutes')]
    FOR  ${id}    IN  5    10    15    30 
        Page Should Contain Element    //*[@class="dc-list__item" and @id='${id}m']
    END

    Wait Until Page Contains Element    //*[@class="dc-list__item dc-list__item--selected" and @id='60m']    10







    



  