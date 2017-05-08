//
//  String.swift
//  Daze
//
//  Created by David Sirkin on 5/3/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

extension String {
    
    func log(data: Data) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMM dd"
        let date = formatter.string(from: Date())
        
        let participant = (UIApplication.shared.delegate as! AppDelegate).participant ?? "Participant"
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
        
        let url = dir.appendingPathComponent("\(date) \(participant)") as URL
        
        if !FileManager.default.fileExists(atPath: url.path) {
            FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
        
        do {
            try data.appendLineTo(url: url)
        } catch {
        }
        // let result = try String(contentsOf: url as URL, encoding: String.Encoding.utf8)
    }
    
    func time() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss:SSS"
        return formatter.string(from: Date())
    }
    
    func appendTo(url: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.appendLineTo(url: url)
    }
    
    func appendLineTo(url: URL) throws {
        try ("\(time), self\n").appendTo(url: url)
    }
}

extension Data {
    
    func appendLineTo(url: URL) throws {
        if let handle = FileHandle(forWritingAtPath: url.path) {
            defer {
                handle.closeFile()
            }
            handle.seekToEndOfFile()
            handle.write(self)
        }
        else {
            try write(to: url, options: .atomic)
        }
    }
}
