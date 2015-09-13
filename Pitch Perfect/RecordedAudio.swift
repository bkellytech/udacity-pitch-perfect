//
//  RecordedAudio.swift
//  Pitch Perfect
//  This is a model class for the Pitch Perfect Program
//  Created by admin on 9/10/15.
//  Copyright (c) 2015 admin. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}