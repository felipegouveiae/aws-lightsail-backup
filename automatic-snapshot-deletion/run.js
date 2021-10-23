var AWS = require("aws-sdk");

AWS.config.getCredentials(function (err) {
    if (err) console.log(err.stack);
    else {
        console.log("Access key:", AWS.config.credentials.accessKeyId);
    }
});

AWS.config.update({region: 'us-east-1'});

const backup = async () => {

    const lightsailClient = new AWS.Lightsail({});

    lightsailClient.getInstanceSnapshots({pageToken: ""}, (error, data) => {

        if (error) {
            console.error(error);
            return;
        }

        console.log(data);

    });


};

backup()
    .then(() => console.log("finished!"))
    .catch(e => console.error(e));

