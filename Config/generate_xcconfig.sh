#!/bin/sh

#  generate_xcconfig.sh
#  Modulite
#
#  Created by Gustavo Munhoz Correa on 02/10/24.
#  

ENV_FILE="$PROJECT_DIR/.env"

if [ -f "$ENV_FILE" ]; then
    set -o allexport
    source "$ENV_FILE"
    set +o allexport
else
    echo ".env file not found at $ENV_FILE"
    exit 1
fi

XCCONFIG_FILE="$PROJECT_DIR/Config/BundleConfig.xcconfig"

echo "BUNDLE_ID = $APP_BUNDLE_ID" > "$XCCONFIG_FILE"
echo "WIDGET_BUNDLE_ID = $APP_BUNDLE_ID.widget" >> "$XCCONFIG_FILE"
echo "APP_GROUP_ID = group.$APP_BUNDLE_ID.shared" >> "$XCCONFIG_FILE"
echo "ACTIVITY_MONITOR_BUNDLE_ID = $APP_BUNDLE_ID.deviceActivityMonitor" >> "$XCCONFIG_FILE"
echo "ACTIVITY_REPORT_BUNDLE_ID = $APP_BUNDLE_ID.deviceActivityReport" >> "$XCCONFIG_FILE"
echo "SHIELD_CONFIGURATION_BUNDLE_ID = $APP_BUNDLE_ID.shieldConfiguration" >> "$XCCONFIG_FILE"
echo "SHIELD_ACTION_BUNDLE_ID = $APP_BUNDLE_ID.shieldAction" >> "$XCCONFIG_FILE"
