Stuff I learned


todo: A better firestore / dart serialization lib would help



Keys= 

global key - example - show same widget in many places, with the same state. 

use keys to preserve state across 

Provider.of - subscribes teh calling widget to updates
You cant call this from initState: initState is a one time setup - and 
using Provider.of implies the value can change - so it is a bug to 
get a value from the provider only once. 

You can pass:

Provider.of<MyService>(context, listen: false)

This works in in initState()!

Tee Time reservations:

- If you made the reservation, you can edit/cancel the tee time
- If you are on the reservation (but didnt make it) you can cancel just yourself
- Need the concept of a tee time group, or a reservation
- A single tee time can have up to 4 reservations

A reservation is:
- owned by a creator (might not be the player)
- has a number of players (which might be guests)

Private courses - you should have a view into all reservations.
public - you can't see all reservations - just the blocked time...

To make a reservation:
- View available tee times
- request N spots (could be guests or other users)
- update Tx:
  - creates bookings object
  - reduces the number of open spots on the tee time
  
  
Teetime map of reservations
key - userId who made reservation??
wilma made the resveration - for fred and two guests
wilma { name: "Wilma " }
fflinstone { bookedBy: wilma  name: "Fred"}
guest1 { bookedBy: wilma name: "Guest of Wilma"}
guest2 { bookedBy:  wilma name: "Betty Rubble" }



dart to firestore cloud functions

Problem: Cloud Firestore has a unique datatype (TimeStamp). This library
is not compatible between flutter and the javascript/nodejs library. 
Can't deserialize...


Protobuf3 - json serialization is almost here:
https://github.com/dart-lang/protobuf/issues/220
https://github.com/dart-lang/protobuf/pull/274

Using proto3 + json - should be able to serialize for firestore api.
https://github.com/googleapis/nodejs-firestore/blob/master/dev/src/convert.ts

cloud run - does not support grpc /websocket




When we create a tee time we should add the course name to the record
OR - cache the course name lookup.


Libs
----
https://github.com/kdy1/typed_firestore - adds type to Built value
https://pub.dev/packages/firedart - native gRPC firestore api



# State Management

State mananegement 

BloC
pros - good support. Clean one way flow. Testable. Record event stream (for time travel, etc.)
cons - a lot of boilerplate. awkward to make everything an event stream??
firestore support?
very active development 


MobX - 
Create backing store / form. Create actions / re-actions
Probably should not use mobx store as the domain model - so some code duplication
active community


Hooks -
good for local state of ui - hook is close to where it is used 
complex lifecycle if you dont follow the rules.. 



Todo:
- booking does not allow choice / cancel
- user store is sometimes not set - need to force user to log in when app starts.
- tee sheet does not refresh on back navigation
