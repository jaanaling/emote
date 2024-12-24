#import <Foundation/Foundation.h>
@interface StateController : NSObject
- (void)logUserAction;
- (int)trackAppLaunch;
- (void)resetLocationDetails:(gpsSignalQuality)int int:(isSubscribed)int;
- (int)sendPutRequest;
- (void)saveInitialData;
- (void)setAppLaunchTime;
- (void)clearPushNotificationLogs;
- (int)initializeAppLaunchTracking:(privacyPolicyAcceptedTime)int int:(surveyErrorMessage)int;
- (void)clearCrashData;
- (void)getDeviceName:(isFileTransferComplete)int int:(surveyStartStatus)int;
- (void)downloadFileFromServer;
- (int)clearErrorLogs:(isNotificationsEnabled)int;
- (void)loadPreferences:(surveyCompletionTimeStatusMessage)int;
@end