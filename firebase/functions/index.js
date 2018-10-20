const functions = require('firebase-functions');
const request_lib = require('request');
const admin = require('firebase-admin');
const parse = require('csv-parse/lib/sync');

admin.initializeApp(functions.config().firebase);
var db = admin.firestore();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

const viirs_24h = 'https://firms.modaps.eosdis.nasa.gov/data/active_fire/viirs/csv/VNP14IMGTDL_NRT_Global_24h.csv';
const viirs_48h = 'https://firms.modaps.eosdis.nasa.gov/data/active_fire/viirs/csv/VNP14IMGTDL_NRT_Global_48h.csv';
const viirs_7d = 'https://firms.modaps.eosdis.nasa.gov/data/active_fire/viirs/csv/VNP14IMGTDL_NRT_Global_7d.csv';

exports.VIIRS24 = functions.https.onRequest((request, response) => {
    request_lib(viirs_24h, { json: true }, (err, res, body) => {
        if (err) { return console.log(err); }
        console.log(body.url);

        const records = parse(body, {
            columns: true,
            skip_empty_lines: true
        });

        // for (let row_index in records) {
        //     const row = records[row_index];
        //     if (row.frp > 0) {

        for (row_index in records) {
            const row = records[row_index];

            if (row.frp > 0) {
                // Add a new satellite reading if a fire is detected
                var addDoc = db.collection('VIIRS').add({
                    location: {
                        Latitude: row.latitude,
                        Longitude: row.longitude
                    },
                    fire_power: row.frp,
                    width: row.scan,
                    height: row.track,
                    confidence: 'high',
                    acq_date: '2018-10-19',
                    acq_time: '0112'
                });

                addDoc.then(function () {
                });
            }
        }

        return response.send('woot 3.0!!');

    });
});
