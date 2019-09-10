# iris :eyes:
Keep an eye on the logs for specific instances

``` bash
iris [tail <instance> <logfile>]
     [logfiles <instance>]
     [instances]
     [ls]
```

> Dont forget that you can use a [TAB] character to trigger auto completing instances/logfiles

## Installation
Just source the file with `source iris.sh`. Add it to your .bashrc.

## Usage
### `iris tail <instance> <logfile>`
Tails logs woo. Also has red colour highlighting for keywords
  
### `iris logfiles <instance>`
Print out the log files available for a specific instance

### `iris instances`
Get a list of instances

### `iris ls`
Get a list of all instances and their corresponding logfiles
