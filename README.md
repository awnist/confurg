## What's "confurg"?

confurg is a node.js configuration loader: supports chaining, command line options, ENV variables, and more.

confurg is opinionated and has a clear order of precedence.

The config file formats can be either [CSON](https://github.com/bevry/cson) or JSON.

## Overview

Just require and tell confurg what your project is called:

    config = require("confurg").init "myproject"

In this example, confurg will check the following locations in decreasing order of value:

    1. Command line options such as --bar=baz
    2. ENV variables prefaced with myproject_ 
    3. /home/{user}/.myproject.cson
    4. ./config.cson, based on the location of the script that required confurg
    5. Defaults passed into initialization: require("confurg")({ ... },{ defaults: "go here" })

confurg will return an object containing the merged results of all 5 locations.

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

## Regarding environment variables

Most shells are very strict with variable names. [Bash only allows alphanumerics and underscores](http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap08.html). Your project should be named appropriately (my_project instead of my-project) if this is an important factor.

Additionally, to overwrite deeply nested config values, simply replace dots with a double underscore:

```
    $ export myproject_foo__bar__baz="value"
```

the above would overwrite the following:

```
    foo.bar.baz
```

in your config.


## Installation

The recommended way is through [npm](http://www.npmjs.org/):

    $ npm install confurg

Otherwise, you can check confurg into your repository and expose it:

    $ git clone git://github.com/awnist/confurg.git node_modules/confurg/

confurg is [UNLICENSED](http://unlicense.org/).
