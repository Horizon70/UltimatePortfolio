//
//  ContentViewModel.swift
//  UltimatePortfolio
//
//  Created by Davide Fabretti on 23/07/24.
//

import Foundation

extension ContentView {
    class ViewModel: ObservableObject {
        var dataController: DataController
        
        var shouldRequestReview: Bool {
            dataController.count(for: Tag.fetchRequest()) >= 5
        }
        
        init(dataController: DataController) {
            self.dataController = dataController
        }
        
        func delete(_ offsets: IndexSet) {
            let issues = dataController.issuesForSelectedFilter()
            
            for offset in offsets {
                let item = issues[offset]
                dataController.delete(item)
            }
        }
    }
}
