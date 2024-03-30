@echo off
setlocal enabledelayedexpansion

:: Set environment variables
set NEAR_ENV=mainnet
set TOKEN_NAME=token
set TOKEN_SYMBOL=TKN
set TOKEN_DECIMALS=24
set INITIAL_SUPPLY=1000000000000000000000000000000
set ICON=  REM Add base64 encoded icon here
set TOKEN_ADDRESS_PREFIX=token
set MASTER_ACCOUNT=myaccount.near


echo Do you logged in with near login with your master account: %MASTER_ACCOUNT%? (y/n), you need to have 26 NEAR in your master account.
set /p answer=
if /i "%answer%"=="y" (
    echo Yes
) else (
    echo No
    call  near login
)

echo Building the contract, this will take a few minutes (depending on your computer speed)
call  docker build -t near-contract-build . || (
    echo Docker build failed, is Docker running?
    pause
    exit /b 1
)
call  docker create --name temp-container near-contract-build || (
    echo Docker create failed, is Docker running?
    pause
    exit /b 1
)
call  docker cp temp-container:/main.wasm .\out\main.wasm || (
    echo Docker cp failed, is Docker running?
    pause
    exit /b 1
)
call  docker rm temp-container || (
    echo Docker rm failed, is Docker running?
    pause
    exit /b 1
)

:: Check if the main.wasm file exists
if not exist .\out\main.wasm (
    echo main.wasm file does not exist
    exit /b 1
) else (
    echo main.wasm file exists
)

echo Do you want to deploy the contract? (y/n), you need 26 NEAR in your master account.
set /p answer=
if /i "%answer%"=="y" (
    echo Yes
) else (
    echo No
    exit /b 1
)

echo Creating the contract account and deploying the contract

:: Create the contract account then send 20N for deployment
call  near create-account %TOKEN_ADDRESS_PREFIX%.%MASTER_ACCOUNT% --masterAccount %MASTER_ACCOUNT% --initialBalance 25 || (
    echo Account creation failed
    pause
    exit /b 1
)
:: Deploy the contract
call  near deploy %TOKEN_ADDRESS_PREFIX%.%MASTER_ACCOUNT%  ./out/main.wasm || (
    echo Contract deployment failed
    pause
    exit /b 1
)

echo Contract deployed at %TOKEN_ADDRESS_PREFIX%.%MASTER_ACCOUNT% 

echo Initializing the contract

:: Call the init function new(owner_id: AccountId, total_supply: U128, metadata: FungibleTokenMetadata)
call  near call %TOKEN_ADDRESS_PREFIX%.%MASTER_ACCOUNT% new "{\"owner_id\": \"%MASTER_ACCOUNT%\", \"total_supply\": \"1000000000000000000000000000000\", \"metadata\": {\"spec\": \"ft-1.0.0\", \"name\": \"%TOKEN_NAME%\", \"symbol\": \"%TOKEN_SYMBOL%\", \"icon\": \"%ICON%\", \"decimals\": %TOKEN_DECIMALS%}}" --accountId %MASTER_ACCOUNT% || (
    echo Contract initialization failed, please run "new" manually
    pause
    exit /b 1
)
:: Storage deposit
call  near call %TOKEN_ADDRESS_PREFIX%.%MASTER_ACCOUNT% storage_deposit "{\"account_id\": \"%MASTER_ACCOUNT%\", \"registration_only\": false}" --accountId %MASTER_ACCOUNT% --amount 0.01 || (
    echo Storage deposit failed, please run the storage_depoist manually
    pause
    exit /b 1
)

pause
