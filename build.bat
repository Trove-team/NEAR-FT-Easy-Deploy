@echo off
echo Building the contract, this will take a few minutes (depending on your computer speed)
mkdir out 2>nul
del /Q out\*.*

docker build -t near-contract-build .
docker create --name temp-container near-contract-build

docker cp temp-container:/main.wasm .\out\main.wasm
docker rm temp-container
