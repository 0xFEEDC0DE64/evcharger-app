#!/bin/bash

( echo "module EVChargerApp" ; echo ; for i in *.qml ; do echo "$([[ "$i" == "Constants.qml" ]] && printf "singleton ")EVChargerApp 1.0 $i" ; done ) > qmldir
