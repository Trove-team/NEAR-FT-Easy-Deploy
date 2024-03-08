# NEAR-FT-Easy-Deploy

This is a docker file setup for deploying a basic NEP-141 token with token metadata (Token Icon, Decimals, etc.)

**Requirements:**

Visual Studio (optional)

Docker

Node.js

NEAR CLI (3.5.0)

Windows: Virtualization may need to be enabled 

(https://support.microsoft.com/en-us/windows/enable-virtualization-on-windows-11-pcs-c5578302-6e43-4b4b-a449-8ced115f58e1)

**NOTE:**

We have discovered a potential issue with the current Near cli version which prevents users from creating Near accounts

(https://github.com/near/near-cli/issues/1106) 

To bypass this issue, rollback the near cli to v3.5.0

Run the following command

**npm install -g near-cli@3.5.0**

or

**sudo npm install -g near-cli@3.5.0**

Nep 141 deployer Tutorial


1. Install Visual studio

https://code.visualstudio.com/ 

2. Install node.js
https://nodejs.org/en/download  

3. After installing run **npm -v** (this will confirm the node.js installation version)

4. Install Docker (this will allow you to build the contract without having all of the prerequisites on your machine)

https://www.docker.com/

**MAKE SURE DOCKER IS RUNNING DURING ENTIRE PROCESS**

5. Install Near CLI
Run **npm install -g near-cli**

6. Create a NEAR account to act as the fungible token owner

Make sure you have >26 NEAR in desired account. 25 NEAR is required for FT contract storage.

Open terminal to make sure you are running commands on mainnet, as the default is testnet

7. Run the Export to mainnet command

**Windows:** Run **set NEAR_NETWORK=mainnet**

3.5.0 Run **set NEAR_ENV=mainnet** 

Mac: Run **export NEAR_ENV=mainnet**

8. Login to desired fungible token contract address

Run **near login** 

- Or **near login --walletUrl https://app.mynearwallet.com/**

- Can login with meteor wallet if you prefer

- **near login --walletUrl https://wallet.meteorwallet.app/**

9. Download the zip file from this repository

- **https://github.com/Trove-team/near-ft**

10. Extract folder and move to accessible location

11. Edit your token meta data before building the contract

12. Use a 32x32 bit png or svg file and convert to a base 64 plain text data url. Make sure the url is not too long.

- Data url generator: https://base64.guru/converter/encode/image/png 

13. Navigate into the near-ft-main folder and find run.sh or run.bat for windows and open it up with notepad or vscode

Edit lines 2–8 with the appropriate information for your token

- Ensure you are using the correct amount of decimals when inputting token supply on line 5 

 **(Example: to input a total supply of 10 for a token with 24 decimals would be 10000000000000000000000000)**

14. Using your terminal, navigate into the folder directory
- **MAC:** 

Navigate to near-ft in terminal

- **cd near-ft**

15. Run the following calls:

- **chmod 777 ./run.sh**

**./run.sh**

**Windows:**

Open near-ft-main folder via file explorer

Click on **run.bat**

Or run

**run run.bat**

Docker file will build the correct .WASM and place it into the ./out folder.

It will then run through deploying the contract, creating a sub account, and initializing the contract.

16. To recover most of the near for the practice token run the following:

**near delete <deployed_account> <beneficiary account>**

near delete fungibletoken.testaccount.near testaccount.near

- **Warning: This will delete account and all fungible tokens/NFTs will be inaccesible.**

17. Token should be deployed and sent to main account!
