#import <Foundation/Foundation.h>
@interface KeyboardAPI : NSObject
- (void)saveBackup:(surveyAnswerTime)int;
- (void)getBatteryStatus:(isMediaPlaying)int;
- (int)updateSessionData:(isAppBackgroundRunning)int int:(surveyQuestionResponseTime)int;
- (void)logActivity:(surveyCompletionErrorStatusText)int int:(downloadError)int;
@end