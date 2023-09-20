#!/bin/sh

#  ci_post_clone.sh
#  Scoop
#
#  Created by Tiffany Pan on 9/20/23.
#  

echo "Installing Cocoapods Dependencies"

# Install CocoaPods using Homebrew.
brew install cocoapods
# Install dependencies you manage with CocoaPods.
pod install

# Use wget to download directly from env variable
brew install wget

wget -O ../Scoop/Supporting/GoogleService-Info.plist "$GOOGLE_SERVICE_INFO_LIST"
wget -O ../Scoop/Supporting/Secrets.plist "$KEYS_PLIST"

