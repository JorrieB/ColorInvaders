//
//  SprintCircle.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class SprintCircle: Enemy {
  
  weak var outerLayer: CCSprite!
  
  override func didLoadFromCCB() {
    super.didLoadFromCCB()
    score = 2
    speed = 2
    scale = 0.5
    
    layerArray.append(outerLayer)
  }
  
  override func positionSelf() {
    position = ccp(CGFloat(CGFloat(arc4random_uniform(UInt32(screenSize.width - outerLayer.contentSizeInPoints.width * CGFloat(scale)))) + outerLayer.contentSizeInPoints.width / 2 * CGFloat(scale)), screenSize.height + outerLayer.contentSizeInPoints.height * CGFloat(scale))
  }
  
  override func setColors(forPart:Int){
    var colorsToChooseFrom = [CCColor.paletteBlue(),CCColor.paletteRed(),CCColor.paletteYellow()]
    if forPart == 1 {
      var whichColor = Int(arc4random_uniform(3))
      outerLayer.color = colorsToChooseFrom[whichColor]
    } else if forPart == 2{
      colorsToChooseFrom.append(CCColor.palettePurple())
      var whichColor = Int(arc4random_uniform(4))
      outerLayer.color = colorsToChooseFrom[whichColor]
    } else {
      colorsToChooseFrom.append(CCColor.paletteOrange())
      colorsToChooseFrom.append(CCColor.paletteGreen())
      var whichColor = Int(arc4random_uniform(6))
      outerLayer.color = colorsToChooseFrom[whichColor]
    }
  }
  
}