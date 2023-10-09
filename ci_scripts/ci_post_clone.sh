#!/bin/sh

#  ci_post_clone.sh
#  Scoop
#
#  Created by Tiffany Pan on 9/27/23.
#  

brew install cocoapods
pod deintegrate
pod install

brew install wget
wget -O ../Scoop/Supporting/GoogleService-Info.plist "$GOOGLE_SERVICE_PLIST"
wget -O ../Scoop/Supporting/Secrets.plist "$SECRETS_PLIST"
