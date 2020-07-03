import Razor
import Foundation
import Alamofire

struct Resp<T: Decodable>: HTTPResponse, Decodable {
    var result: Result<T, Error> {
        return .success(data)
    }
    
    let data: T
    let success: Bool
    let error: String?
    let unAuthorizedRequest: Bool
    
    private enum CodingKeys: String, CodingKey {
        case data = "result"
        case success
        case error
        case unAuthorizedRequest
    }
}

struct ListResult<T: Decodable>: Decodable {
    let items: [T]
    let totalCount: Int
}

struct Goods: Decodable {
    let id: Int?
    let goodsName: String?
    let image: String?
    let price: String?
    let status: Int?
    let createTime: Date?
    let content: String?
    let type: Int?
}

struct GoodsList: DecodableLoader {
    typealias Response = Resp<ListResult<Goods>>
    typealias Request  = EmptyRequest
    
    let path: String = "/admin/goods/getGoodsList"
    let headers: HTTPHeaders = HTTPHeaders()
    let method: HTTPMethod = .post
    let decoder: DataDecoder = JSONDecoder().rz.customize(dateFormat: "yyyy-MM-dd HH:mm:ss")
}

let q = DispatchQueue(label: "xzcdsfjhjsdjfka")
GoodsList().load(in: q) { (result) in
//    print(result)
}

struct ImageDownloader: StoredDownloader {    
    typealias Request = EmptyRequest
    
    let path: String = "https://httpbin.org/image/png"
    let headers: HTTPHeaders = HTTPHeaders()
}

struct ImageUploader: MultipartFormUploader {
    typealias Response = Resp<String>
    
    let entries: [MultipartFormEnty]
    var headers: HTTPHeaders = HTTPHeaders()
    var method: HTTPMethod = .post
    var path: String = "/index/upload/saveImage"
}

//ImageDownloader().download(in: q) { (result) in
//    print(result)
//}

let data = try! Data(contentsOf: URL(string: "file:///Users/cache/Documents/png.png")!)
ImageUploader(entries: [MultipartFormEnty(name: "file", data: data, fileName: "zxczxcxzczxc")]).upload(in: q) { (result) in
    print(result)
}

sleep(10)
