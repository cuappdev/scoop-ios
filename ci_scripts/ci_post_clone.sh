#!/bin/sh

#  ci_post_clone.sh
#  Scoop
#
#  Created by Tiffany Pan on 10/22/23.
#  

echo "Installing Cocoapods..."
brew install cocoapods
pod deintegrate
pod install

echo "Installing Secrets..."
brew install wget
wget -O ../Scoop/Supporting/GoogleService-Info.plist "$GOOGLE_SERVICE_PLIST"
wget -O ../Scoop/Supporting/Keys.plist "$KEYS_PLIST"
