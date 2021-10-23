const moment = require('moment');
const AWS = require("aws-sdk");

const {AWS_KEY, AWS_SECRET, AWS_REGION} = process.env;

if (!AWS_KEY)
    throw "AWS_KEY cannot be null";

if (!AWS_SECRET)
    throw "AWS_SECRET cannot be null";

if (!AWS_REGION)
    throw "AWS_REGION cannot be null";

AWS.config.update({
    accessKeyId: AWS_KEY,
    secretAccessKey: AWS_SECRET,
    region: AWS_REGION
});

const maxDate = moment()
    .add(-90, 'days')
    .toDate();

const lightsailClient = new AWS.Lightsail({});

let pageToken = "";

const deleteInstanceSnapshot = async (name) => {
    return new Promise((resolve, reject) => {
        lightsailClient.deleteInstanceSnapshot({instanceSnapshotName: name}, (error, data) => {

            if (error) {
                console.error(error)
                reject(error);
                return;
            }

            resolve(data);
        })

    })
}

const deleteOldSnapshots = async () => {

    lightsailClient.getInstanceSnapshots({pageToken}, async (error, snapshotsResult) => {

        if (error) {
            console.error(error);
            return;
        }

        pageToken = snapshotsResult.nextPageToken;

        for (let snapshot of snapshotsResult.instanceSnapshots) {
            if (snapshot.createdAt > maxDate) {
                console.debug(`Skipping ${snapshot.name} from ${snapshot.createdAt}`);
                continue;
            }

            console.debug(`deleting ${snapshot.name} from ${snapshot.createdAt}...`);

            await deleteInstanceSnapshot(snapshot.name);
        }

        // if (pageToken) {
        //     await deleteOldSnapshots();
        // }

    });
};

(async () => {
    try {
        await deleteOldSnapshots();
    } catch (e) {
        console.error(e);
    }
})();
