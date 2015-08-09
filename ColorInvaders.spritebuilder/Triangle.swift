//
//  Triangle.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Triangle: Enemy {
  
  weak var outerTriangle: CCSprite!
  weak var leftPiece: CCSprite!
  weak var rightPiece: CCSprite!
  
  override func didLoadFromCCB() {
    super.didLoadFromCCB()
    speed = 1
    score = 5
    scale = 0.8
    
  }
  
  override func setColors(forPart: Int) {
    var colorsToChooseFrom = [CCColor.paletteBlue(),CCColor.paletteRed(),CCColor.paletteYellow()]
    if forPart == 2{
      colorsToChooseFrom.append(CCColor.palettePurple())
    } else if forPart == 3 {
      colorsToChooseFrom.append(CCColor.palettePurple())
      colorsToChooseFrom.append(CCColor.paletteOrange())
      colorsToChooseFrom.append(CCColor.paletteGreen())
    }
    
    var timesThrough = 0
    while timesThrough < 3{
      layerArray.append(colorsToChooseFrom.removeAtIndex(Int(arc4random_uniform(UInt32(colorsToChooseFrom.count)))))
      timesThrough++
    }

    outerTriangle.color = layerArray[3]
    rightPiece.color = layerArray[2]
    leftPiece.color = layerArray[1]
  }
  
  override func nextColor() {
    var scaleDuration = Double(arc4random_uniform(10)) * 0.01 + 0.05
    
    if layerArray.count == 3{
      rightPiece.runAction(CCActionScaleTo(duration: scaleDuration, scale: 0))
      outerTriangle.scale = 0.5
      outerTriangle.color = rightPiece.color
      outerTriangle.runAction(CCActionScaleTo(duration: scaleDuration, scale: 1))
    } else if layerArray.count == 2{
      leftPiece.runAction(CCActionScaleTo(duration: scaleDuration, scale: 0))
      outerTriangle.scale = 0.5
      outerTriangle.color = leftPiece.color
      outerTriangle.runAction(CCActionScaleTo(duration: scaleDuration, scale: 1))
    } else if layerArray.count == 1 {
      outerTriangle.runAction(CCActionFadeOut(duration: 0.05))
    }
  
  }
}