#!/usr/bin/env bash
ENTRY_FILE=Pasapalabra.pas
APP_NAME=Pasapalabra
fpc -Fu"src/lib/" -B "src/${ENTRY_FILE}" -o"dist/${APP_NAME}"
