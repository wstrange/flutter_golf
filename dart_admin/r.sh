#!/usr/bin/env bash

# To run against the emulator (make sur it is running)
#export FIRESTORE_EMULATOR_HOST=localhost:8080
#unset  GOOGLE_APPLICATION_CREDENTIALS

# To run against the real firestore:
export  GOOGLE_APPLICATION_CREDENTIALS=/Users/warren.strange/src/flutter_golf/dart_admin/service-accounts/service-account.json
unset FIRESTORE_EMULATOR_HOST

pub run build_runner build --output=build/
node build/node/dart_admin.dart.js
