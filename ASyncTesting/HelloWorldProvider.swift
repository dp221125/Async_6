//
//  HelloWorldProvider.swift
//  ASyncTesting
//
//  Created by seokho on 2022/05/17.
//

import Foundation

class HelloWorldProvider {
    static func asyncHelloWorld(completion: @escaping (String?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion("Hello World")
        }
    }
}
