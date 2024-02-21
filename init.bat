@echo off
REM Run near login to login with your master account
set NEAR_ENV=mainnet
set TOKEN_CONTRACT=ftv2.nekotoken.near
set OWNER_ACCOUNT=vesting-test.near
set VESTING_CONTRACT=trovevestingtestnear.near

near call %VESTING_CONTRACT% new "{\"owner\": \"%OWNER_ACCOUNT%\", \"token_contract\": \"%TOKEN_CONTRACT%\"}" --accountId %OWNER_ACCOUNT%