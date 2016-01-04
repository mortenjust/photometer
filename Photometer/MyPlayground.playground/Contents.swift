//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var isPhoto = false


var speed : Int?
let direction = 0


let speedString = speed == 0 ? "first" : "second"


speed == nil ? false : true

func getHSBA(color:UIColor) -> (hue:CGFloat, saturation:CGFloat, brightness:CGFloat, alpha:CGFloat) {
    var hue:CGFloat = 0.0
    var sat:CGFloat = 0.0
    var bri:CGFloat = 0.0
    var alpha:CGFloat = 0.0
    color.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)
    return (hue:hue, saturation:sat, brightness:bri, alpha:alpha)
}

getHSBA(UIColor.blueColor())