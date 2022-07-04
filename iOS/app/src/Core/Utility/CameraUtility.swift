//
//  CameraUtility.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/16/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import AVKit

struct CameraUtility {
    static func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera, .builtInMicrophone, .builtInTelephotoCamera ], mediaType: AVMediaType.video, position: .unspecified).devices
        
        if devices.count > 0 {
            for device in devices {
                if device.position == position {
                    return device
                }
            }
        }
        
        return nil
    }
}
