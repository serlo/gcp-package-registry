'use strict';

exports.resolve = (request, response) => {
  response.status(200).send('Hello World!');
};
