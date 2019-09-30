


# Run test: (no worky)
pub run build_runner test --output=build/


# Run:

export FIRESTORE_EMULATOR_HOST=localhost:8080

pub run build_runner test --output=build/
node build/node/dart_admin.dart.js
 
 

# pub run test??



pub run build_runner build \
  --define="build_node_compilers|entrypoint=compiler=dart2js" \
  --output=build/
  