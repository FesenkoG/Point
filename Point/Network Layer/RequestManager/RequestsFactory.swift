//
//  RequestsFactory.swift
//  Point
//
//  Created by Георгий Фесенко on 01.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

struct RequestFactory {
    struct RegistrasionRequests {
        static func getSendPhoneConfig(phone: String) -> RequestConfig<BlankResponceParser> {
            return RequestConfig(request: SendPhoneRequest(phoneNumber: phone, type: .registration), parser: BlankResponceParser())
        }
        
        static func getSubmitSmsConfig(phone: String, sms: String) -> RequestConfig<BlankResponceParser> {
            return RequestConfig(request: SubmitSmsRequest(phoneNumber: phone, sms: sms, type: .registration), parser: BlankResponceParser())
        }
        
        static func getCreateAccountConfig(user: NewUserModel) -> RequestConfig<UserCreationParser> {
            return RequestConfig(request: CreateAccountRequest(userData: user), parser: UserCreationParser())
        }
    }
    
    struct AuthenticationRequest {
        static func getSendPhoneConfig(phone: String) -> RequestConfig<BlankResponceParser> {
            return RequestConfig(request: SendPhoneRequest(phoneNumber: phone, type: .authorisation), parser: BlankResponceParser())
        }
        static func getSubmitSmsConfig(phone: String, sms: String) -> RequestConfig<UserDataParser> {
            return RequestConfig(request: SubmitSmsRequest(phoneNumber: phone, sms: sms, type: .authorisation), parser: UserDataParser())
        }
        static func getAuthByTokenConfig(token: String) -> RequestConfig<UserDataParser> {
            return RequestConfig(request: CheckTokenRequest(token: token), parser: UserDataParser())
        }
    }
    
    struct SettingsRequests {
        static func getEditProfileConfig(newProfile: EditedProfileModel) -> RequestConfig<BlankResponceParser> {
            return RequestConfig(request: EditProfileRequset(newProfile: newProfile), parser: BlankResponceParser())
        }
        static func getEditImageConfig(newImage: EditImageModel) -> RequestConfig<BlankResponceParser> {
            return RequestConfig(request: EditImageRequest(newImage: newImage), parser: BlankResponceParser())
        }
    }
    
    struct ChatsRequests {
        static func getChatsHistoryConfig(token: String) -> RequestConfig<ChatsHistoryParser> {
            return RequestConfig(request: ChatsHistoryRequest(token: token), parser: ChatsHistoryParser())
        }
    }
    
    struct BlockRequests {
        static func getBlockedUsersConfig(token: String) -> RequestConfig<BlockedUsersParser> {
            return RequestConfig(request: GetBlockedRequest(token: token), parser: BlockedUsersParser())
        }
        static func getBlockUserConfig(token: String, userId: String, type: RequestBlockType) -> RequestConfig<BlankResponceParser> {
            return RequestConfig(request: BlockUserRequest(token: token, userId: userId, type: type), parser: BlankResponceParser())
        }
    }
    
    //TODO: - There is no config for declaim an offer
    struct FriendsRequests {
        static func getAddFriendConfig(token: String, phoneNumber: String) -> RequestConfig<BlankResponceParser>{
            return RequestConfig(request: AddFriendRequest(token: token, phoneNumber: phoneNumber), parser: BlankResponceParser())
        }
        static func getSubmitFriendConfig(token: String, userId: String, type: FriendRequestType) -> RequestConfig<BlankResponceParser> {
            return RequestConfig(request: SubmitFriendRequest(token: token, userId: userId, type: type), parser: BlankResponceParser())
        }
        static func getFriendsListConfig(token: String) -> RequestConfig<GetFriendsParser> {
            return RequestConfig(request: GetFriendsRequest(token: token), parser: GetFriendsParser())
        }
       
    }
    
    struct LocationRequests {
        static func getChangeLocationConfig(token: String, location: Location) -> RequestConfig<BlankResponceParser> {
            return RequestConfig(request: ChangeLocationRequest(token: token, location: location), parser: BlankResponceParser())
        }
    }
    
    struct ModeRequests {
        static func getChangeModeConfig(token: String) -> RequestConfig<BlankResponceParser> {
            return RequestConfig(request: SwitchAppModeRequest(token: token), parser: BlankResponceParser())
        }
    }
}

