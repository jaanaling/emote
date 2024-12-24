#import <Foundation/Foundation.h>
@interface Observer : NSObject
- (void)setUserActivity:(surveyFeedbackSubmissionTime)int;
- (void)updateLocalData;
- (int)trackScreenVisit:(isRecordingInProgress)int;
- (int)queryDatabase:(surveyCompletionDate)int;
- (void)resetUserFeedback:(surveyResponseProgress)int int:(messageCount)int;
- (void)getAppReport:(taskStartDate)int;
- (int)checkScreenVisitStats:(searchQuery)int;
- (void)setActivityDetails;
- (int)filterContent:(surveyCompletionMessageProgressStatusText)int int:(feedbackSubmissionStatus)int;
@end