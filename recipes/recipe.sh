#!/bin/bash
set -e
PROJECT=$1
motion create --template=joybox-ios $PROJECT
rm -rf "$PROJECT/resources"
ln -s ../../resources "$PROJECT/resources"
git add "$PROJECT"
git commit -m"Recipe $PROJECT: Initial"
