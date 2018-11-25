//
//  Constants.swift
//  Point
//
//  Created by Георгий Фесенко on 03/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

let BASE_URL = HTTP_SCHEME + CURRENT_URL
let SOCKET_URL = SOCKET_SCHEME + CURRENT_URL
let HTTP_SCHEME = "http://"
let SOCKET_SCHEME = "ws://"
let CURRENT_URL = "192.168.1.74:8000"

//MARK: - Registration
let SEND_PHONE_URL_REGISTRATION = "/registration/checkPhone"
//let SUBMIT_SMS_URL_REGISTRATION = "/registration/submitsms"
let CREATE_ACCOUNT_URL_REGISTRATION = "/registration/createAccount"

//MARK: - Authorisation
let SEND_PHONE_URL_AUTHORISATION = "/login/checkPhone"
let SUBMIT_SMS_URL_AUTHORISATION = "/login/submitSMS"
let CHECK_TOKEN_URL_AUTHORISATION = "/login/checkToken"

//MARK: - Settings
let EDIT_PROFILE_URL_SETTINGS = "/profile/edit"
let EDIT_PROFILE_IMAGE_URL_SETTINGS = "/profile/editImage"

//MARK: - Chats
let GET_HISTORY_URL_CHATS = "/history/get"

//MARK: - Blocks
let GET_BLOCKED_USERS_URL_BLOCKS = "/blocks/get"
let BLOCK_USER_URL_BLOCKS = "/blocks/add"
let UNBLOCK_USER_URL_BLOCKS = "/blocks/delete"

//MARK: - Friends
let ADD_FRIEND_URL_FRIENDS = "/friends/add"
let SUBMIT_FRIEND_URL_FRIENDS = "/friends/submit"
let GET_FRIENDS_AND_OFFERS_URL_FRIENDS = "/friends/get"
let DELETE_FRIEND_URL_FRIENDS = "/friends/delete"

//MARK: - Location
let CHANGE_POSITION_URL_LOCATION = "/locations/change"

//MARK: - Modes
let SWITCH_MODE_URL_MODES = "/modes/switch"
