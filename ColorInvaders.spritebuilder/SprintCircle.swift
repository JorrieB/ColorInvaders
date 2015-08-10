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
    
  }
  
  override func setColors(forPart:Int){
    var colorsToChooseFrom = [CCColor.paletteBlue(),CCColor.paletteRed(),CCColor.paletteYellow()]
    if forPart == 2{
      colorsToChooseFrom.append(CCColor.palettePurple())
    } else if forPart == 3 {
      colorsToChooseFrom.append(CCColor.palettePurple())
      colorsToChooseFrom.append(CCColor.paletteOrange())
      colorsToChooseFrom.append(CCColor.paletteGreen())
    }
    
    var whichColor = Int(arc4random_uniform(UInt32(colorsToChooseFrom.count)))
    outerLayer.color = colorsToChooseFrom[whichColor]
    
    layerArray.append(outerLayer.color)
  }
  
  func makePurple(){
    outerLayer.color = CCColor.palettePurple()
    layerArray.append(CCColor.palettePurple())
  }
  
  func makeGreen(){
    outerLayer.color = CCColor.paletteGreen()
    layerArray.append(CCColor.paletteGreen())
  }
  
  func makeOrange(){
    outerLayer.color = CCColor.paletteOrange()
    layerArray.append(CCColor.paletteOrange())
  }
  
  override func nextColor() {
    if layerArray.count == 1 {
      outerLayer.runAction(CCActionFadeOut(duration: 0.03))
    }
  }
  
}