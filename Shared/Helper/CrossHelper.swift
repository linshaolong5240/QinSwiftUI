//
//  CrossHelper.swift
//  Qin
//
//  Created by teenloong on 2022/2/10.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
#if canImport(AppKit)
import AppKit
public typealias CrossColor = NSColor
public typealias CrossImage = NSImage
public typealias CrossView = NSView
public typealias CrossViewRepresent = NSViewRepresent
public typealias CrossViewControllerRepresent = NSViewControllerRepresent
#endif
#if canImport(UIKit)
import UIKit
public typealias CrossColor = UIColor
public typealias CrossImage = UIImage
public typealias CrossView = UIView
public typealias CrossViewRepresent = UIViewRepresent
public typealias CrossViewControllerRepresent = UIViewControllerRepresent
#endif
