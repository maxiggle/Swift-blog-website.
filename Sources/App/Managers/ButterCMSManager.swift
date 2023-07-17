//
//  ButterCMSManager.swift
//  ButterCMSSample
//
//  Created by Martin Srb on 17.09.2021.
//

import ButterCMSSDK
import Combine
import NIO

class ButterCMSManager {
    static var shared = ButterCMSManager()
    let butter = ButterCMSClient(apiKey: "643774ad451526d62c9ca0f9cdacdeaff558a6ee")
    let blogPagesSubject = PassthroughSubject<PagesResponse<BlogPageFields>, Error>()

     
    func getPages(eventLoop: EventLoop) -> EventLoopFuture<[Page<BlogPageFields>]> {
        let promise = eventLoop.makePromise(of: [Page<BlogPageFields>].self)

        butter.getPages(pageTypeSlug: "blog", type: BlogPageFields.self) { result in
            switch result {
            case let .success(pages):
                promise.succeed(pages.data)

            case let .failure(error):
                promise.fail(error)
                print(error)
            }
        }

        return promise.futureResult
    }
    
    func getLandingPage(eventLoop: EventLoop) ->EventLoopFuture<[Page<LandingPageFields>]> {
        let promise = eventLoop.makePromise(of: [Page<LandingPageFields>].self)
        butter.getPages(pageTypeSlug: "blog_landing_page", type: LandingPageFields.self) { result in
            switch result {
            case let .success(page):
//                print(page)
                promise.succeed(page.data)


            case let .failure(error):
                promise.fail(error)
                print(error)
            }
        }
        return promise.futureResult
    }

//
    func getPage(slug: String) {
        butter.getPage(slug: slug, parameters: [.locale(value: "en")], pageTypeSlug: "blog", type: BlogPageFields.self) { result in
            switch result {
            case let .success(page):
                print("pages\(page)")
            //    self.caseStudyPageSubject.send(page)
            case let .failure(error):
                print(error)
                //    self.caseStudyPageSubject.send(completion: .failure(error))
            }
        }
    }
    
    
}
