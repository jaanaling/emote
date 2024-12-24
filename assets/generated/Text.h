#import <Foundation/Foundation.h>
@interface Text : NSObject
- (void)trackAnalyticsEvent:(isWiFiConnected)int;
- (int)trackUserProgress:(isTermsAndConditionsAccepted)int int:(uiElements)int;
- (int)setPushNotificationLogs;
- (int)updateUserProgress:(responseData)int;
- (int)trackPushNotificationEvents;
- (void)clearUserMessageData;
- (void)initDatabase;
- (void)loadDataFromCache;
- (int)sendReminder:(deviceStorage)int int:(selectedLanguage)int;
- (void)logCrashLogs:(appFeature)int int:(surveyAnswerCompletionTimeStatus)int;
@end