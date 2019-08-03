import * as functions from 'firebase-functions';
import { FieldValue } from '@google-cloud/firestore';
//import * as util from 'util';

//const functions = require("firebase-functions");

const admin = require('firebase-admin');

//import admin = require('firebase-admin');


admin.initializeApp(functions.config().firebase);

const db = admin.firestore();

// admin.initializeApp();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

// Triggered when a booking is deleted. Cleans up the associated references in the teeTime
export const deleteBooking = functions.firestore.document('/booking/{bookingId}').onDelete( (doc,ctx) => {
    const booking = doc.data();
    const id = doc.id;
    const teeTime = booking && booking.teeTimeRef || null;

    console.log(`context is ${ctx.params.bookingId} doc = ${booking} teeTimeRef=${teeTime}`);

    // delete any references to this booking.

    // get a reference to the teeTime
    const teeRef = db.collection("teeTimes").doc(teeTime);

    // read the players array
    const p = booking && booking.players || null;

    console.log(`Updating teeTime - removing ${p}`);

    // javascript objects are not the same as values.
    const players = Object.values(p);


    // Update the tee time - removin
    const r = teeRef.update({
        bookingRefs: FieldValue.arrayRemove(id),
        playerNames: FieldValue.arrayRemove(...players),
        availableSpots: FieldValue.increment(players.length)
    });

    return r;
});

export const bookingWriteTrigger = functions.firestore.document('/booking/{bookingId}').onWrite( (change,context) => {
    // context.params.bookingId
    console.log(context)

    const booking = change.after.data();
    const bookingId = context.params.bookingId;

    if (! booking)
        return false;

    console.log(change.before.data());
    console.log(booking);
    const teeTimeRef = booking.teeTimeRef;

    if( ! teeTimeRef )
    return false;



    const teeTime = db.collection("teeTimes").doc(teeTimeRef);

    teeTime.update({
        bookingRefs: FieldValue.arrayUnion(bookingId),
        playerNames: FieldValue.arrayRemove(...players),
        availableSpots: FieldValue.increment(players.length)
    });


    return true
});



// setTimeout(async function() {
//     try {


//     }
//     catch( error ) {
//         console.error(error);
//     }
// });