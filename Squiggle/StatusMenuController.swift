//
//  StatusMenuController.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 10/12/15.
//  Copyright © 2015 Efrem Agnilleri. All rights reserved.
//

import Cocoa
import AppKit
import Foundation

class StatusMenuController: NSObject {
    
    var lastTimestamp = 0.0
    var gestureManager : GestureManager
    
    override init() {
        
        //test
        let gestureTest1 = Gesture()
        gestureTest1.xPoints = serieX1
        gestureTest1.yPoints = serieY1
        
        let gestureTest2 = Gesture()
        gestureTest2.xPoints = serieX2
        gestureTest2.yPoints = serieY2
        
        let gestureTest3 = Gesture()
        gestureTest3.xPoints = serieX3
        gestureTest3.yPoints = serieY3
        
        var gestureArrayTest = [Gesture]()
        gestureArrayTest.append(gestureTest1)
        gestureArrayTest.append(gestureTest2)
        gestureArrayTest.append(gestureTest3)
        
        gestureManager = GestureManager(referenceGestures: gestureArrayTest)
        
        super.init()
        
        acquirePrivileges()
        
        NSEvent.addGlobalMonitorForEventsMatchingMask(
            NSEventMask.ScrollWheelMask, handler: {(event: NSEvent) in
                self.gestureManager.scroll(event)
        })
        
        NSEvent.addLocalMonitorForEventsMatchingMask(
            NSEventMask.ScrollWheelMask, handler: {(event: NSEvent) in
                self.gestureManager.scrollLocal(event)
        })
        
        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.lockedEvent), name: "com.apple.screenIsLocked", object: nil)
        
        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.unlockedEvent), name: "com.apple.screenIsUnlocked", object: nil)
    }
    
    func acquirePrivileges() -> Bool {
        let accessEnabled = AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true])
        
        if accessEnabled != true {
            print("You need to enable the keylogger in the System Prefrences")
        }
        return accessEnabled == true
    }
    
    func lockedEvent() {
        gestureManager.isScreenLocked(true)
    }
    
    func unlockedEvent() {
        gestureManager.isScreenLocked(false)
    }
    
    var serieX1 : [CGFloat] = [0.300018310546875, 0.700042724609375, 1.2000732421875, 1.80010986328125, 2.400146484375, 3.10018920898438, 3.90023803710938, 5.10031127929688, 6.20037841796875, 7.40045166015625, 8.10049438476562, 9.2005615234375, 10.5006408691406, 11.7007141113281, 13.1007995605469, 14.3008728027344, 15.1009216308594, 16.2009887695312, 17.7010803222656, 19.201171875, 20.001220703125, 21.2012939453125, 22.7013854980469, 23.9014587402344, 25.5015563964844, 26.9016418457031, 28.4017333984375, 29.601806640625, 31.3019104003906, 32.9020080566406, 33.9020690917969, 36.002197265625, 37.2022705078125, 38.6023559570312, 39.7024230957031, 41.7025451660156, 42.9026184082031, 44.2026977539062, 45.602783203125, 47.202880859375, 48.1029357910156, 49.60302734375, 50.9031066894531, 52.1031799316406, 53.1032409667969, 54.2033081054688, 55.3033752441406, 56.4034423828125, 57.7035217285156, 58.8035888671875, 60.003662109375, 60.7037048339844, 61.8037719726562, 62.8038330078125, 63.8038940429688, 64.803955078125, 65.60400390625, 66.2040405273438, 66.9040832519531, 67.6041259765625, 68.6041870117188, 69.3042297363281, 69.9042663574219, 70.6043090820312, 71.1043395996094, 71.9043884277344, 71.9043884277344, 72.804443359375, 73.3044738769531, 73.3044738769531, 73.3044738769531, 73.3044738769531, 74.7045593261719, 74.7045593261719, 74.7045593261719]
    
    var serieY1 : [CGFloat] = [0.0, 0.0, 0.0, -0.900054931640625, -0.900054931640625, -0.900054931640625, -1.90011596679688, -2.60015869140625, -3.2001953125, -3.90023803710938, -3.90023803710938, -5.00030517578125, -5.70034790039062, -6.400390625, -7.200439453125, -7.90048217773438, -7.90048217773438, -8.90054321289062, -9.70059204101562, -10.5006408691406, -10.5006408691406, -11.6007080078125, -12.3007507324219, -12.9007873535156, -13.7008361816406, -14.3008728027344, -14.9009094238281, -15.4009399414062, -16.1009826660156, -16.7010192871094, -16.7010192871094, -17.9010925292969, -18.401123046875, -18.9011535644531, -19.4011840820312, -20.2012329101562, -20.2012329101562, -21.2012939453125, -21.7013244628906, -22.5013732910156, -23.0014038085938, -23.7014465332031, -24.4014892578125, -25.1015319824219, -25.7015686035156, -26.401611328125, -27.1016540527344, -27.7016906738281, -28.5017395019531, -29.1017761230469, -29.9018249511719, -30.40185546875, -31.0018920898438, -31.6019287109375, -32.1019592285156, -32.6019897460938, -32.6019897460938, -32.6019897460938, -32.6019897460938, -32.6019897460938, -34.2020874023438, -34.2020874023438, -34.2020874023438, -34.2020874023438, -34.2020874023438, -35.6021728515625, -35.6021728515625, -35.6021728515625, -35.6021728515625, -35.6021728515625, -36.9022521972656, -36.9022521972656, -36.9022521972656, -36.9022521972656, -36.9022521972656]
    
    var serieX2 : [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.10006713867188, -1.10006713867188, -1.80010986328125, -2.20013427734375, -2.60015869140625, -3.10018920898438, -3.6002197265625, -4.20025634765625, -4.80029296875, -5.600341796875, -6.30038452148438, -7.200439453125, -7.80047607421875, -8.70053100585938, -9.70059204101562, -10.8006591796875, -12.000732421875, -13.4008178710938, -14.5008850097656, -15.8009643554688, -17.2010498046875, -18.7011413574219, -20.3012390136719, -22.0013427734375, -23.7014465332031, -25.8015747070312, -27.3016662597656, -29.2017822265625, -31.3019104003906, -32.802001953125, -35.0021362304688, -36.5022277832031, -39.8024291992188, -40.9024963378906, -43.1026306152344, -44.6027221679688, -46.3028259277344, -47.9029235839844, -49.4030151367188, -51.4031372070312, -52.2031860351562, -53.4032592773438, -54.5033264160156, -55.9034118652344, -55.9034118652344, -55.9034118652344, -57.4035034179688, -57.4035034179688, -57.4035034179688, -57.4035034179688, -57.4035034179688, -57.4035034179688, -57.4035034179688, -57.4035034179688, -57.4035034179688, -57.4035034179688, -57.4035034179688, -56.6034545898438, -56.00341796875, -55.6033935546875, -54.9033508300781, -54.0032958984375, -53.0032348632812, -51.8031616210938, -50.0030517578125, -48.9029846191406, -47.3028869628906, -45.4027709960938, -43.5026550292969, -41.4025268554688, -39.3023986816406, -37.1022644042969, -34.8021240234375, -32.3019714355469, -30.40185546875, -28.001708984375, -25.6015625, -23.6014404296875, -21.4013061523438, -19.201171875, -17.2010498046875, -15.200927734375, -13.3008117675781, -11.20068359375, -9.90060424804688, -8.4005126953125, -7.10043334960938, -5.40032958984375, -4.000244140625, -2.90017700195312, -1.90011596679688, -1.00006103515625, -0.100006103515625, 0.800048828125, 1.50009155273438, 2.20013427734375, 2.20013427734375, 3.10018920898438, 3.80023193359375, 3.80023193359375, 3.80023193359375, 3.80023193359375, 3.80023193359375, 5.2003173828125, 5.2003173828125]
    
    var serieY2 : [CGFloat] = [0.0, -0.60003662109375, -1.00006103515625, -1.50009155273438, -1.90011596679688, -2.30014038085938, -2.8001708984375, -3.30020141601562, -4.000244140625, -4.60028076171875, -5.30032348632812, -5.90036010742188, -6.60040283203125, -7.30044555664062, -8.00048828125, -8.800537109375, -9.50057983398438, -10.5006408691406, -10.5006408691406, -11.6007080078125, -12.2007446289062, -12.7007751464844, -13.2008056640625, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -13.7008361816406, -12.6007690429688, -12.2007446289062, -11.4006958007812, -10.8006591796875, -10.0006103515625, -8.90054321289062, -7.80047607421875, -5.90036010742188, -4.90029907226562, -3.50021362304688, -1.90011596679688, 0.60003662109375, 1.80010986328125, 2.90017700195312, 5.00030517578125, 6.400390625, 8.20050048828125, 10.9006652832031, 12.1007385253906, 14.0008544921875, 16.3009948730469, 18.9011535644531, 20.7012634277344, 23.3014221191406, 25.5015563964844, 27.6016845703125, 30.7018737792969, 32.1019592285156, 34.1020812988281, 35.9021911621094, 37.7023010253906, 39.3023986816406, 41.4025268554688, 42.3025817871094, 43.4026489257812, 44.5027160644531, 45.4027709960938, 46.1028137207031, 46.8028564453125, 47.3028869628906, 47.3028869628906, 47.3028869628906, 47.3028869628906, 47.3028869628906, 48.5029602050781, 48.5029602050781, 48.5029602050781, 48.5029602050781, 48.5029602050781, 48.5029602050781, 48.5029602050781, 48.5029602050781, 48.5029602050781, 47.7029113769531, 47.3028869628906, 46.8028564453125, 46.0028076171875, 45.2027587890625, 44.2026977539062, 43.0026245117188, 41.7025451660156, 40.00244140625, 38.3023376464844, 36.3022155761719, 35.1021423339844, 33.3020324707031, 30.8018798828125, 29.8018188476562, 28.7017517089844, 27.4016723632812, 26.3016052246094, 25.4015502929688, 24.4014892578125]

    var serieX3 : [CGFloat] = [-0.4000244140625, -0.800048828125, -1.40008544921875, -2.0001220703125, -2.60015869140625, -3.50021362304688, -5.00030517578125, -6.60040283203125, -8.4005126953125, -10.3006286621094, -12.3007507324219, -14.5008850097656, -16.7010192871094, -19.201171875, -21.601318359375, -24.00146484375, -26.401611328125, -29.0017700195312, -31.6019287109375, -34.3020935058594, -37.1022644042969, -39.8024291992188, -42.6026000976562, -45.602783203125, -48.5029602050781, -50.9031066894531, -53.1032409667969, -56.9034729003906, -58.7035827636719, -62.5038146972656, -64.3039245605469, -65.8040161132812, -68.1041564941406, -71.5043640136719, -72.9044494628906, -74.8045654296875, -76.7046813964844, -78.3047790527344, -79.7048645019531, -81.7049865722656, -83.0050659179688, -84.1051330566406, -85.1051940917969, -85.8052368164062, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -86.4052734375, -85.3052062988281, -85.3052062988281, -85.3052062988281, -84.2051391601562, -83.6051025390625, -82.1050109863281, -81.5049743652344, -80.5049133300781, -79.4048461914062, -78.1047668457031, -76.8046875, -75.1045837402344, -73.5044860839844, -71.9043884277344, -70.2042846679688, -67.6041259765625, -66.3040466308594, -63.4038696289062, -62.0037841796875, -58.7035827636719, -56.1034240722656, -53.3032531738281, -50.403076171875, -47.8029174804688, -45.1027526855469, -42.3025817871094, -39.6024169921875, -37.0022583007812, -34.2020874023438, -32.6019897460938, -29.8018188476562, -27.9017028808594, -25.2015380859375, -23.4014282226562, -21.5013122558594, -20.001220703125, -18.8011474609375, -17.5010681152344, -16.2009887695312, -15.6009521484375, -14.8009033203125, -14.8009033203125, -13.9008483886719, -13.9008483886719, -13.9008483886719, -13.9008483886719, -13.9008483886719, -13.9008483886719, -13.9008483886719, -13.9008483886719, -13.9008483886719]
    
    var serieY3 : [CGFloat] = [0.0, 0.60003662109375, 1.10006713867188, 1.60009765625, 2.10012817382812, 2.90017700195312, 4.10025024414062, 5.50033569335938, 6.90042114257812, 8.60052490234375, 10.400634765625, 12.2007446289062, 14.1008605957031, 16.0009765625, 17.8010864257812, 19.7012023925781, 21.7013244628906, 23.6014404296875, 25.6015625, 27.5016784667969, 29.4017944335938, 31.3019104003906, 33.2020263671875, 35.0021362304688, 36.7022399902344, 38.0023193359375, 39.1023864746094, 40.9024963378906, 41.6025390625, 43.1026306152344, 43.1026306152344, 43.1026306152344, 43.1026306152344, 44.6027221679688, 44.6027221679688, 44.6027221679688, 44.6027221679688, 44.6027221679688, 44.6027221679688, 44.002685546875, 43.3026428222656, 42.5025939941406, 41.5025329589844, 40.2024536132812, 38.7023620605469, 37.0022583007812, 34.7021179199219, 32.7019958496094, 30.2018432617188, 27.6016845703125, 24.9015197753906, 22.8013916015625, 20.3012390136719, 17.60107421875, 15.9009704589844, 13.9008483886719, 12.2007446289062, 10.7006530761719, 9.00054931640625, 9.00054931640625, 9.00054931640625, 7.40045166015625, 7.40045166015625, 6.50039672851562, 6.50039672851562, 6.50039672851562, 6.50039672851562, 6.50039672851562, 6.50039672851562, 7.10043334960938, 7.50045776367188, 8.00048828125, 8.60052490234375, 9.50057983398438, 10.0006103515625, 11.3006896972656, 12.000732421875, 13.5008239746094, 14.7008972167969, 15.9009704589844, 17.2010498046875, 18.7011413574219, 20.3012390136719, 22.0013427734375, 23.7014465332031, 25.5015563964844, 27.3016662597656, 28.4017333984375, 30.40185546875, 31.6019287109375, 33.3020324707031, 34.402099609375, 35.6021728515625, 36.5022277832031, 37.3022766113281, 38.2023315429688, 39.0023803710938, 39.0023803710938, 40.00244140625, 40.00244140625, 40.00244140625, 40.00244140625, 40.00244140625, 41.3025207519531, 41.3025207519531, 41.3025207519531, 41.3025207519531, 41.3025207519531, 41.3025207519531]

    
}
