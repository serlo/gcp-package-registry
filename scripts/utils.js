require('dotenv').config();
const spawn = require('cross-spawn');

module.exports.spawn = (command, subcommand, args=[]) => {
  spawn.sync(command, [subcommand, ...args], { stdio: 'inherit' });
}
