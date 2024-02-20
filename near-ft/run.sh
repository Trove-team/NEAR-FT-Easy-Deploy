export NEAR_ENV=mainnet
export TOKEN_NAME="token"
export TOKEN_SYMBOL="TKN"
export TOKEN_DECIMALS=24
export INITIAL_SUPPLY=1000000000000000000000000000000 #1mil tokens with 24 decimals
export ICON="" #base64 encoded icon https://base64.guru/converter/encode/image/png
export TOKEN_ADDRESS_PREFIX="token" #this will be the prefix, eg token.jumpfinance.near
export MASTER_ACCOUNT="myaccount.near" #this is the master account you will be login with


# This script is used to build the contract and copy the main.wasm file to the host machine.
echo "Building the contract, this will take a few minutes (depending on your computer speed)"
docker build -t near-contract-build .
docker create --name temp-container near-contract-build
docker cp temp-container:/main.wasm ./out/main.wasm
docker rm temp-container
# After the build, the main.wasm file is copied from the Docker container to the host machine.

#check the ./out/main.wasm file is exist
if [ -f ./out/main.wasm ]; then
  echo "main.wasm file exists"
else
  echo "main.wasm file does not exist"
  exit 1
fi

#Ask the user if he agree to deploy the contract, which need 20N for deployment
echo "Do you want to deploy the contract? (y/n), you need 26 NEAR in your master account."
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "Yes"
else
    echo "No"
    exit 1
fi

#Now we call the deploy script
sudo npm install -g near-cli
 #login with your master account eg. jumpfinance.near
near login


echo "Creating the contract account and deploying the contract"
#Create the contract account then send 20N for deployment
near create-account $TOKEN_ADDRESS_PREFIX.$MASTER_ACCOUNT --masterAccount $MASTER_ACCOUNT --initialBalance 25

#Deploy the contract
near deploy $TOKEN_ADDRESS_PREFIX.$MASTER_ACCOUNT


echo "Contract deployed at $TOKEN_ADDRESS_PREFIX.$MASTER_ACCOUNT"

echo "Initializing the contract"

#Call the init function new(owner_id: AccountId, total_supply: U128, metadata: FungibleTokenMetadata)
near call $TOKEN_ADDRESS_PREFIX.$MASTER_ACCOUNT new '{"owner_id": "'$MASTER_ACCOUNT'", "total_supply": "1000000000000000000000000000000", "metadata": {"spec": "ft-1.0.0", "name": "'$TOKEN_NAME'", "symbol": "'$TOKEN_SYMBOL'", "icon": "'$ICON'", "decimals": '$TOKEN_DECIMALS'}}' --accountId $MASTER_ACCOUNT 


