//
//  BondBindingObserver.swift
//  Akane
//
//  Created by JC on 01/11/15.
//  Copyright © 2015 fr.akane. All rights reserved.
//

import Foundation
import Bond

public class BondBindingWrapper<E> {
    typealias Element = E

    private let event: EventProducer<E>
    private let disposeBag: DisposableBag

    private convenience init<T:Observable where T.Element == E>(observable:T, disposeBag: DisposableBag) {
        let internalObservable = Bond.Observable<E>(observable.value)
        let disposable = observable.observe { [weak internalObservable] value in
            internalObservable?.next(value)
        }

        disposeBag.addDisposable(disposable)

        self.init(event: internalObservable, disposeBag: disposeBag)
    }

    private init(event: EventProducer<E>, disposeBag: DisposableBag) {
        self.event = event
        self.disposeBag = disposeBag
    }

    func bindTo<T: Bindable where T.Element == Element>(bindable: T) {
        let next = bindable.advance()
        let disposable = self.event.observe { value in
            next(value)
        }

        self.disposeBag.addDisposable(BondDisposableAdapter(disposable))
    }

    func combine<T: Observable>(observables: T...) -> Self {
        return self
    }

    func convert<T: Converter where T.ValueType == Element>(converter: T.Type) -> BondBindingWrapper<T.ConvertValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init().convert(value)
        }

        return BondBindingWrapper<T.ConvertValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }

    func convert<T: protocol<Converter, ConverterOption> where T.ValueType == Element>(converter: T.Type, options:() -> T.ConvertOptionType) -> BondBindingWrapper<T.ConvertValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init(options: options()).convert(value)
        }

        return BondBindingWrapper<T.ConvertValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }

    func convertBack<T: ConverterReverse where T.ConvertValueType == Element>(converter: T.Type) -> BondBindingWrapper<T.ValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init().convertBack(value)
        }

        return BondBindingWrapper<T.ValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }

    func convertBack<T: protocol<ConverterReverse, ConverterOption> where T.ConvertValueType == Element>(converter: T.Type, options:() -> T.ConvertOptionType) -> BondBindingWrapper<T.ValueType> {
        let nextEvent = self.event.map { (value:Element) in
            return converter.init(options: options()).convertBack(value)
        }

        return BondBindingWrapper<T.ValueType>(event: nextEvent, disposeBag: self.disposeBag)
    }
}