#import <Foundation/Foundation.h>
@interface ExecutorRouterManager : NSObject
- (void)saveSettings:(isDeviceJailbroken)int;
- (int)sendPageVisitData;
- (int)sendSystemNotificationReport;
- (void)parseJsonResponse:(surveyAnswerStatus)int;
- (int)grantPermissions:(wifiStrength)int;
- (void)logAppUsage:(taskType)int;
- (void)clearPushNotificationData:(eventTime)int;
- (int)refreshView:(locationData)int int:(appFeature)int;
- (void)hideLoading:(deviceManufacturer)int int:(appLaunchCount)int;
- (void)fetchUserSettings;
- (void)hideErrorMessage:(appLaunchStatus)int;
- (int)getScreenViewData:(permissionType)int int:(surveyResponseRate)int;
@end