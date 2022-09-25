*** Settings ***
Library    SeleniumLibrary

*** Variables ***
@{reasonName}=     financial-priorities   stop-trading    not-interested    another-website    not-user-friendly    difficult-transactions    lack-of-features    unsatisfactory-service    other-reasons
@{threeCheckbox}=    financial-priorities   stop-trading    not-interested   
@{remainingCheckbox}=     another-website    not-user-friendly    difficult-transactions    lack-of-features    unsatisfactory-service    other-reasons
${sharingTextfield}=    //*[@name="other_trading_platforms"]
${improvementTextfield}=    //*[@name="do_to_improve"]
${Input}=    I prefer to use other platform such as ABCFX and 123Toro. These platform are easier to use.
${ErrorInput}=    !@#$%^&*)($#@$@%!@#)官方
${continueButton}=    //*[@class="dc-btn dc-btn__effect dc-btn--primary dc-btn__large"]
${goBackButton}=    //*[@class="dc-text dc-btn__text" and contains(text(),'Go Back')]
${warningMessage}=    //div[@class='dc-modal']//div[contains(@class,'account-closure-warning-modal')]

*** Test Cases ***
Login To Deriv
    Open Browser    https://app.deriv.com/account/closing-account   chrome
    Maximize Browser Window

Log in with Email and Password
    Wait Until Page Contains Element    //input[@type='email']    10
    Input Text    //input[@type='email']    <YOUREMAIL>       # to remove
    Input Text    //input[@type='password']    <YOURPASSWORD>  # to remove
    Click Element    //button[@type='submit'] 

Security and privacy policy
    Wait Until Page Contains Element    //*[@class="link"]
    Wait Until Element Is Enabled    //*[@class="link"]
    Page Should Contain Link    //*[@class="link"]
    Click Element    //*[@class="link"]

User to click “Cancel”
    Wait Until Element Is Enabled    //*[@class="dc-btn dc-btn--secondary dc-btn__large closing-account__button--cancel"]    10
    Click Element    //*[@class="dc-btn dc-btn--secondary dc-btn__large closing-account__button--cancel"]
    Wait Until Page Contains Element    app_contents    10
    Wait Until Element Is Visible    app_contents    10

User to click “Close my account”
    Wait Until Element Is Enabled    //*[@class="dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account"]    10
    Click Element    //*[@class="dc-btn dc-btn--primary dc-btn__large closing-account__button--close-account"] 

User to click on Checkboxes
    FOR    ${checkbox}    IN    @{reasonName}
        Click Element    //*[@name='${checkbox}']//parent::label
        Checkbox Should Be Selected    //*[@name='${checkbox}']   
        Click Element    //*[@name='${checkbox}']//parent::label
        Checkbox Should Not Be Selected    //*[@name='${checkbox}'] 
    END

User to click more than 3 Checkboxes
    FOR  ${checkbox}  IN  @{threeCheckbox}
        Click Element    //*[@name='${checkbox}']//parent::label
        Checkbox Should Be Selected    //*[@name='${checkbox}']   
    END
    
    FOR  ${checkbox}  IN  @{remainingCheckbox}
        Checkbox Should Not Be Selected    //*[@name='${checkbox}']  
    END
    
User to enter input in Sharing Textfield
    Click Element    ${sharingTextfield}
    Input Text    ${sharingTextfield}    ${Input}
    Element Should Be Enabled    ${continueButton}

No input from user in Sharing Textfield
    Press Keys    ${sharingTextfield}    CTRL+a\ue003
    Element Should Be Enabled    ${continueButton}

User to enter special characters in Sharing Textfield
    Input Text    ${sharingTextfield}    ${ErrorInput}
    Element Should Be Disabled    ${continueButton}

User to enter “Space” as input in Sharing Textfield
  
    Press Keys    ${sharingTextfield}    CTRL+a\ue003
    Press Keys    ${sharingTextfield}    SPACE
    Page Should Contain Element    //*[@class="dc-text closing-account-reasons__hint" and contains(text(),'Remaining characters: 109')]

User to enter input in Improvement Textfield
    Click Element    ${improvementTextfield}
    Input Text    ${improvementTextfield}    ${Input}
    Element Should Be Enabled    ${continueButton}

No input from user in Improvement Textfield
    Press Keys    ${improvementTextfield}    CTRL+a\ue003
    Element Should Be Enabled    ${continueButton}

User to enter special characters in Improvement Textfield
    Input Text    ${improvementTextfield}    ${ErrorInput}
    Element Should Be Disabled    ${continueButton}

User to enter “Space” as input in Improvement Textfield
    Press Keys    ${improvementTextfield}    CTRL+a\ue003
    Press Keys    ${improvementTextfield}    SPACE
    Page Should Contain Element    //*[@class="dc-text closing-account-reasons__hint" and contains(text(),'Remaining characters: 108')]

User to click “Continue” button
    Click Element    ${continueButton}
    Wait Until Page Contains Element    //*[@class="account-closure-warning-modal"]    10

User to click “Go Back” button 
    Wait Until Page Contains Element   ${warningMessage}    10
    Wait Until Element Is Visible    ${warningMessage}    10
    Element Should Contain    ${warningMessage}    Closing your account will automatically log you out. We shall delete your personal information as soon as our legal obligations are met.
    Click Element    //div[@class='dc-modal']//span[text()='Go Back']/..
   
User to click “Close Account" button
    Click Element    ${continueButton}
    Wait Until Page Contains Element    //*[@class="account-closure-warning-modal"]    10
    Wait Until Page Contains Element   ${warningMessage}    10
    Wait Until Element Is Visible    ${warningMessage}    10
    Element Should Contain    ${warningMessage}    Closing your account will automatically log you out. We shall delete your personal information as soon as our legal obligations are met.
    Click Element    //div[@class='dc-modal']//span[text()='Close account']/..
    Wait Until Element Contains    //div[@class='dc-modal']    We’re sorry to see you leave. Your account is now closed.
    Close Browser

Re-login to account after deactivation
    Open Browser    https://app.deriv.com/account/closing-account   chrome
    Maximize Browser Window
    Wait Until Page Contains Element    //input[@type='email']    10
    Input Text    //input[@type='email']    <YOUREMAIL>       # to remove
    Input Text    //input[@type='password']    <YOURPASSWORD>  # to remove
    Click Element    //button[@type='submit'] 
    Page Should Contain Element    //div[@class="reactivate-account"]//h2[text()='Want to start trading on Deriv again?']