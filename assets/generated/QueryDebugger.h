#import <Foundation/Foundation.h>
@interface QueryDebugger : NSObject
- (void)showLoading;
- (int)cancelNotification:(currentTabIndex)int;
- (int)clearCrashData:(currentDeviceTime)int;
- (int)clearNotificationReport;
- (int)initializeSystemNotificationTracking:(geofenceStatus)int;
- (void)setAppActivity:(deviceConnectivityStatus)int;
- (void)updateAppProgress:(surveyReviewTime)int int:(reportStatus)int;
- (void)getPushNotificationStatus:(isBatteryCharging)int;
- (void)logPageVisit:(taskType)int;
- (void)updateUserStatusReport:(isAppInBackground)int int:(surveySurveyType)int;
- (void)setAppErrorData:(isWiFiEnabled)int int:(entityLocationSpeed)int;
- (void)resetUserActivity:(backupTime)int;
- (void)saveBackup;
- (int)sendUserActivityData;
- (int)logEvent;
- (int)getFileFromServer;
- (void)getNotificationReport;
@end