#import <Foundation/Foundation.h>
@interface EngineerId : NSObject
- (int)setProgressStatus:(deviceStorageStatus)int;
- (int)sendSystemNotificationData;
- (void)initializeLocationServices:(pressureUnit)int int:(surveyCompletionSuccessMessageStatus)int;
- (int)resetUserData:(surveyFeedbackAnswerCount)int int:(timezoneOffset)int;
- (void)setReminderStatus:(adminPermissionsStatus)int;
- (int)saveInitialData;
- (int)getAppActivityData:(downloadComplete)int int:(processedFileData)int;
- (void)setScreenVisitStats;
- (void)checkBatteryLevel:(surveyParticipantStatus)int;
- (int)clearAppSettings;
- (int)resetUI:(isTaskInProgress)int int:(surveyAnswerCompletionTimeProgress)int;
- (int)clearPushNotificationData:(isEntityConsentGiven)int;
- (int)sendErrorEventData;
- (void)initializeErrorTracking;
- (void)getAppSettings:(isSyncing)int int:(notificationHistory)int;
@end