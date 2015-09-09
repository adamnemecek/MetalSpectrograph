
//
//  ParticleController.swift
//  MetalSpectrograph
//
//  Created by David Conner on 9/9/15.
//  Copyright © 2015 Voxxel. All rights reserved.
//

import Foundation
import Cocoa
import MetalKit

class ParticleController: NSViewController, ParticleLabDelegate {

    var gravityWellAngle: Float = 0
    var particleLab: ParticleLabView!
    let floatPi = Float(M_PI)

    override func viewDidLoad() {
        super.viewDidLoad()

        particleLab = ParticleLabView(size: CGSize(width: 1024, height: 768), numParticles: ParticleLabCount.FourMillion)

        particleLab.dragFactor = 0.85
        particleLab.respawnOutOfBoundsParticles = true
        particleLab.particleLabDelegate = self

        view.addSubview(particleLab)
    }

    override var representedObject: AnyObject? {
        didSet {
            //Update the view, if already loaded
        }
    }

    // ParticleLabDelegate

    func particleLabMetalUnavailable()
    {
        // handle metal unavailable here
    }

    func particleLabStatisticsDidUpdate(fps fps: Int, description: String)
    {
        //        dispatch_async(dispatch_get_main_queue())
        //            {
        //                self.fpsLabel.string = description
        //        }
    }

    func particleLabDidUpdate()
    {
        /*
        dispatch_async(dispatch_get_main_queue())
        {
        self.fpsLabel.string = self.particleLab.status
        }
        */
        cloudChamberStep()
    }

    func cloudChamberStep()
    {
        gravityWellAngle = gravityWellAngle + 0.02

        particleLab.setGravityWellProperties(gravityWell: .One,
            normalisedPositionX: 0.5 + 0.1 * sin(gravityWellAngle + floatPi * 0.5),
            normalisedPositionY: 0.5 + 0.1 * cos(gravityWellAngle + floatPi * 0.5),
            mass: 11 * sin(gravityWellAngle / 1.9),
            spin: 23 * cos(gravityWellAngle / 2.1))

        particleLab.setGravityWellProperties(gravityWell: .Four,
            normalisedPositionX: 0.5 + 0.1 * sin(gravityWellAngle + floatPi * 1.5),
            normalisedPositionY: 0.5 + 0.1 * cos(gravityWellAngle + floatPi * 1.5),
            mass: 11 * sin(gravityWellAngle / 1.9),
            spin: 23 * cos(gravityWellAngle / 2.1))

        particleLab.setGravityWellProperties(gravityWell: .Two,
            normalisedPositionX: 0.5 + (0.35 + sin(gravityWellAngle * 2.7)) * cos(gravityWellAngle / 1.3),
            normalisedPositionY: 0.5 + (0.35 + sin(gravityWellAngle * 2.7)) * sin(gravityWellAngle / 1.3),
            mass: 26 * cos(gravityWellAngle / 1.5),
            spin: -19 * sin(gravityWellAngle * 1.5))

        particleLab.setGravityWellProperties(gravityWell: .Three,
            normalisedPositionX: 0.5 + (0.35 + sin(gravityWellAngle * 2.7)) * cos(gravityWellAngle / 1.3 + floatPi),
            normalisedPositionY: 0.5 + (0.35 + sin(gravityWellAngle * 2.7)) * sin(gravityWellAngle / 1.3 + floatPi),
            mass: 26 * cos(gravityWellAngle / 1.5),
            spin: -19 * sin(gravityWellAngle * 1.5))
    }
}
