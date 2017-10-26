const path = require('path');

const { spawn } = require('./utils');

const serverlessPath = require.resolve('serverless/package.json');
const serverlessDir = path.dirname(serverlessPath);

spawn(path.join(serverlessDir, require(serverlessPath).bin.serverless), 'deploy');
