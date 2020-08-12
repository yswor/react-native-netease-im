#include "Message.h"

@implementation Message

-(instancetype)initWithParams:(NSString *)id :(NSString *)account :(NIMSessionType)sessionType
{
    if (self = [super init]) {
        self->messageId = id;
        self->account = account;
        self->sessionType = sessionType;
    }
    return self;
}

-(NSDictionary *)getMessage
{
    NimConstant *nimConstant = [[NimConstant alloc] init];
    NIMSession *session = [NIMSession session:self->account type:self->sessionType];
    NSArray<NIMMessage *> *nimMessages = [[[NIMSDK sharedSDK] conversationManager] messagesInSession:session messageIds:@[self->messageId]];
    NIMMessage *message = nimMessages[0];

    if (!message) {
        return nil;
    }

    NSDictionary *dict = @{
        // 消息ID
        @"id": message.messageId,
        // 会话ID
        @"session_id": message.session.sessionId,
        // 会话类型
        @"session_type": nimConstant->sessionType[message.session.sessionType],
        // 发送方的帐号
        @"from_account": message.from,
        // 发送者的昵称
        @"from_nick": message.senderName,
        // 消息类型
        @"type": nimConstant->messageType[message.messageType],
        // 消息投递状态
        @"status": nimConstant->deliveryState[message.deliveryState],
        // 消息方向
        @"direct": message.isReceivedMsg ? @"In" : @"Out",
        // 消息文本
        @"content": message.text,
        // 回复时间
        @"time": @(message.timestamp * 1000),
        // 会话服务扩展字段
        @"extension": message.localExt == nil ? @"" : message.localExt
    };

    return dict;
}

@end