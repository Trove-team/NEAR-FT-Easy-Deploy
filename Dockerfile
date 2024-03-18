FROM rust:1.69 as builder

RUN rustup target add wasm32-unknown-unknown

WORKDIR /usr/src/myapp

COPY . .

RUN set -e
#RUN cargo build --all --target wasm32-unknown-unknown --release
#install nodejs
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs
#install near-cargo
RUN npm i -g near-cli-rs cargo-near
RUN cargo near build

FROM scratch
COPY --from=builder /usr/src/myapp/target/near/main.wasm .

CMD ["echo", "Deploy the wasm file from /usr/src/myapp/target/near/main.wasm"]