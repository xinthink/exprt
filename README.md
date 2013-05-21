# exprt

Express routes generator

## Getting Started
Install the module with: `npm install exprt`

```javascript
var express = require('express')
  , exprt   = require('exprt')
  , path    = require('path');

var app = express();

// scan and register express routes
exprt(app, {
  path: path.join(__dirname, 'routes')
});
```

## Documentation
_(Coming soon)_

## Examples
_(Coming soon)_

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_

## License
Copyright (c) 2013 xinthink
Licensed under the MIT license.
