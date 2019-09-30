#!/usr/bin/env bash

# pub global activate protoc_plugin

PROTO_DIR=/usr/local/opt/protobuf/include

rm -fr lib/protos
mkdir -p lib/protos
#protoc -I$(PROTO_DIR) --dart_out=lib/client $(PROTO_DIR)/google/protobuf/timestamp.proto

protoc -I$PROTO_DIR -I./protos --dart_out=lib/protos  $PROTO_DIR/google/protobuf/timestamp.proto protos/*.proto
