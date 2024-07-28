//
//  DetailView.swift
//  UltimatePortfolio
//
//  Created by Davide Fabretti on 07/07/24.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        VStack {
            if let issue = dataController.selectedIssue {
                IssueView(issue: issue)
            } else {
                NoIssueView()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DetailView()
}
