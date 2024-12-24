#import <Foundation/Foundation.h>
@interface Localization : NSObject
- (int)getAppCache;
- (void)applyUpdate;
- (void)updateLanguage;
- (int)getFileFromServer:(surveyRating)int;
- (int)checkFCMMessageStatus:(surveyFeedbackReceived)int;
- (int)trackError:(networkErrorStatus)int;
- (int)checkInstallStats;
- (void)showToast;
- (void)closeApp:(isTaskCompleted)int int:(isEntityConsentGiven)int;
@end