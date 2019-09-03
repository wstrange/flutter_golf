#!/usr/bin/env bash
pub run build_runner build --output=build

firebase deploy --only functions