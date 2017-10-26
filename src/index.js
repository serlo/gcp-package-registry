require('dotenv').config();
const datastore = require('@google-cloud/datastore')();
const storage = require('@google-cloud/storage')();
const { RequestResolver } = require('@splish-me/serverless-package-registry');

const getVersions = packageName => {
  console.log('Looking up', packageName);
  const key = datastore.key(['Package', packageName]);

  return datastore.get(key).then(([pkg]) => pkg.versions);
};

const resolver = new RequestResolver({ getVersions });

const bucket = storage.bucket(process.env.TF_VAR_bucket);

exports.resolve = (req, res) => {
  const { path } = req;

  if (!path) {
    console.log('exiting');
    return res.sendStatus(500);
  }

  const reqString = path.substr(1);

  console.log('Resolving', reqString);

  resolver
    .resolve(reqString)
    .then(fileName => {
      console.log('Resolved to', fileName);

      if (!fileName) {
        return res.sendStatus(404);
      }

      const file = bucket.file(fileName);

      return file.get();
    })
    .then(([file]) => {
      const readStream = file.createReadStream();

      return file.getMetadata().then(([metadata]) => {
        res.setHeader('content-type', metadata.contentType);
        readStream.pipe(res);
      });
    })
    .catch(() => {
      res.sendStatus(404);
    });
};
