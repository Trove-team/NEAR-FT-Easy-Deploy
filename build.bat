@echo off
setlocal enabledelayedexpansion

:: Build the project
cargo build --all --target wasm32-unknown-unknown --release

:: Check if the out directory exists, if not, create it
if not exist out mkdir out

:: Copy the generated wasm files to the out directory
for %%i in (./target/wasm32-unknown-unknown/release/*.wasm) do (
    copy "%%i" ".\out\"
)

echo Done.