//
//  CalculatorView.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import SwiftUI

struct LoanCalculatorView: View {
    
    @StateObject private var store: LoanCalculatorStore
    
    init(store: LoanCalculatorStore) {
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
            
            GradientSlider(
                value: Binding(
                    get: { store.state.amount },
                    set: { store.send(.setAmount($0)) }
                ),
                range: store.state.amountRange,
                gradient: Gradient(colors: [Color.green, Color.yellow])
            )
            .frame(height: 32)
            
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
            
            DiscreteSlider(
                index: Binding(
                    get: { store.state.termIndex },
                    set: { store.send(.setTermIndex($0)) }
                ),
                values: store.state.terms,
                gradient: Gradient(colors: [Color.orange, Color.yellow])
            )
            .frame(height: 32)
            
            HStack {
                Text("\(store.state.terms.first ?? 7)")
                Spacer()
                Text("\(store.state.terms.last ?? 28)")
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
        Button("loan.apply_now") {
            store.send(.apply)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.accentColor)
        .foregroundColor(.white)
        .cornerRadius(14)
    }
}

#Preview {
    //    LoanCalculatorView()
}
