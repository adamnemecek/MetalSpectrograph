//
//  AudioPixelShaderView.swift
//  MetalSpectrograph
//
//  Created by David Conner on 9/16/15.
//  Copyright © 2015 Voxxel. All rights reserved.
//

import Cocoa
import MetalKit
import simd
import EZAudio

class AudioPixelShaderView: PixelShaderView {
    
}

class AudioPixelShaderViewController: PixelShaderViewController, EZMicrophoneDelegate {
    var microphone: EZMicrophone!
    var colorShiftChangeRate: Float = 0.2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.microphone = EZMicrophone(delegate: self)
        microphone.startFetchingAudio()
    }
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue(), {
            (self.renderer as! AudioPixelShaderRenderer).colorShift += self.colorShiftChangeRate * abs(buffer[0].memory)
        })
    }
    
    override func setupRenderer() {
        renderer = AudioPixelShaderRenderer()
    }
}

class AudioPixelShaderRenderer: TexturedQuadRenderer {
    var colorShift: Float = 0 {
        didSet { setColorShiftBuffer(self.colorShift) }
    }
    private var colorShiftPtr: UnsafeMutablePointer<Void>!
    private var colorShiftBuffer: MTLBuffer!
    
    override init() {
        super.init()
        
        fragmentShaderName = "texQuadFragmentColorShift"
        rendererDebugGroupName = "Encode AudioPixelShader"
    }
    
    override func configure(view: MetalView) {
        super.configure(view)
        setupColorShiftBuffer()
    }
    
    func setupColorShiftBuffer() {
        colorShiftBuffer = device!.newBufferWithLength(sizeof(Float), options: .CPUCacheModeDefaultCache)
        colorShiftPtr = colorShiftBuffer.contents()
    }
    
    func setColorShiftBuffer(val: Float) {
        memcpy(colorShiftPtr!, &colorShift, sizeof(Float))
    }
    
    override func encodeFragmentBuffers(renderEncoder: MTLRenderCommandEncoder) {
        super.encodeFragmentBuffers(renderEncoder)
        renderEncoder.setFragmentBuffer(colorShiftBuffer, offset: 0, atIndex: 0)
    }
    
}


