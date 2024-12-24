#import <Foundation/Foundation.h>
@interface GuestManager : NSObject
- (void)sendUserErrorData:(surveyCompletionSuccessStatus)int;
- (int)setAppMetrics:(deviceLanguage)int;
- (void)resetLanguage:(entityLocationError)int int:(surveyErrorStatusMessage)int;
- (void)trackAppProgress:(surveyFeedbackAnswerMessage)int int:(systemTimeZone)int;
- (void)clearUserPreferences:(appState)int;
- (void)clearInitialData:(appLanguageCode)int;
- (void)sendInteractionData:(isFirstTimeLaunch)int;
- (int)saveDataToDatabase;
- (void)saveUserDetails;
- (void)cancelAlarm;
@end