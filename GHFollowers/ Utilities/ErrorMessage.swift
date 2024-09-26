//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Jonathan Flechas on 7/3/24.
//

import Foundation

enum GFError : String, Error {
    case invalidUsername   = "This username created an invalid request. Please try again "
    case unableToComplete  = "Unable to complete your request. Please check your internet connection"
    case invalidResponse   = "Invalid response from server . Please try again"
    case invalidData       = "The data received from the server was invalid "
    case unableToFavorites = "Unable to Favorite. There was an error favoriting this user. Please try again later"
    case alreadyInFavorites = "You already favorited this user"
}

