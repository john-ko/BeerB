//
//  Beer.swift
//  Beerb
//
//  Created by John Ko on 4/24/16.
//  Copyright © 2016 John Ko. All rights reserved.
//

import Foundation

class Beer {
    var id: Int!
    var name: String!
    var beer_score: Float!
    var description: String!
    var image: String!
    var abv: Float!
    var ibu: Int!
    var brewer: String!
    
    let json = "[{\"id\":1,\"name\":\"Stone IPA\",\"beer_score\":4.5,\"description\":\"An \"India Pale Ale\" by definition is highly hopped and high in alcohol - you'll find our Stone India Pale Ale to be true to style with a huge hop aroma, flavor and bitterness throughout. If you're a hop-head like us, then you'll love our Stone India Pale Ale! Medium malt character with a heavy dose of over the top hops! Generous \"dry hopping\" gives this beer its abundant hop aroma and crisp hop flavor.\",\"image\":\"https://s3.amazonaws.com/brewerydbapi/beer/PAM6wX/upload_dl9pJu-icon.png\",\"abv\":6.9,\"ibu\":77,\"brewer\":\"Stone Brewing Company\",\"slug\":\"stoneipa\"}]"
    
}