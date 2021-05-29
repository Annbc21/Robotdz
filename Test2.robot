*** Settings ***
Documentation    Suite description
Library         RequestsLibrary     WITH NAME   Req
Library         PostgreSQLDB        WITH NAME   DB
Library         Collections
Test Setup      Test Setup
Test Teardown   Test Teardown
*** Test Cases ***
From two tables

    ${resp}=      Req.GET On Session     alias     /products?      params=select=title,actor,categories(categoryname)&title=like.ACADEMY_I*
    Log          ${resp.json()}

Create and check
    &{data}=    Create dictionary    category=99     categoryname=test
    ${req}=      Req.POST On Session     alias     /categories?     ${data}

    ${resp}=      Req.GET On Session     alias     /categories?      params=select=category,categoryname&category=eq.99
    Log          ${resp.json()}

    ${SQL}          set variable         select * from bootcamp.categories where category = %(category)s
    @{result}    DB.Execute Sql String Mapped     ${SQL}      &{data}
    Log      ${result}

    ${req}=      Req.Delete On Session     alias     /categories?      params=select=category,categoryname&category=eq.99

Create and check from bd
    ${params}    create dictionary     category=99     categoryname=test
    ${SQL}          set variable         INSERT into bootcamp.categories (category, categoryname) VALUES (%(category)s ,%(categoryname)s)
    @{result}    DB.Execute_plpgsql_block    ${SQL}      &{params}

    ${resp}=      Req.GET On Session     alias     /categories?      params=select=category,categoryname&category=eq.99
    Log          ${resp.json()}

    ${SQL}          set variable         select * from bootcamp.categories where category = %(category)s
    @{result}    DB.Execute Sql String Mapped     ${SQL}      &{params}
    Log      ${result}

    ${SQL}          set variable         delete from bootcamp.categories where category = %(category)s
    @{result}    DB.Execute_plpgsql_block    ${SQL}      &{params}
*** Keywords ***
Test Setup
    Req.Create session       alias       http://localhost:3000
    DB.Connect To Postgresql      hadb    ha    password2021dljfklkla1!kljf;    localhost  8432
Test Teardown
    Req.Delete All Sessions
    DB.Disconnect From Postgresql
