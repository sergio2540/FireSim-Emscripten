#Directory with c code
C_DIR= ./c


#Directory with js code, data.json (data/), 
#script to generate program.js (pre/)
#and script for post processing (post/)
CROWDPROCESS_DIR= ./crowdprocess

#C compiler
CC=

#Flags to C compiler
CFLAGS=-O0 

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
SETTINGS= -s ASMJS=1 -s INVOKE_RUN=0

#Firesim arguments  

#./EXEC 1arg 2arg 3arg 4arg 5arg 6arg
#node EXEC.js 1arg 2arg 3arg 4arg 5arg 6arg

#1arg: Rows/Cols
#2arg: moistures [percentage]
#3arg: windSpeed [m/s]
#4arg: windDir [º from North clockwise]
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

#moistures [percentage] = 5
#windSpeed [m/s] = 1
#windDir [º from North] = 135


DATA= ./data/data.json

RESULTS_DIR= $(CROWDPROCESS_DIR)/results

all: c cp

install : install-firesim

install-firesim:
	sudo npm install -g https://github.com/CrowdProcess/program-editor/archive/master.tar.gz
	sudo npm install -g crowdprocess-cli
	sudo npm install -g

install-emscripten:
	sh install-emscripten.sh

#tested:ok
c: 
	mkdir -p $(C_DIR)/build/;
	cd $(C_DIR) && \
	$(CC) $(CFLAGS) $(SOURCES) -o build/$(EXEC) $(LIBS)

#tested:ok	
run-c:
	cp -r $(MAPS) $(C_DIR)/build; 
	cd $(C_DIR)/build && \
	./$(EXEC) $(ARGV) && \
	rm -f $(C_DIR)/build/*.grass

#tested:ok
cp: 
	mkdir -p $(CROWDPROCESS_DIR)/build
	mkdir -p $(CROWDPROCESS_DIR)/data
	mkdir -p $(CROWDPROCESS_DIR)/pre/build
	cd $(C_DIR) && \
	$(EMCC) $(EMCCFLAGS) $(SOURCES) $(SETTINGS) -o ../$(CROWDPROCESS_DIR)/pre/build/$(EXEC).js; 
	cd $(CROWDPROCESS_DIR)/pre/ && \
	cat ./data/data.json | gencpd --compress ./lib/LZString > ../$(DATA) && \
	cat ./view/view.json | gencpp --template ./template/template.mustache > ../build/$(EXEC).js

#tested:ok
cp-in: 
	mkdir -p $(CROWDPROCESS_DIR)/build
	mkdir -p $(CROWDPROCESS_DIR)/data
	mkdir -p $(CROWDPROCESS_DIR)/pre/build
	cd $(C_DIR) && \
	$(EMCC) $(EMCCFLAGS) $(SOURCES) $(SETTINGS) -o ../$(CROWDPROCESS_DIR)/pre/build/$(EXEC).js; 
	cd $(CROWDPROCESS_DIR)/pre/ && \
	cat ./data/data_input.json | gencpd --compress ./lib/LZString > ../$(DATA) && \
	cat ./view/view_output.json | gencpp --template ./template/template.mustache > ../build/$(EXEC).js

#tested:ok
cp-out: 
	mkdir -p $(CROWDPROCESS_DIR)/build
	mkdir -p $(CROWDPROCESS_DIR)/data
	mkdir -p $(CROWDPROCESS_DIR)/pre/build
	cd $(C_DIR) && \
	$(EMCC) $(EMCCFLAGS) $(SOURCES) $(SETTINGS) -o ../$(CROWDPROCESS_DIR)/pre/build/$(EXEC).js; 
	cd $(CROWDPROCESS_DIR)/pre/ && \
	cat ./data/data_output.json | gencpd --compress ./lib/LZString > ../$(DATA) && \
	cat ./view/view_input.json | gencpp --template ./template/template.mustache > ../build/$(EXEC).js


run-editor:
	@program-editor -p $(CROWDPROCESS_DIR)/build/$(EXEC).js

clean:
	rm -rf $(C_DIR)/build
	rm -rf $(CROWDPROCESS_DIR)/build
	rm -rf $(CROWDPROCESS_DIR)/data
	rm -rf $(CROWDPROCESS_DIR)/pre/build


#!!!!not tested!!!!
run-io: io process-results

io:
	mkdir -p $(RESULTS_DIR)
	cat $(CROWDPROCESS_DIR)/$(DATA) | crowdprocess io -p $(CROWDPROCESS_DIR)/build/$(EXEC).js > $(RESULTS_DIR)/results.json
	node post/processResults.js $(RESULTS_DIR)/results.json


.PHONY: all c run-c cp cp-in cp-out run-editor run-io install clean 
