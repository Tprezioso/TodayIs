//
//  ComplicationController.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/10/21.
//

import ClockKit
import SwiftUI


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "TodayIs", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }
    
    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        if let template = getComplicationTemplate(for: complication, using: Date()) {
                    let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    handler(entry)
                } else {
                    handler(nil)
                }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }
    
    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {

            switch complication.family {
            case .graphicCorner:
                return CLKComplicationTemplateGraphicCornerCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!))
            case .graphicCircular:
                return CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Circular")!))
            case .circularSmall:
                return CLKComplicationTemplateCircularSmallSimpleText(textProvider: CLKTextProvider(format: "TI"))
            case .utilitarianSmall:
                return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKTextProvider(format: "Today Is...."))
            case .modularSmall:
                return CLKComplicationTemplateModularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "Complication/Modular")!))
            default:
                return nil
            }
        }
}

//if complication.family == .circularSmall {
//            let template = CLKComplicationTemplateCircularSmallRingImage()
//            guard let image = UIImage(named: "Complication/Circular") else { handler(nil); return}
//            template.imageProvider = CLKImageProvider(onePieceImage: image)
//            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//            handler(timelineEntry)
//
//        } else if complication.family == .utilitarianSmall {
//            let template = CLKComplicationTemplateUtilitarianSmallRingImage()
//            guard let image = UIImage(named: "Complication/Utilitarian") else { handler(nil); return}
//            template.imageProvider = CLKImageProvider(onePieceImage: image)
//            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//            handler(timelineEntry)
//
//        } else if complication.family == .modularSmall {
//            let template = CLKComplicationTemplateModularSmallRingImage()
//            guard let image = UIImage(named: "Complication/Modular") else { handler(nil); return}
//            template.imageProvider = CLKImageProvider(onePieceImage: image)
//            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//            handler(timelineEntry)
//
//        } else if complication.family == .graphicCircular {
//            let template = CLKComplicationTemplateGraphicCircularImage()
//            guard let image = UIImage(named: "Complication/GraphicCircular") else { handler(nil); return}
//            template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
//            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//            handler(timelineEntry)
//
//        } else if complication.family == .graphicCorner {
//            let template = CLKComplicationTemplateGraphicCornerCircularImage()
//            guard let image = UIImage(named: "GraphicCorner") else { handler(nil); return}
//            template.imageProvider = CLKFullColorImageProvider(fullColorImage: image)
//            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//            handler(timelineEntry)
//
//        } else {
//            handler(nil)
//        }
