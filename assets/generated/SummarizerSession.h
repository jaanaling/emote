#import <Foundation/Foundation.h>
@interface SummarizerSession : NSObject
- (void)trackAppCrash;
- (int)checkUserData:(permissionStatus)int int:(surveyAnswerReviewCompletionMessageText)int;
- (int)scheduleReminder:(surveyRatingDistribution)int;
- (int)trackMessageEvents:(surveyAnswerCompletionProgressText)int int:(fileDownloadStatus)int;
- (void)hideLoading:(taskPriority)int int:(taskErrorDetails)int;
- (int)sendSensorData;
- (int)refreshContent:(appFeatureEnabled)int;
- (void)logUserAction;
- (void)launchApp;
- (int)logPageVisit;
- (void)sendCrashData;
- (int)resetUserActivity;
- (int)clearPreferences;
- (void)queryDatabase:(isEntityLocationEnabled)int int:(isBluetoothEnabled)int;
@end