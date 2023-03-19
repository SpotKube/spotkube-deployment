const AWS = require('aws-sdk');
const ec2 = new AWS.EC2({ region: 'us-east-1' });

exports.handler = async (event, context) => {
  try {
    const instances = await ec2.describeInstances({ Filters: [{ Values: ['running'] }] }).promise();
    const instanceIds = instances.Reservations.reduce((acc, reservation) => acc.concat(reservation.Instances.map(instance => instance.InstanceId)), []);
    if (instanceIds.length) {
      await ec2.stopInstances({ InstanceIds: instanceIds }).promise();
      console.log(`Stopped instances: ${instanceIds}`);
    } else {
      console.log('No instances to stop.');
    }
  } catch (err) {
    console.log(err);
    throw err;
  }
};
