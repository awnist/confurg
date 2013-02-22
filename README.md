## What's "confurg"?

confurg is an Coffeescript and Javascript module to load configuration files.

confurg is opinionated and has a clear order of precedence.

The config file formats can be either [CSON](https://github.com/bevry/cson) or JSON.

## Overview

Just require and tell confurg what your project is called:

    config = require("confurg")({ namespace: "myproject" })

In this example, confurg will check the follow locations in decreasing order of value:

    1. Command line options such as --bar=baz
    2. /home/{user}/.myproject.cson
    3. ENV variables prefaced with myproject_ 
    4. ./myproject.cson, based on the location of the script that required confurg
    5. Defaults passed into initialization: require("confurg")({ ... }{ defaults: "go here" })

and will return an object containing the merged results of all 5 locations.

confurg performs a deep merge, which means:

if /home/you/.myproject.cson contains
```
    {
        foo:
            bar: "one"
    }
```

and ./config.cson contains
```
    {
        foo:
            baz: "two"
    }
```

the result will be
```
    {
        foo:
            bar: "one"
            baz: "two"
    }
```

## Installation

The recommended way is through the excellent [npm](http://www.npmjs.org/):

    $ npm install confurg

Otherwise, you can check it in your repository and then expose it:

    $ git clone git://github.com/awnist/confurg.git node_modules/confurg/

confurg is [UNLICENSED](http://unlicense.org/).
