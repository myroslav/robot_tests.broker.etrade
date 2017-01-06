*** Settings ***
Library   Selenium2Screenshots
Library   String
Library   DateTime
Library   Selenium2Library
Library   Collections
Library   etrade_service.py


*** Variables ***
${sign_in}                                                      xpath=//div[contains(@class, 'auth-group')]/a[contains(@class, 'btn-default')]
${login_sign_in}                                                id=UserName
${password_sign_in}                                             id=Password
${locator.status}                                               xpath=//div[contains(@class, 'procurement-status')]/span
${locator.title}                                                xpath=//div[contains(@class, 'heading')]/h2/span
${locator.description}                                          xpath=//div[contains(@class, 'description')]
${locator.minimalStep.amount}                                   xpath=//div[contains (@class, 'lot-minimal-step')]/div/label
${locator.value.amount}                                         xpath=//div[contains (@class, 'lot-amount')]/div/label
${locator.value.currency}                                       xpath=//div[contains (@class, 'lot-amount')]/div/label/small
${locator.value.valueAddedTaxIncluded}                          xpath=//div[contains (@class, 'lot-amount')]/div/span
${locator.tenderId}                                             xpath=//ul[contains (@class, 'details-sidebar-list')]/li[3]/span
${locator.procuringEntity.name}                                 xpath=//ul[contains (@class, 'details-sidebar-list')]/li[1]/span[contains(@class, 'show-company-info')]
${locator.enquiryPeriod.startDate}                              xpath=//div[contains (@class, 'tender-timeline')]/span[2]@title
${locator.enquiryPeriod.endDate}                                xpath=//div[contains (@class, 'tender-timeline')]/span[3]@title
${locator.tenderPeriod.startDate}                               xpath=//div[contains (@class, 'tender-timeline')]/span[4]@title
${locator.tenderPeriod.endDate}                                 xpath=//div[contains (@class, 'tender-timeline')]/span[5]@title
${locator.items[0].quantity}                                    xpath=(//ul[contains (@class, 'items')]/li/div)[2]
${locator.items[0].description}                                 css=.items-dd-text
${locator.items[0].deliveryLocation.latitude}                   xpath=(((//ul[contains (@class, 'items')]/li/div)[4]/div/div)[4]/div)[2]/span
${locator.items[0].deliveryLocation.longitude}                  xpath=(((//ul[contains (@class, 'items')]/li/div)[4]/div/div)[4]/div)[2]/span
${locator.items[0].unit.code}                                   xpath=(//ul[contains (@class, 'items')]/li/div)[2]
${locator.items[0].unit.name}                                   xpath=(//ul[contains (@class, 'items')]/li/div)[2]
${locator.items[0].deliveryAddress.postalCode}                  xpath=((//ul[contains (@class, 'items')]/li/div)[4]/div/div)[4]/div/span
${locator.items[0].deliveryAddress.countryName}                 xpath=((//ul[contains (@class, 'items')]/li/div)[4]/div/div)[4]/div/span
${locator.items[0].deliveryAddress.region}                      xpath=((//ul[contains (@class, 'items')]/li/div)[4]/div/div)[4]/div/span
${locator.items[0].deliveryAddress.locality}                    xpath=((//ul[contains (@class, 'items')]/li/div)[4]/div/div)[4]/div/span
${locator.items[0].deliveryAddress.streetAddress}               xpath=((//ul[contains (@class, 'items')]/li/div)[4]/div/div)[4]/div/span
${locator.items[0].deliveryDate.endDate}                        xpath=(//div[contains (@class, 'items-dd-group')])[1]/span
${locator.items[0].classification.scheme}                       xpath=((//div[contains (@class, 'items-dd')])[1]/div)[1]/span
${locator.items[0].classification.id}                           xpath=((//div[contains (@class, 'items-dd')])[1]/div)[1]/small
${locator.items[0].classification.description}                  xpath=((//div[contains (@class, 'items-dd')])[1]/div)[1]/small
${locator.items[0].additionalClassifications[0].scheme}         xpath=((//div[contains (@class, 'items-dd')])[1]/div)[2]/span
${locator.items[0].additionalClassifications[0].id}             xpath=((//div[contains (@class, 'items-dd')])[1]/div)[2]/small
${locator.items[0].additionalClassifications[0].description}    xpath=((//div[contains (@class, 'items-dd')])[1]/div)[2]/small
${locator.questions[0].title}                                   xpath=//div[contains(@class, 'question-item')]/div/h3
${locator.questions[0].description}                             css=.question
${locator.questions[0].date}                                    xpath=//div[contains(@class, 'question-item')]/div/span
${locator.questions[0].answer}                                  css=.answer


*** Keywords ***
Підготувати клієнт для користувача
  [Arguments]     @{ARGUMENTS}
  [Documentation]  Відкрити брaвзер, створити обєкт api wrapper, тощо
  Open Browser  ${USERS.users['${ARGUMENTS[0]}'].homepage}  ${USERS.users['${ARGUMENTS[0]}'].browser}  alias=${ARGUMENTS[0]}
  Set Window Size       @{USERS.users['${ARGUMENTS[0]}'].size}
  Set Window Position   @{USERS.users['${ARGUMENTS[0]}'].position}
  Run Keyword If   '${ARGUMENTS[0]}' != 'etrade_Viewer'   Login   ${ARGUMENTS[0]}

Login
  [Arguments]  @{ARGUMENTS}
  Click Element   ${sign_in}
  Sleep   1
  Input text      ${login_sign_in}          ${USERS.users['${ARGUMENTS[0]}'].login}
  Input text      ${password_sign_in}       ${USERS.users['${ARGUMENTS[0]}'].password}
  Click Button    css=.btn-lg
  Sleep   2

Пошук тендера по ідентифікатору
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tender_uaid
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
  Input Text      id=Query   ${ARGUMENTS[1]}
  Click Button    css=.filter-srch-btn
  Sleep  10
  click element     id=details
  sleep  1
  Capture Page Screenshot

Оновити сторінку з тендером
    [Arguments]    @{ARGUMENTS}
    [Documentation]    ${ARGUMENTS[0]} = username
    ...      ${ARGUMENTS[1]} = ${TENDER_UAID}
    Selenium2Library.Switch Browser   ${ARGUMENTS[0]}
    #select Window    Title=eTrade - ${ARGUMENTS[1]}
    #close window
    #select window     Title=eTrade
    etrade.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}

Задати питання
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  tenderUaId
  ...      ${ARGUMENTS[2]} ==  questionId
  ${title}=        Get From Dictionary  ${ARGUMENTS[2].data}  title
  ${description}=  Get From Dictionary  ${ARGUMENTS[2].data}  description

  #etrade.Пошук тендера по ідентифікатору    ${ARGUMENTS[0]}    ${ARGUMENTS[1]}
  #Sleep   1
  Click Element                       xpath=(//ul[contains(@class, 'nav')]/li)[3]/a
  Wait Until Page Contains Element    css=.add-question-btn
  sleep     2
  Click Element     css=.add-question-btn
  sleep     2
  Input text                          name=Title                 ${title}
  Input text                          name=Description           ${description}
  Click Element                       id=submit
  Wait Until Page Contains Element            xpath=//div[contains(@class, 'question-item')]/div/h3     30
  capture page screenshot

Отримати інформацію із тендера
  [Arguments]  @{ARGUMENTS}
  [Documentation]
  ...      ${ARGUMENTS[0]} ==  username
  ...      ${ARGUMENTS[1]} ==  fieldname
  ${return_value}=  run keyword  Отримати інформацію про ${ARGUMENTS[1]}
  [return]  ${return_value}

Отримати тест із поля і показати на сторінці
  [Arguments]   ${fieldname}
  ${return_value}=   Get Text  ${locator.${fieldname}}
  [return]  ${return_value}

Отримати тест з атрибуту і показати на сторінці
  [Arguments]   ${fieldname}
  ${return_value}=   get element attribute  ${locator.${fieldname}}
  [return]  ${return_value}

Отримати інформацію про title
  ${return_value}=   Отримати тест із поля і показати на сторінці   title
  [return]  ${return_value}

Отримати інформацію про status
  reload page
  ${return_value}=   Отримати тест із поля і показати на сторінці   status
  ${return_value}=   convert_etrade_string_to_proz_string   ${return_value}
  [Return]  ${return_value}

Отримати інформацію про description
  ${return_value}=   Отримати тест із поля і показати на сторінці   description
  [return]  ${return_value}

Отримати інформацію про value.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці  value.amount
  ${return_value}=   Remove String      ${return_value}     UAH
  ${return_value}=   Convert To Number   ${return_value.replace(' ', '').replace(',', '.')}
  [return]  ${return_value}

Отримати інформацію про minimalStep.amount
  ${return_value}=   Отримати тест із поля і показати на сторінці   minimalStep.amount
  ${return_value}=    Remove String      ${return_value}     UAH
  ${return_value}=    convert to number    ${return_value.replace(' ', '').replace(',', '.')}
  [return]   ${return_value}

Отримати інформацію про items[0].quantity
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].quantity
  ${return_value}=    Convert To Number   ${return_value.split(' ')[0]}
  [return]  ${return_value}

Отримати інформацію про items[0].unit.code
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.code
  ${return_value}=   Convert To String     ${return_value.split(' ')[2]}
  ${return_value}=   Convert To String     ${return_value.replace('(', '').replace(')', '')}
  [return]  ${return_value}

Отримати інформацію про items[0].unit.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].unit.name
  ${return_value}=   Convert To String     ${return_value.split(' ')[1]}
  [return]   ${return_value}

Отримати інформацію про value.currency
  ${return_value}=   Отримати тест із поля і показати на сторінці  value.currency
  [return]  ${return_value}

Отримати інформацію про value.valueAddedTaxIncluded
  ${return_value}=   Отримати тест із поля і показати на сторінці  value.valueAddedTaxIncluded
  ${return_value}=   convert_etrade_string_to_proz_string      ${return_value}
  [return]  ${return_value}

Отримати інформацію про tenderId
  ${return_value}=   Отримати тест із поля і показати на сторінці   tenderId
  [return]  ${return_value}

Отримати інформацію про procuringEntity.name
  ${return_value}=   Отримати тест із поля і показати на сторінці   procuringEntity.name
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.latitude
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.latitude
  ${return_value}=   convert to number   ${return_value.replace('Latitude: ', '').replace('Longitude: ', '').split(' ')[0]}
  [return]  ${return_value}

Отримати інформацію про items[0].deliveryLocation.longitude
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].deliveryLocation.longitude
  ${return_value}=   convert to number    ${return_value.replace('Latitude: ', '').replace('Longitude: ', '').split(' ')[1]}
  [return]  ${return_value}

Отримати інформацію про tenderPeriod.startDate
  ${return_value}=    Отримати тест з атрибуту і показати на сторінці  tenderPeriod.startDate
  ${return_value}=    convert_date_to_etrade_tender_date      ${return_value.split('</br> ')[1]}
  [return]    ${return_value}

Отримати інформацію про tenderPeriod.endDate
  ${return_value}=   Отримати тест з атрибуту і показати на сторінці  tenderPeriod.endDate
  ${return_value}=    convert_date_to_etrade_tender_date    ${return_value.split('</br> ')[1]}
  [return]    ${return_value}

Отримати інформацію про enquiryPeriod.startDate
  ${return_value}=   Отримати тест з атрибуту і показати на сторінці  enquiryPeriod.startDate
  ${return_value}=    convert_date_to_etrade_tender_date   ${return_value.split('</br> ')[1]}
  [return]    ${return_value}

Отримати інформацію про enquiryPeriod.endDate
  ${return_value}=   Отримати тест з атрибуту і показати на сторінці  enquiryPeriod.endDate
  ${return_value}=    convert_date_to_etrade_tender_date    ${return_value.split('</br> ')[1]}
  [return]  ${return_value}

Отримати інформацію про items[0].description
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці   items[0].description
  [return]  ${return_value}

Отримати інформацію про items[0].classification.id
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.id
  [return]  ${return_value.split(' ')[0]}

Отримати інформацію про items[0].classification.scheme
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.scheme
  ${return_value}=    Remove String      ${return_value}     :
  [return]  ${return_value}

Отримати інформацію про items[0].classification.description
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].classification.description
  ${return_value}=   Convert To String     ${return_value.split(' ')[1]}
  ${return_value}=   convert_etrade_string_to_proz_string   ${return_value}
  [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].id
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].id
  [return]  ${return_value.split(' ')[0]}

Отримати інформацію про items[0].additionalClassifications[0].scheme
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].scheme
  ${return_value}=    Remove String      ${return_value}     :
  [return]  ${return_value}

Отримати інформацію про items[0].additionalClassifications[0].description
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].additionalClassifications[0].description
  [return]  ${return_value[8:]}

Отримати інформацію про items[0].deliveryAddress.countryName
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.countryName
  ${return_value}=   convert_etrade_string_to_proz_string    ${return_value.split(', ')[1]}
  [return]   ${return_value}

Отримати інформацію про items[0].deliveryAddress.postalCode
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.postalCode
  [return]  ${return_value.split(', ')[0]}

Отримати інформацію про items[0].deliveryAddress.region
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.region
  ${return_value}=   convert_etrade_string_to_proz_string     ${return_value.split(', ')[2]}
  [return]   ${return_value}

Отримати інформацію про items[0].deliveryAddress.locality
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.locality
  [return]  ${return_value.split(', ')[3]}

Отримати інформацію про items[0].deliveryAddress.streetAddress
  #${item_info_style} =  get element attribute   css=.items-dd@style
  #Run Keyword If   '${item_info_style}' == 'display: none;'  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryAddress.streetAddress
  [return]  ${return_value.split(', ')[4]}

Отримати інформацію про items[0].deliveryDate.endDate
  Click Element  css=.js-items-dd
  ${return_value}=   Отримати тест із поля і показати на сторінці  items[0].deliveryDate.endDate
  ${return_value}=   convert_etrade_delivery_date      ${return_value}
  [return]  ${return_value}

Отримати інформацію про questions[0].title
  Click Element                       xpath=(//ul[contains(@class, 'nav')]/li)[3]/a
  Wait Until Page Contains Element    xpath=//div[contains(@class, 'question-item')]/div/h3
  sleep     2
  click element                       xpath=//div[contains(@class, 'question-item')]/div/h3
  sleep     2
  ${return_value}=  Отримати тест із поля і показати на сторінці    questions[0].title
  [return]  ${return_value}

Отримати інформацію про questions[0].description
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].description
  [return]  ${return_value}

Отримати інформацію про questions[0].date
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].date
  ${return_value}=   convert_date_to_etrade_tender_date  ${return_value}
  [return]  ${return_value}

Отримати інформацію про questions[0].answer
  Click Element                       xpath=(//ul[contains(@class, 'nav')]/li)[3]/a
  Wait Until Page Contains Element    xpath=//div[contains(@class, 'question-item')]/div/h3
  sleep     2
  click element                       xpath=//div[contains(@class, 'question-item')]/div/h3
  Sleep  2
  ${return_value}=   Отримати тест із поля і показати на сторінці   questions[0].answer
  [return]  ${return_value}

Отримати посилання на аукціон для глядача
  [Arguments]  @{ARGUMENTS}
  Selenium2Library.Switch Browser       ${ARGUMENTS[0]}
  Go to   ${USERS.users['${ARGUMENTS[0]}'].homepage}
  Input Text      id=Query   ${ARGUMENTS[1]}
  Click Button    css=.filter-srch-btn
  Sleep  15
  CLICK ELEMENT     xpath=(//a[contains(@href, 'Tender/Details')])[1]
  Select Window    Title=eTrade - ${ARGUMENTS[1]}
  Sleep  15
  reload page
  ${result} =    get element attribute  xpath=//div[contains(@class, 'go-to-auction-btn')]/a@href
  [return]   ${result}

Подати цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ...    ${ARGUMENTS[2]} ==  ${test_bid_data}
    ${amount}=    Get From Dictionary     ${ARGUMENTS[2].data.value}    amount

    #Selenium2Library.Switch Browser       ${ARGUMENTS[0]}
    #Go to   ${USERS.users['${ARGUMENTS[0]}'].default_page}
    #sleep   10
    #Input Text        id=search       ${ARGUMENTS[1]}
    #Click Button    xpath=//button[@type='submit']
    #Sleep   2
    #Click Element   xpath=(//td[contains(@class, 'qa_item_name')]//a)[1]
    #Sleep   180
    #reload page
    Click Element       xpath=//div[contains(@class, 'no-lots')]/div[2]/div/div/a
    Select Window    Title=eTrade - Пропозиція ${ARGUMENTS[1]}
    Input Text          id=ValueAmount        ${amount}

    Click Element       xpath=(//input[contains(@class, 'submit')])[2]
    wait until page contains element  xpath=//div[contains(@class, 'alert alert-success')]
    sleep   60
    reload page
    wait until page contains element  xpath=//div[contains(@class, 'bid-details')]/div[contains(@class,'alert alert-success')]

    ${resp}=    convert to string  success
    [Return]    ${resp}

Скасувати цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  none
    ...    ${ARGUMENTS[2]} ==  tenderId
    Selenium2Library.Switch Browser       ${ARGUMENTS[0]}
    Go to   ${USERS.users['${ARGUMENTS[0]}'].default_page}
    #Input Text        id=search       ${ARGUMENTS[1]}
    #Click Button    xpath=//button[@type='submit']
    Sleep   2
    #Click Element   xpath=(//td[contains(@class, 'qa_item_name')]//a)[1]
    click element   xpath=//a[contains(@href,'/Bid/Details')]
    sleep   2
    Wait Until Page Contains Element      xpath=//input[contains(@class, 'btn-danger')]     20
    Click button        xpath=//input[contains(@class, 'btn-danger')]
    wait until page contains element  xpath=//div[contains(@class, 'alert alert-success')]  60

Змінити цінову пропозицію
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  tenderId
    ...    ${ARGUMENTS[2]} ==  amount
    ...    ${ARGUMENTS[3]} ==  amount.value
    Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
    Go to   ${USERS.users['${ARGUMENTS[0]}'].default_page}
    Sleep   2
    click element   xpath=//a[contains(@href,'/Bid/Details')]
    sleep   2
    click element   xpath=//a[contains(@href, 'Bid/Edit')]
    sleep   2
    Clear Element Text      id=ValueAmount
    Input Text              id=ValueAmount         ${ARGUMENTS[3]}
    sleep   3
    Click Element       xpath=(//input[contains(@class, 'submit')])[1]
    wait until page contains element  xpath=//div[contains(@class, 'alert alert-success')]
    sleep   40
    reload page
    wait until page contains element  xpath=//div[contains(@class, 'bid-details')]/div[contains(@class,'alert alert-success')]


Завантажити документ в ставку
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  file
    ...    ${ARGUMENTS[2]} ==  tenderId
    Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
    Go to   ${USERS.users['${ARGUMENTS[0]}'].default_page}
    Sleep   2
    click element   xpath=//a[contains(@href,'/Bid/Details')]
    sleep   2
    click element   xpath=//a[contains(@href, 'Bid/Edit')]
    sleep   2
    Execute Javascript					document.getElementsByTagName("form")[0].appendChild(document.getElementsByClassName("dz-hidden-input")[0]);
    Execute Javascript					document.getElementsByClassName("dz-hidden-input")[0].removeAttribute("style");

    Choose File     xpath=//input[contains(@type, 'file')]   ${ARGUMENTS[1]}
    sleep   2
    click element   xpath=//div[contains(@class, 'bootstrap-select')]
    sleep   1
    click element   xpath=(//ul[contains(@class, 'dropdown-menu inner')]/li)[3]
    sleep   1
    click element   xpath=//div[contains(@class, 'modal-body')]/div[3]/div/input
    sleep   2
    Click Element       xpath=(//input[contains(@class, 'submit')])[1]
    wait until page contains element  xpath=//div[contains(@class, 'alert alert-success')]
    sleep   40
    reload page
    wait until page contains element  xpath=//div[contains(@class, 'bid-details')]/div[contains(@class,'alert alert-success')]


Змінити документ в ставці
    [Arguments]  @{ARGUMENTS}
    [Documentation]
    ...    ${ARGUMENTS[0]} ==  username
    ...    ${ARGUMENTS[1]} ==  file
    ...    ${ARGUMENTS[2]} ==  tenderId
    Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
    Go to   ${USERS.users['${ARGUMENTS[0]}'].default_page}
    Sleep   2
    click element   xpath=//a[contains(@href,'/Bid/Details')]
    sleep   2
    click element   xpath=//a[contains(@href, 'Bid/Edit')]
    sleep   2
    execute javascript                  window.documentId = $('input[type="hidden"][name="Documents[0].DocumentId"]').val();
    Execute Javascript					document.getElementsByTagName("form")[0].appendChild(document.getElementsByClassName("dz-hidden-input")[0]);
    Execute Javascript					document.getElementsByClassName("dz-hidden-input")[0].removeAttribute("style");

    Choose File     xpath=//input[contains(@type, 'file')]   ${ARGUMENTS[1]}
    sleep   2
    click element   xpath=//div[contains(@class, 'modal-body')]/div[3]/div/input
    sleep   2
    Click Element       xpath=(//input[contains(@class, 'submit')])[1]
    wait until page contains element  xpath=//div[contains(@class, 'alert alert-success')]
    sleep   40
    reload page
    wait until page contains element  xpath=//div[contains(@class, 'bid-details')]/div[contains(@class,'alert alert-success')]


Отримати посилання на аукціон для учасника
    [Arguments]  @{ARGUMENTS}
    Selenium2Library.Switch Browser       ${ARGUMENTS[0]}
    Selenium2Library.Switch Browser     ${ARGUMENTS[0]}
    Go to   ${USERS.users['${ARGUMENTS[0]}'].default_page}
    Sleep   2
    click element   xpath=//a[contains(@href,'/Bid/Details')]
    sleep   2
    ${result}=       get element attribute     xpath=//a[contains(@href,'auction')]@href
    [Return]   ${result}