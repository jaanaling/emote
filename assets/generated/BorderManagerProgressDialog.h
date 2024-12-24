#import <Foundation/Foundation.h>
@interface BorderManagerProgressDialog : NSObject
- (void)saveAppState:(isTaskCompleted)int int:(isMediaMuted)int;
- (int)setUserMessageData;
- (void)getFileFromServer:(taskDuration)int int:(fileName)int;
- (int)syncCacheData;
- (void)getAppEventData:(appNotificationSettings)int int:(fileVerificationStatus)int;
- (int)sendErrorReport:(downloadUrl)int;
- (void)clearAppActivity:(notificationTitle)int int:(appTitle)int;
- (int)sendDataToServer;
- (int)sendMessageNotificationLogs;
- (void)updateNetworkStatus;
- (int)trackUserActions:(entityActionStatus)int;
- (int)clearUsageStats:(maxScore)int int:(surveyResponseStatus)int;
- (int)requestConnectivity:(surveyAnswerCompletionFailureMessage)int;
- (int)closeApp:(isAppUpdateNotified)int int:(weatherCondition)int;
- (void)sendCrashData:(fileSyncStatus)int;
- (void)downloadUpdate:(entityHasBio)int;
- (void)getAppSettings;
- (void)getMessageNotificationLogs:(privacySettings)int;
@end