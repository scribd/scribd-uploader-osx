#!/bin/sh
#
# Generates the Localizable.strings file and moves it to the correct location.

genstrings Source/*/*/*/*.m Source/*/*/*.m Source/*/*.m Source/*.m Vendor/TMInflector/*.m Vendor/TMMoveToApplicationsFolder/*.m
mv Localizable.strings Resources/English.lproj/
