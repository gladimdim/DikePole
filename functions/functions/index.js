const functions = require('firebase-functions');

const admin = require('firebase-admin');

admin.initializeApp();
const auth = admin.auth();

exports.hasPlayed = functions.https.onRequest(async (req, res) => {
    const id = req.query.id;
    const snapshot = await admin.firestore().collection(`/user_states/${id}/states`).get();

    const result = snapshot.docs.map(element => element.data().catalogidreference);
    console.log(`processed id: ${id}`);
    res.json(result);
});

async function asyncForEach(array, callback) {
    for (let i = 0; i < array.length; i++) {
        return callback(array[i], i, array);
    }
    return 0;
}

exports.playStatistics = functions.https.onRequest(async (req, res) => {
    const userRecords = await auth.listUsers();
    const userIds = userRecords.users.map((user) => user.uid);

    const start = async () => {
        let storyStats = {};
        const promises = userIds.map(userId => admin.firestore().collection(`/user_states/${userId}/states`).get());

        return Promise.all(promises).then(snapshots => {
            snapshots.map(snapshot => {
                const result = snapshot.docs.map(element => element.data().catalogidreference);
                result.forEach(key => {
                    if (storyStats[key] !== undefined) {
                        storyStats[key] = storyStats[key] + 1;
                    } else {
                        storyStats[key] = 1;
                    }
                });
            });
            return storyStats;
        });

    }

    const storyStats = await start();
    res.set('Access-Control-Allow-Origin', '*');
    res.json({
        storyStats: storyStats,
        users: userIds.length
    });
});