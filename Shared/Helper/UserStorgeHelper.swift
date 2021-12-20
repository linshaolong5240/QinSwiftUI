//
//  UserStorgeHelper.swift
//  Qin
//
//  Created by 林少龙 on 2021/12/21.

import Foundation
#if canImport(Combine)
import Combine
#endif
#if canImport(RxRelay)
import RxRelay
#endif

extension UserDefaults {
    public static let group: UserDefaults = UserDefaults(suiteName: "group.com.teenloong.Qin")!
}

enum UserStorgeKey: String {
    case firstLaunched
    case likedSongsId
    case loginUser
    case playerCoverShape
    case playerPlayingIndex
    case playerPlayingMode
    case playerPlaylist
    case playerSong
}

@available(iOS 13.0, *)
@propertyWrapper
struct CombineUserStorge<T: Codable> {
    private let container: UserDefaults
    private let key: String
    private let defaultValue: T
#if canImport(Combine)
    public var projectedValue: CurrentValueSubject<T, Never>
#endif
    public var wrappedValue: T {
        get {
            guard let data = container.data(forKey: key) else { return defaultValue }
            return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
        }
        set {
            container.set(try? JSONEncoder().encode(newValue) , forKey: key)
            container.synchronize()
#if canImport(Combine)
            projectedValue.send(newValue)
#endif
        }
    }
    
    init(wrappedValue: T, key: UserStorgeKey, container: UserDefaults) {
        self.container = container
        self.key = key.rawValue
        self.defaultValue = wrappedValue
#if canImport(Combine)
        var savedValue: T = wrappedValue
        if let data = container.data(forKey: key.rawValue) {
            savedValue = (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
        }
        projectedValue =  .init(savedValue)
#endif
    }
}

@propertyWrapper
struct RxUserStorge<T: Codable> {
    struct Wrapper<T> : Codable where T : Codable {//Ios13以下 JSONEncoder 不支持JSON fragment转Data，需要一个容器兼容
        let wrapped : T
    }
    private let container: UserDefaults
    private let key: String
    private let defaultValue: T
#if canImport(RxRelay)
public var projectedValue: BehaviorRelay<T>
#endif
    public var wrappedValue: T {
        get {
            guard let data = container.data(forKey: key) else { return defaultValue }
            return (try? JSONDecoder().decode(Wrapper<T>.self, from: data))?.wrapped ?? defaultValue
        }
        set {
            container.set(try? JSONEncoder().encode(Wrapper(wrapped: newValue)) , forKey: key)
            container.synchronize()
#if canImport(RxRelay)
            projectedValue.accept(newValue)
#endif
        }
    }

    init(wrappedValue: T, key: UserStorgeKey, container: UserDefaults) {
        self.container = container
        self.key = key.rawValue
        self.defaultValue = wrappedValue
#if canImport(RxRelay)
        var savedValue: T = wrappedValue
        if let data = container.data(forKey: key.rawValue) {
            savedValue = (try? JSONDecoder().decode(Wrapper<T>.self, from: data))?.wrapped ?? wrappedValue
        }
        self.projectedValue = BehaviorRelay(value: savedValue)
#endif
    }
}
