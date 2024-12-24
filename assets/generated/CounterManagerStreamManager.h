#import <Foundation/Foundation.h>
@interface CounterManagerStreamManager : NSObject
- (int)updateUI:(isGeofencingEnabled)int;
- (void)sendActivityData:(delayedTaskData)int;
- (int)trackAppActivity;
- (int)checkPushNotificationStatus;
- (void)storeDataInCache;
- (int)getUserFeedback:(mediaType)int int:(lastActionTimestamp)int;
- (int)getLoadingState:(appPrivacyPolicyStatus)int int:(entityNotificationFrequency)int;
- (int)getAppLanguage;
- (int)setReminderStatus:(surveyAnswerCompletionTimeMessage)int int:(isProcessing)int;
- (void)clearAppActivityData;
- (void)clearLaunchTime;
- (void)initializeUserSession:(isNotificationsAllowed)int;
- (int)sendAppUsageData:(apiStatus)int;
- (void)getNotificationReport:(surveyAnswerCompletionStatusTimeText)int int:(contentUrl)int;
- (int)loadLocale:(notificationHistory)int;
- (void)deleteFileFromServer:(surveyEndDate)int;
- (int)trackAppNotifications:(notificationStatus)int;
@end