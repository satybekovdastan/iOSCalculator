//
//  LoanView.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import SwiftUI

struct LoanView: View {
    
    @StateObject private var store: LoanStore
    
    nonisolated init(store: LoanStore) {
        _store = StateObject(wrappedValue: store)
    }
    
    private var preferredScheme: ColorScheme? {
        switch store.state.theme {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
    
    var body: some View {
        ZStack {
            content
            
            if store.state.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
            }
        }
        .alert("loan.success_title",
               isPresented: Binding(
                get: { store.state.result != nil },
                set: { newValue in
                    if !newValue {
                        store.send(.setResult(nil))
                    }
                })
        ) {
            Button("OK") {
                store.send(.setResult(nil))
            }
        } message: {
            Text("loan.success_message")
        }
        // error alert
        .alert("loan.error_title",
               isPresented: Binding(
                get: { store.state.errorMessage != nil },
                set: { newValue in
                    if !newValue {
                        store.send(.setErrorMessage(nil))
                    }
                })
        ) {
            Button("OK") {
                store.send(.setErrorMessage(nil))
            }
        } message: {
            Text(store.state.errorMessage ?? "")
        }
        .preferredColorScheme(preferredScheme)
        .onAppear {
            store.loadPreferences()
        }
    }
    
    // MARK: - Content View
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 32) {
            
            themePicker
            
            amountSection
            
            termSection
            
            loanDetailsSection
            
            Spacer(minLength: 40)
            
            applyButton
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Theme Picker
    
    private var themePicker: some View {
        Picker("Theme", selection: Binding(
            get: { store.state.theme },
            set: { store.send(.setTheme($0)) }
        )) {
            Text("System").tag(LoanTheme.system)
            Text("Light").tag(LoanTheme.light)
            Text("Dark").tag(LoanTheme.dark)
        }
        .pickerStyle(.segmented)
    }
    
    // MARK: - Amount Section
    
    private var amountSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("loan.how_much")
                    .font(.headline)
                Spacer()
                Text("$\(store.formattedAmount)")
                    .font(.title3).bold()
            }
            
            Slider(
                value: Binding(
                    get: { store.state.amount },
                    set: { store.send(.setAmount($0)) }
                ),
                in: store.state.amountRange
            )
            .accentColor(.green)
            .tint(.green)
            
            HStack {
                Text("$5,000")
                Spacer()
                Text("$50,000")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Term Section
    private var termSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("loan.how_long")
                    .font(.headline)
                Spacer()
                Text("\(store.state.terms[store.state.termIndex]) days")
                    .font(.title3).bold()
            }
            
            Slider(
                value: Binding(
                    get: { Double(store.state.termIndex) },
                    set: {
                        let newIndex = Int($0)
                        store.send(.setTermIndex(newIndex))
                    }
                ),
                in: 0...Double(store.state.terms.count - 1),
                step: 1
            )
            .accentColor(.orange)
            .tint(.orange)
            
            HStack {
                Text("7")
                Spacer()
                Text("28")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }
    
    
    // MARK: - Loan Details Section
    
    private var loanDetailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("loan.interest_rate")
                Spacer()
                Text(store.interestRateText)
                    .bold()
            }
            
            HStack {
                Text("loan.total_to_repay")
                Spacer()
                Text("$\(store.totalRepaymentText)")
                    .bold()
            }
            
            HStack {
                Text("loan.due_date")
                Spacer()
                Text(store.dueDateText)
                    .bold()
            }
        }
        .font(.subheadline)
    }
    
    // MARK: - Apply Button
    
    private var applyButton: some View {
        Button {
            store.send(.apply)
        } label: {
            Text("loan.apply_now")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(14)
        }
        .foregroundColor(.white)
    }
}

#Preview {
    //    LoanView()
}
