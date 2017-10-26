const path = require('path');

const { spawn } = require('./utils');

const args = [
  '-force-copy',
  '-backend-config',
  `credentials=${path.join(__dirname, '..', 'keyfile.json')}`,
  '-backend-config',
  `project=${process.env.TF_VAR_project}`,
  '-backend-config',
  `bucket=${process.env.TF_VAR_tfstate_bucket}`
];

spawn('terraform', 'init', args);
