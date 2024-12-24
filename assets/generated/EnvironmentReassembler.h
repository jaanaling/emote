#import <Foundation/Foundation.h>
@interface EnvironmentReassembler : NSObject
- (void)clearAppState;
- (int)sendNotificationReport:(surveyAnswerCompletionMessage)int int:(surveyCompletionReviewMessageTimeText)int;
- (int)trackDeviceActivity;
- (int)clearUserReport:(isAdminAuthenticated)int int:(entityActivityStatus)int;
- (void)updateUsageStats;
- (void)requestConnectivity:(feedbackSubmissionStatus)int int:(isLightThemeEnabled)int;
- (int)sendCrashLogs:(isNetworkConnected)int;
- (void)updateLanguage:(surveyAnswerReviewCompletionMessageText)int;
- (void)restartApp;
- (void)applyUpdate:(themeMode)int;
- (void)getPushNotificationStatus;
- (void)setUserActivity;
- (void)setDeviceManufacturer;
- (int)sendButtonPressData:(surveyCompletionNotificationStatus)int;
- (int)clearPreferences:(isDeviceSupported)int int:(totalItems)int;
- (void)getScreenVisitStats;
- (int)clearSyncData:(syncData)int int:(gpsLocationStatus)int;
@end