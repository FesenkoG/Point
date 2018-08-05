//
//  RequestsFactory.swift
//  Point
//
//  Created by Георгий Фесенко on 01.08.2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

//TODO: Here requests config should be formed.
struct RequestFactory {
    struct RegistrasionRequests {
        static func getSendPhoneConfig(phone: String) -> RequestConfig<RegistrationSendPhoneResponseParser> {
            return RequestConfig(request: SendPhoneRequest(phoneNumber: phone, type: .registration), parser: RegistrationSendPhoneResponseParser())
        }
        
        static func getSubmitSmsConfig(phone: String, sms: String) -> RequestConfig<RegistrationSendPhoneResponseParser> {
            return RequestConfig(request: SubmitSmsRequest(phoneNumber: phone, sms: sms, type: .registration), parser: RegistrationSendPhoneResponseParser())
        }
        
        static func getCreateAccountConfig(user: NewUser) -> RequestConfig<UserCreationParser> {
            return RequestConfig(request: CreateAccountRequest(userData: user), parser: UserCreationParser())
        }
    }
    
    struct AuthenticationRequest {
        static func getSendPhoneConfig(phone: String) -> RequestConfig<RegistrationSendPhoneResponseParser> {
            return RequestConfig(request: SendPhoneRequest(phoneNumber: phone, type: .authorisation), parser: RegistrationSendPhoneResponseParser())
        }
        static func getSubmitSmsConfig(phone: String, sms: String) -> RequestConfig<UserDataParser> {
            return RequestConfig(request: SubmitSmsRequest(phoneNumber: phone, sms: sms, type: .authorisation), parser: UserDataParser())
        }
        static func getAuthByTokenConfig(token: String) -> RequestConfig<UserDataParser> {
            return RequestConfig(request: CheckTokenRequest(token: token), parser: UserDataParser())
        }
    }
}

