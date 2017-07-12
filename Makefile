##
##   Copyright (c) 2015, Dmitry Kolesnikov
##   All Rights Reserved.
##
##   Licensed under the Apache License, Version 2.0 (the "License");
##   you may not use this file except in compliance with the License.
##   You may obtain a copy of the License at
##
##       http://www.apache.org/licenses/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in writing, software
##   distributed under the License is distributed on an "AS IS" BASIS,
##   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##   See the License for the specific language governing permissions and
##   limitations under the License.
##
IID ?= fogfish
APP ?= mysql
VSN ?= latest

PORT ?= 3306
SOCK ?= 9999
KCOS  = $(shell echo $$((${SOCK}-1)))

##
## image build flags
DFLAGS = 

##
## image run flags
IFLAGS = \
	-p ${PORT}:3306 \
	-p ${SOCK}:9999 \
	-p ${KCOS}:9998

##
## build container
docker: Dockerfile
	docker build ${DFLAGS} -t ${IID}/${APP}:${VSN} -f $< . 

##
## 
run:
	docker run -it ${IFLAGS} ${IID}/${APP}:${VSN}

##
##
debug:
	docker run -it ${IFLAGS} ${IID}/${APP}:${VSN} bash

