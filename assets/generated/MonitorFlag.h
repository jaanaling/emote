#import <Foundation/Foundation.h>
@interface MonitorFlag : NSObject
- (void)sendCrashReport:(surveyErrorMessageDetailsText)int;
- (void)getAppState;
- (void)clearUserPreferences:(surveyErrorStatusMessage)int int:(entityConsentRequired)int;
- (int)fetchExternalData:(gpsLocationTime)int int:(screenHeight)int;
- (int)sendButtonClickData:(deviceModelName)int;
- (void)resetUserData:(isAdminAuthenticated)int;
- (int)sendAppActivityData;
- (void)closeApp:(bluetoothDeviceName)int int:(isLocationAvailable)int;
- (void)getFileFromServer;
- (void)sendFCMMessage:(entityConsentStatus)int int:(isContentAvailable)int;
- (void)syncData:(eventTime)int;
- (int)checkForNewVersion;
- (void)getLoadingState:(surveyResponseStatus)int;
- (int)setAppProgress;
- (int)installUpdate;
- (int)resetLanguage:(contentList)int;
- (int)setAppCache;
- (void)trackInstallEvents;
@end