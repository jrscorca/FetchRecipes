//
//  ImageRepository.swift
//  FetchRecipes
//
//  Created by Joshua Scorca on 2/10/25.
//

import SwiftUI

protocol ImageRepository: Sendable{
    func get(from url: URL) async throws -> UIImage?
    func cancelFetch(for url: URL) async
}
