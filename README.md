FireSim-Emscripten
===========

##Requirements:
  * [Emscripten](https://github.com/kripken/emscripten/wiki/Tutorial)


##Usage:

####Compile c code: 
  `make c CC=gcc`
 
####Run c code: 
   
  `make run-c`
   or 
  `make run-c ARGV = 100 10 0.7 135 malcataAspect_100.grass malcataSlope_100.grass`

####Compile js code: 
  `make cp EMCC=path/to/emscripten/emcc`

####Run js with [program-editor](https://github.com/sergio2540/program-editor): 
   `make run-editor`
