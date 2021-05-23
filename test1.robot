*** Settings ***
Documentation    Suite description
Library     Collections

*** Variables ***
@{list}     ${1}     ${2}     ${3}      ${5}     ${1}    ${0}    ${-1}     ${10}
@{tempCel}     ${0}     ${350}      ${-32}     ${100}
@{tempFar}     ${32}     ${662}     ${-25.6}     ${212}
@{temp}     ${tempCel}      ${tempFar}

*** Test Cases ***
Min and max
    ${max}=     Evaluate     max($list)
    ${min}=     Evaluate     min($list)
    log      ${max}
    log      ${min}

Unique variables
     ${withoutDubl}=     Remove Duplicates      ${list}
     log      ${withoutDubl}

Sum of all
    ${sum}     Set Variable     0
    FOR      ${count}     IN      @{list}
          ${sum}=     Evaluate      ${sum}+${count}
    END
    log     ${sum}

Cel to far
    ${length}=     Get Length     ${temp[0]}
    FOR     ${i}     IN RANGE      ${length}
        Convert temp    ${temp[0][${i}]}     ${temp[1][${i}]}
    END
*** Keywords ***
Convert temp
    [Arguments]      ${c}     ${f}
    ${x}     Evaluate       9/5*${c}+32
    Should Be Equal As Numbers     ${f}      ${x}
