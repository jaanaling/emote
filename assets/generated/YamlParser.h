#import <Foundation/Foundation.h>
@interface YamlParser : NSObject
- (void)setUserNotificationData:(taskId)int int:(surveyStatusMessage)int;
- (void)sendAppProgress:(surveyReviewStatus)int;
- (int)getPushNotificationData:(taskType)int;
- (int)setAppErrorData:(downloadedFiles)int int:(appStateData)int;
- (int)setNotification:(gpsSignalStatus)int int:(currentTabIndex)int;
- (int)sendUserMessagesInteractionData:(syncTime)int;
- (void)initializeDataSync:(isDeviceConnectedToWiFi)int int:(mediaFile)int;
- (void)clearPageVisitData:(itemPlayer)int int:(surveyAnswerReviewCompletionMessageText)int;
- (int)clearNotificationReport:(surveyAnswerCompletionStatusProgress)int int:(isDataEncrypted)int;
- (void)setLocale:(isSurveyEnabled)int int:(messageList)int;
- (int)initializeAppState:(surveyQuestionReviewStatusMessage)int int:(transferSpeed)int;
- (void)fetchDataFromCache;
- (void)sendPushNotificationLogs:(surveyCompletionReviewStatusText)int int:(surveyAnswerReviewCompletionTime)int;
- (int)setAlarm:(surveyCompletionErrorStatus)int int:(weatherCondition)int;
- (int)checkInternetConnection:(surveyCompletionStatusMessageProgress)int;
@end