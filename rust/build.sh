#!/usr/bin/env bash
cargo build --target wasm32-unknown-unknown
wasm-bindgen target/wasm32-unknown-unknown/debug/dikepole.wasm --no-modules --out-dir ./pkg