//
//  SearchView.swift
//  Cookable
//
//  Created by Kody Deda on 3/29/21.
//

import SwiftUI
import ComposableArchitecture

struct SearchTabView: View {
    let store: Store<Root.State, Root.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    if viewStore.showingSearchResults {
                        SearchResultsView(store: store)
                    } else {
                        EmptySearchResultsView(emptyIngredientsList: viewStore.ingredientsList.isEmpty) {
                            viewStore.send(.toggleSheet)
                        }
                    }
                }
                .navigationBarTitle("Search Results")
                .toolbar {
                    ToolbarItem {
                        Button("Ingredients") {
                            viewStore.send(.toggleSheet)
                        }
                    }
                }
                .sheet(isPresented: viewStore.binding(keyPath: \.sheet, send: Root.Action.keyPath)) {
                    SearchSheetView(store: store)
                }
            }
        }
    }
}
       
struct SearchView_Previews: PreviewProvider {
    static let allRecipesAllIngredientsStore = Store(
        initialState: Root.State(searchResults: Recipe.allRecipes, ingredientsList: Recipe.Ingredient.allCases),
        reducer:      Root.reducer,
        environment:  Root.Environment()
    )
    static let mockStore2 = Store(
        initialState: Root.State(ingredientsList: Recipe.Ingredient.allCases),
        reducer:      Root.reducer,
        environment:  Root.Environment()
    )
    static var previews: some View {
        SearchTabView(store: allRecipesAllIngredientsStore)
        SearchTabView(store: Root.defaultStore)
        SearchTabView(store: mockStore2)
    }
}