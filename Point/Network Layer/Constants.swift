//
//  Constants.swift
//  Point
//
//  Created by Георгий Фесенко on 03/08/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import Foundation

let BASE_URL = "http://ec2-18-196-137-189.eu-central-1.compute.amazonaws.com"

//MARK: - Registration
let SEND_PHONE_URL_REGISTRATION = "/registration/checkphone"
let SUBMIT_SMS_URL_REGISTRATION = "/registration/submitsms"
let CREATE_ACCOUNT_URL_REGISTRATION = "/registration/createaccount"

//MARK: - Authorisation
let SEND_PHONE_URL_AUTHORISATION = "/login/checkphone"
let SUBMIT_SMS_URL_AUTHORISATION = "/login/submitsms"
let CHECK_TOKEN_URL_AUTHORISATION = "/login/checktoken"

//MARK: - Settings
let EDIT_PROFILE_URL_SETTINGS = "/profile/editprofile"
let EDIT_PROFILE_IMAGE_URL_SETTINGS = "/profile/editimage"

//MARK: - Chats
let GET_HISTORY_URL_CHATS = "/history/gethistory"

//MARK: - Blocks
let GET_BLOCKED_USERS_URL_BLOCKS = "/blocks/getblocks"
let BLOCK_USER_URL_BLOCKS = "/blocks/blockuser"
let UNBLOCK_USER_URL_BLOCKS = "/blocks/unblockuser"

//MARK: - Friends
let ADD_FRIEND_URL_FRIENDS = "/friends/addfriend"
let SUBMIT_FRIEND_URL_FRIENDS = "/friends/submitfriend"
let GET_FRIENDS_AND_OFFERS_URL_FRIENDS = "/friends/getfriends"
let DELETE_FRIEND_URL_FRIENDS = "/friends/deletefriend"

//MARK: - Location
let CHANGE_POSITION_URL_LOCATION = "/locations/change"

//MARK: - Modes
let SWITCH_MODE_URL_MODES = "/modes/switch"
