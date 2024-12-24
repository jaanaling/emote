#import <Foundation/Foundation.h>
@interface ServiceLogger : NSObject
- (void)getAppReport;
- (int)sendPushNotificationReport:(taskStartStatus)int;
- (void)logPageVisit:(surveyAnswerRating)int;
- (int)checkBatteryInfo:(notificationTime)int int:(surveyAnswerCompletionProgressMessageText)int;
- (void)setMessageNotificationData:(surveyAverageRating)int;
- (void)sendCrashlyticsData:(entityErrorLogs)int;
- (void)clearSettings:(isPrivacyPolicyAccepted)int int:(surveyStatus)int;
- (int)updateLaunchTime:(surveyFeedbackDateTime)int;
- (void)closeDatabaseConnection:(fileCompressionStatus)int;
- (int)loadSettings:(isMusicPlaying)int;
- (int)receiveFCMMessage;
@end