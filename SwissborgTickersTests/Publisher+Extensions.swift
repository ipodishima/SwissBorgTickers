//
//  Publisher+Extensions.swift
//  SwissborgTickersTests
//
//  Created by Marian Paul on 2022-04-19.
//

import Combine

extension Published.Publisher {
    func collectNext(_ count: Int) -> AnyPublisher<[Output], Never> {
        collect(count)
            .first()
            .eraseToAnyPublisher()
    }
}
