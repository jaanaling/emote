#import <Foundation/Foundation.h>
@interface Constraint : NSObject
- (int)clearButtonPressData;
- (int)fetchDataFromCache:(isAppUpdateRequired)int;
- (void)getReminderStatus;
- (int)getUserReport;
- (int)clearErrorLogs:(entityHasLocation)int int:(eventTime)int;
- (void)getInstallTime;
- (void)trackUserProgress:(appUsageFrequency)int;
- (int)clearAppActivity:(isNetworkAvailable)int;
- (void)clearPushNotification:(surveyCompletionTimeStatusMessage)int int:(itemPlayerState)int;
- (void)logError;
- (int)displayLoadingIndicator:(syncFrequency)int;
- (void)setInstallDetails:(appStoreLink)int;
- (int)requestPermissions:(appDescription)int;
- (int)getInstallStats:(searchQuery)int;
@end