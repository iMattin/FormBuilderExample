//
//  OfflineDataProvider.swift
//  TAP30-Game
//
//  Created by Matin on 2/8/23.
//

import Foundation

struct OfflineDataProvider: StickyFormPageWidgetProvider {

    let mapper: WidgetToFormFieldMapper
    let widgets: [Widget]
    let filledData: KeyValuePairs?

    func provide(_ onLoad: @escaping ([FormField]) -> Void) -> StickyFormPageStatus {
        let fields = mapper.map(widgets: widgets)

        if let filledData {
            let inputItems = fields.map { $0.type.inputItem }.compactMap { $0 as? SettableRow }
            for item in inputItems {
                guard let data = filledData[item.key] else { continue }
                item.setValue(data)
            }
        }

        onLoad(fields)

        return .none
    }
}
