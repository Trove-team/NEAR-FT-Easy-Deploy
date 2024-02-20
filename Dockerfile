FROM rust:1.69 as builder

RUN rustup target add wasm32-unknown-unknown

WORKDIR /usr/src/myapp

COPY . .

RUN set -e
RUN cargo build --all --target wasm32-unknown-unknown --release

FROM scratch
COPY --from=builder /usr/src/myapp/target/wasm32-unknown-unknown/release/main.wasm .

CMD ["echo", "Deploy the wasm file from /usr/src/myapp/target/wasm32-unknown-unknown/release/"]