import * as functions from 'firebase-functions';
import { FieldValue } from '@google-cloud/firestore';
//import * as util from 'util';

//const functions = require("firebase-functions");

const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const db = admin.firestore();

// admin.initializeApp();


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

export const deleteBooking = functions.firestore.document('/booking/{bookingId}').onDelete( (doc,ctx) => {
    const booking = doc.data();
    const id = doc.id;
    const teeTime = booking && booking.teeTimeRef || null;

    console.log(`context is ${ctx.params.bookingId} doc = ${booking} teeTimeRef=${teeTime}`);

    // delete any references to this booking.
    const teeRef = db.collection("teeTimes").doc(teeTime);


    console.log(booking);
    const p = booking && booking.players || null;

    console.log(`Updating teeTime - removing ${p}`);
    console.log(p);
    const players = Object.values(p);
    console.log(Object.values(p));

    const r = teeRef.update({
        bookingRefs: FieldValue.arrayRemove(id),
        playerNames: FieldValue.arrayRemove(...players),
        availableSpots: FieldValue.increment(players.length)
    });

    return r;


});