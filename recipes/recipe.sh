#!/bin/bash
set -e
PROJECT=$1
motion create --template=joybox-ios $PROJECT
rm -rf "$PROJECT/resources"
ln -s ../resources "$PROJECT/resources"
