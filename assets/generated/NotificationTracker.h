#import <Foundation/Foundation.h>
@interface NotificationTracker : NSObject
- (void)getScreenVisitStats:(isSyncing)int;
- (void)clearLaunchTime:(surveyAnswerStatusTime)int int:(isAppUpdateRequired)int;
- (void)clearUsageStats:(iconSize)int;
- (void)saveBackup:(selectedItem)int int:(filterOptions)int;
- (void)initializeData;
- (int)setUserEmail;
- (int)requestLocationPermission:(surveyCompletionErrorDetails)int;
- (void)setUserMessageData:(isEntityOnline)int;
- (void)getDeviceName;
- (int)trackUserSession:(taskResumeTime)int;
- (int)logActivityEvent:(isBatteryCharging)int int:(surveyErrorDetailMessage)int;
- (int)savePreference:(mediaPlayerState)int int:(taskEndDate)int;
- (void)trackScreenVisits:(activityStatus)int int:(isTaskPaused)int;
@end