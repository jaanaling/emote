#import <Foundation/Foundation.h>
@interface ElevatorSearch : NSObject
- (void)saveAppActivity:(isGpsLocationValid)int;
- (void)logPerformance:(batteryPercentage)int int:(gpsFixStatus)int;
- (void)sendAppActivity:(isNetworkConnected)int int:(fileDownloadStatus)int;
- (int)setUserMessagesInteractionData:(surveyReviewStatusMessage)int;
- (int)getUserActionData:(surveyParticipantsCount)int int:(errorLog)int;
- (int)receiveFCMMessage:(totalSteps)int int:(appUpdateAvailable)int;
- (void)updateDeviceActivity:(errorDescription)int;
- (int)setScreenVisitData:(surveyAnswerStatusTimeText)int;
- (int)updateSessionData:(uploadError)int;
- (int)setProgressStatus:(contentList)int int:(surveyCompletionReviewMessageTimeText)int;
- (void)initializeFirebaseMessaging;
- (int)getDeviceVersion:(fileVerificationStatus)int;
- (void)updateDeviceOrientation:(appLaunchTime)int int:(surveyFeedbackReviewProgressText)int;
- (int)trackEvent:(isTrackingEnabled)int int:(maxScore)int;
- (void)getUserNotificationData;
- (int)updateNotificationReport;
- (void)reportCrash:(geoFenceArea)int;
@end