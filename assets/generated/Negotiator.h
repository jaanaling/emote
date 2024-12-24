#import <Foundation/Foundation.h>
@interface Negotiator : NSObject
- (int)checkSMSStatus:(notificationStatus)int int:(surveyFeedbackAnswerMessage)int;
- (int)getSessionStatus;
- (void)getInstallStats:(isLocationEnabled)int int:(isDataEncrypted)int;
- (void)updateProgressStatus:(entityLocationAccuracy)int;
- (void)initializeAppLaunchTracking;
- (int)setNetworkInfo:(surveyCompletionProgressMessageText)int;
- (void)sendUserSessionData:(isMediaMuted)int;
- (void)clearSessionData;
- (int)sendPostRequest;
- (int)logSystemNotificationData:(gpsLocationAccuracy)int int:(isGpsLocationValid)int;
- (int)setUserStatus:(totalItems)int int:(trackingData)int;
- (void)clearPreferences;
- (int)initializePushNotificationTracking:(isActive)int;
@end