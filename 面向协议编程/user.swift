//
//  user.swift
//  面向协议编程
//
//  Created by tanxiaokang on 2018/4/214.
//  Copyright © 2018年 runze. All rights reserved.
//

import Foundation

enum HTTPMethod:String {
    case GET
    case POST
}

class user {
    
}
protocol Decodable {
    static func parse(data:Data) -> Self?
}
protocol Request {
    var path : String { get }
    var method:HTTPMethod { get }
    var parameter : [String:Any] { get }
    
    associatedtype Response:Decodable
}
protocol Client {
    func send<T: Request>(_ r: T, handler:@escaping(T.Response?) -> Void)
    var host : String { get }
}
struct User {
    let name :String
    let message :String
    
    init?(data:Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        guard let name = obj?["name"] as? String else { return nil }
        guard let message = obj?["message"] as? String else { return nil }
        
        self.name = name
        self.message = message
    }
}

struct UserRequest : Request {
    let method: HTTPMethod = .GET
    let parameter: [String : Any] = [:]
    let name:String
    
    var path:String {
        return "/users/\(name)"
    }
    typealias Response = User
}

struct URLSessionClient: Client {
    let host = "https://api.onevcat.com"
    func send<T>(_ r: T, handler: @escaping (T.Response?) -> Void) where T : Request {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
       
        let task = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data, let res = T.Response.parse(data: data)
            {
                DispatchQueue.main.async { handler(res) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}

struct LocalFileClient :Client {
    var host = ""
    func send<T>(_ r: T, handler: @escaping (T.Response?) -> Void) where T : Request {
        switch r.path {
        case "/users/onevcat":
            
            guard let jsonPath = Bundle.main.path(forResource: "onevcat", ofType: "json") else {
                fatalError()
            }
            guard let data = NSData.init(contentsOfFile: jsonPath) else {
                fatalError()
            }
//            guard let fileURL = Bundle(for: ProtocolNetworkTests.self).url(forResource: "users/onevcat", withExtension: "") else {
//                fatalError()
//            }
//            guard let data = try? Data(contentsOf: fileURL) else {
//                fatalError()
//            }
            handler(T.Response.parse(data: data as Data))
        default:
            fatalError("Unknown path")
        }
    }
}

extension User:Decodable {
    static func parse(data: Data) -> User? {
        return User(data: data)
    }
}





































