# HTTPing.rb

HTTPing.rb is a utility to measure web service response time. This is a Ruby port of HTTPing (http://www.vanheusden.com/httping/).

## Bugs, Features, Feedback

Tickets can be submitted by via GitHub issues.

## Example Usage

jpignata@populuxe:~$ httping --count 10 --user-agent "HTTPinger" http://www.google.com
5 kb from http://www.google.com/: code=200 msg=OK time=51 msecs
5 kb from http://www.google.com/: code=200 msg=OK time=61 msecs
5 kb from http://www.google.com/: code=200 msg=OK time=74 msecs
5 kb from http://www.google.com/: code=200 msg=OK time=48 msecs
5 kb from http://www.google.com/: code=200 msg=OK time=106 msecs
5 kb from http://www.google.com/: code=200 msg=OK time=51 msecs
5 kb from http://www.google.com/: code=200 msg=OK time=52 msecs
5 kb from http://www.google.com/: code=200 msg=OK time=50 msecs
5 kb from http://www.google.com/: code=200 msg=OK time=59 msecs
5 kb from http://www.google.com/: code=200 msg=OK time=60 msecs

--- http://www.google.com/ httping.rb statistics ---
10 GETs transmitted
round-trip min/avg/max = 48 msecs/61 msecs/106 msecs


## Command-line Options

    Usage: httping [options] uri
        -c, --count NUM                  Number of times to ping host
        -d, --delay SECS                 Delay in seconds between pings (default: 1)
        -f, --flood                      Flood ping (no delay)
        -j, --json                       Return JSON results
        -q, --quick                      Ping once and return OK if up
        -a, --audible                    Beep on each ping
        -u, --user-agent STR             User agent string to send in headers
        -r, --referrer STR               Referrer string to send in headers
        -h, --help                       Display this screen

## Installation

    jp@populuxe:~$ gem install httping

## Requirements

- FakeWeb (in order to run the specs)

## LICENSE:

(The MIT License)

Copyright (c) 2009 Jay Pignata

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
