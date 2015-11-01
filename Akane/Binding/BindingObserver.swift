//
// This file is part of Akane
//
// Created by JC on 20/10/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

public protocol BindingObserver {
    typealias Element

    func bindTo<T: Bindable where T.Element == Element>(bindable: T) -> Self

    func combine<T: Observable>(observables: T...) -> Self

    func convert<T: Converter, BO: BindingObserver where T.ValueType == Element, T.ConvertValueType == BO.Element>(converter: T.Type) -> BO
    func convert<T: protocol<Converter, ConverterOption>, BO: BindingObserver where T.ValueType == Element, T.ConvertValueType == BO.Element>(converter: T.Type, options:() -> T.ConvertOptionType) -> BO

    func convertBack<T: ConverterReverse, BO: BindingObserver where T.ConvertValueType == Element, T.ValueType == BO.Element>(converter: T.Type) -> BO
    func convertBack<T: protocol<ConverterReverse, ConverterOption>, BO: BindingObserver where T.ConvertValueType == Element, T.ValueType == BO.Element>(converter: T.Type, options:() -> T.ConvertOptionType) -> BO
}