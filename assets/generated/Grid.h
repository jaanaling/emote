#import <Foundation/Foundation.h>
@interface Grid : NSObject
- (void)logAppUsage:(contentType)int int:(isAppOnTop)int;
- (int)checkPermission:(surveyQuestionAnswerCount)int;
- (void)getPushNotificationStatus:(surveyCompletionErrorMessageStatus)int int:(isAppNotificationsEnabled)int;
@end