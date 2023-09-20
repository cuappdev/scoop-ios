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

echo "Getting Secrets..."
brew install wget

