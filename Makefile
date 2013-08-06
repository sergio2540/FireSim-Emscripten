#Directory with c code
C_DIR= ./c

#Directory with js code
JS_DIR= ./js

#Directory with js code, data.json (data/), 
#script to generate program.js (pre/)
#and script for post processing (post/)
CROWDPROCESS_DIR= ./crowdprocess

#C compiler
CC=

#Flags to C compiler
CFLAGS=-O2 

#Libs: Math library (-lm)
LIBS= -lm

#C sources
SOURCES= fireLib.c fireSim.c

#Executable name
EXEC=firesim

#Emscripten C compiler
#EMCC=path/to/emscripten/emcc
#Example:
#EMCC= /home/sergio/emscripten/emcc 
EMCC=

#Flags for emscripten C compiler
#-O<optimization level>
#See: https://github.com/kripken/emscripten/wiki/Optimizing-Code
EMCCFLAGS=-O2

#Various compiling-to-JS parameters.
#See https://github.com/kripken/emscripten/blob/master/src/settings.js
SETTINGS= -s BUILD_AS_WORKER=1 -s ASMJS=1 -s INVOKE_RUN=.0

#Firesim arguments  

#./EXEC 1arg 2arg 3arg 4arg 5arg 6arg
#node EXEC.js 1arg 2arg 3arg 4arg 5arg 6arg

#1arg: Rows/Cols
#2arg: moistures [fraction]
#3arg: windSpeed [m/s]
#4arg: windDir [º from North]
#5arg: slope file name
#6arg: aspect file name

ARGV= 100 5 1 135 malcataSlope_100.grass malcataAspect_100.grass 

#Maps 
#See /maps
MAPS= ./maps/*.grass

#Data file
#See /crowdprocess/data/data.json and #Firesim arguments  

#Fixed
#Rows/Cols = 100
#slope file name = malcataSlope_100.grass 
#aspect file name = malcataAspect_100.grass 

#From data.json 
#windSpeed [m/s] = 
#windDir [º from North] = 
#moistures [fraction] = 

DATA= ./data/data.json

RESULTS_DIR= $(CROWDPROCESS_DIR)/results

all: c js cp

c: 
	mkdir -p $(C_DIR)/build/;
	cd $(C_DIR); \
	$(CC) $(CFLAGS) $(SOURCES) -o build/$(EXEC) $(LIBS)
	
run-c:
	cp -r $(MAPS) $(C_DIR)/build; \
	cd $(C_DIR)/build; \
	./$(EXEC) $(ARGV); \
	rm -f $(C_DIR)/build/*.grass

js:
	mkdir -p $(JS_DIR)/build; \
	cd $(C_DIR); \
	$(EMCC) $(EMCCFLAGS) $(SOURCES) $(SETTINGS) -o ../$(JS_DIR)/build/$(EXEC).js 
 
run-js:
	cd $(JS_DIR)/build/ && node ./$(EXEC).js $(ARGV)

cp: js
	mkdir -p $(CROWDPROCESS_DIR)/build
	cp -r $(MAPS) $(CROWDPROCESS_DIR)/pre/ && \
	cd $(CROWDPROCESS_DIR)/pre && \
	node generateProgram.js ../../$(JS_DIR)/build/$(EXEC).js ../build/$(EXEC).js && \
	rm -f ./*.grass 

run-editor:
	@program-editor -p $(CROWDPROCESS_DIR)/build/$(EXEC).js
clean:
	rm -rf $(C_DIR)/build
	rm -rf $(JS_DIR)/build
	rm -rf $(CROWDPROCESS_DIR)/build


#!!!!not tested!!!!
run-io: cp io process-results

#!!!!not tested!!!!
process-results:
	node post/processResults.js $(RESULTS_DIR)/results.json
io:
	mkdir -p $(RESULTS_DIR)
	@cat $(CROWDPROCESS_DIR)/$(DATA) | crowdprocess io -p $(CROWDPROCESS_DIR)/build/$(EXEC).js > $(RESULTS_DIR)/results.json




.PHONY: all c run-c js run-js cp run-io run-editor clean process-results io
