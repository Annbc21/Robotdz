*** Settings ***
Documentation    Suite description
Library     Collections

*** Variables ***
@{list}     1     2     3      5     1    0    -1     10
@{tempCel}     0     350      -32     100
@{tempFar}     32     662     -25.6     212

*** Test Cases ***
Min and max
    @{trgList}=     Convert to int      ${list}
    ${max}=     Evaluate     max($trgList)
    ${min}=     Evaluate     min($trgList)
    log      ${max}
    log      ${min}

Unique variables
     @{trgList}=     Convert to int      ${list}
     ${withoutDubl}=     Remove Duplicates      ${trgList}
     log      ${withoutDubl}

Sum of all
    @{trgList}=     Convert to int      ${list}
    ${sum}     Set Variable     0
    FOR      ${count}     IN      @{trgList}
          ${sum}=     Evaluate      ${sum}+${count}
    END
    log     ${sum}

Cel to far
    @{trgTempCel}=      Convert to int     ${tempCel}
    @{trgTempFar}=      Convert to int      ${tempFar}
    @{trgTemp}=     Create list     ${trgTempCel}      ${trgTempFar}
    ${length}=     Get Length     ${trgTemp[0]}
    FOR     ${i}     IN RANGE      ${length}
        Convert temp    ${trgTemp[0][${i}]}     ${trgTemp[1][${i}]}
    END
*** Keywords ***
Convert to int
    [Arguments]      ${list1}
    @{list2}=      Create list
    ${lngth}=     Get Length     ${list1}
    FOR     ${i}      IN RANGE      ${lngth}
         ${z}=      Convert to number      ${list1[${i}]}
         Append to list      ${list2}        ${z}
    END
    [return]      ${list2}
Convert temp
    [Arguments]      ${c}     ${f}
    ${x}     Evaluate       9/5*${c}+32
    Should Be Equal As Numbers     ${f}      ${x}
