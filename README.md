FireSim-Emscripten
===========

##Requirements:
  * [Emscripten](https://github.com/kripken/emscripten/wiki/Tutorial)


##Usage:

####Compile c code: 
  `make firesim CC=gcc`
 
####Run c code: 
   
  `make run-c`
   or 
  `make run-c ARGV = 100 10 0.7 135 malcataAspect_100.grass malcataSlope_100.grass`

####Compile js code: 
  `make firesim.js EMCC=path/to/emscripten/emcc`

####Run js in Node:
 `make run-js`
 
####Run js in crowdprocess: 
  `make run-io` or `make run-editor`
