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




When we create a tee time we should add the course name to the record
OR - cache the course name lookup.
