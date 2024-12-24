#import <Foundation/Foundation.h>
@interface Key : NSObject
- (int)sendInteractionData:(locationPermissionStatus)int;
- (void)checkLaunchStatus:(dataSyncStatus)int;
- (void)logAnalyticsEvent:(isGpsLocationValid)int int:(entityErrorLogs)int;
- (int)sendAppActivityData;
- (void)checkAppPermissions;
- (int)getAppReport:(maxScore)int;
- (int)clearAppState:(appLaunchStatus)int int:(surveyAnswerCompletionReviewTimeText)int;
- (int)refreshContent;
- (int)updateUserFeedback:(systemErrorStatus)int;
- (void)sendCrashData:(isAppForegroundRunning)int int:(entityHasProfilePicture)int;
- (int)setScreenSize:(taskStartDate)int int:(itemPlaybackState)int;
- (void)handleApiError:(surveyAnswerReviewProgressTimeText)int;
@end