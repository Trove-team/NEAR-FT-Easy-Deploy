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

echo Building the contract, this will take a few minutes (depending on your computer speed)
docker build -t near-contract-build .
docker create --name temp-container near-contract-build
docker cp temp-container:/main.wasm .\out\main.wasm
docker rm temp-container

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
npm install -g near-cli
:: Login with your master account, e.g., jumpfinance.near
near login

:: Create the contract account then send 20N for deployment
near create-account %TOKEN_ADDRESS_PREFIX%.%MASTER_ACCOUNT% --masterAccount %MASTER_ACCOUNT% --initialBalance 25

:: Deploy the contract
near deploy %TOKEN_ADDRESS_PREFIX%.%MASTER_ACCOUNT%

echo Contract deployed at %TOKEN_ADDRESS_PREFIX%.%MASTER_ACCOUNT%

echo Initializing the contract

:: Call the init function new(owner_id: AccountId, total_supply: U128, metadata: FungibleTokenMetadata)
near call %TOKEN_ADDRESS_PREFIX%.%MASTER_ACCOUNT% new "{\"owner_id\": \"%MASTER_ACCOUNT%\", \"total_supply\": \"1000000000000000000000000000000\", \"metadata\": {\"spec\": \"ft-1.0.0\", \"name\": \"%TOKEN_NAME%\", \"symbol\": \"%TOKEN_SYMBOL%\", \"icon\": \"%ICON%\", \"decimals\": %TOKEN_DECIMALS%}}" --accountId %MASTER_ACCOUNT%
