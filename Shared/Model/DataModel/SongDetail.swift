//
//  Song.swift
//  Qin
//
//  Created by 林少龙 on 2020/6/24.
//  Copyright © 2020 teenloong. All rights reserved.
//

import Foundation
struct SongDetail: Codable, Identifiable {
    struct Album: Codable {
        var id: Int
        var name: String?
        var pic: Int
        var picUrl: String
        var pic_str: String?//optional for playlist detail
//        var tns: [Any]
    }
    struct Artist: Codable {
        var alias: [String]
        var id: Int
        var name: String?
//        var tns: [Any]
    }
    struct Privilege: Codable {//recommendSongs
        var cp: Int
        var cs: Bool
        var dl: Int
        var fee: Int
        var fl: Int
        var flag: Int
        var id: Int
        var maxbr: Int
        var payed: Int
        var pl: Int
        var preSell: Bool
        var sp: Int
        var st: Int
        var subp: Int
        var toast: Bool
    }
    struct Quality: Codable {
        var br: Int
        var fid: Int
        var size: Int
        var vd: Double?
    }
//    var a: Any?
    var al: Album
    var alia: [String]
    var ar: [Artist]
    var cd: String?
    var cf: String?
    var copyright: Int
    var cp: Int
//    var crbt: Any?
    var djId: Int
    var dt: Int// duration time
    var fee: Int
    var ftype: Int
    var h: Quality?
    var id: Int
    var l: Quality?
    var m: Quality?
    var mark: Int
    var mst: Int
    var mv: Int
    var name: String
    var no: Int
//    var noCopyrightRcmd: Any?
    var originCoverType: Int
    var pop: Int
    var privilege: Privilege?//optional for recommendSongs
    var pst: Int
    var reason: String? //optional for recommendSongs
    var publishTime: Int
    var rt: String?//optional for playlist detail
    var rtUrl: String?
    var rtUrls: [String]
    var rtype: Int
    var rurl: String?
    var s_id: Int
    var single: Int?//optional for playlist detail
    var st: Int
    var t: Int
    var v: Int
}

extension SongDetail {
    var artists: String {
        if self.ar.count > 0 {
            return self.ar.map{ ($0.name ?? "") }.joined(separator: " & ")
        }else {
            return ""
        }
    }
}
//{
//    br = 804369;
//    canExtend = 0;
//    code = 200;
//    encodeType = "<null>";
//    expi = 1200;
//    fee = 8;
//    flag = 0;
//    freeTrialInfo = "<null>";
//    gain = 0;
//    id = 1351615757;
//    level = "<null>";
//    md5 = 369097865591e1a002ffe0d3c278073f;
//    payed = 3;
//    size = 24137662;
//    type = flac;
//    uf = "<null>";
//    url = "http://m10.music.126.net/20200625020841/77d4b7b6554829dd2bab5cf82eba4ccd/ymusic/045c/0e5b/525a/369097865591e1a002ffe0d3c278073f.flac";
//}

struct SongURL: Codable {
    var br: Int
    var id: Int
    var level: String?
    var payed: Int
    var size: Int
    var type: String?
    var url: String?
}

struct Album: Codable, Identifiable {
    var alias: [String]
    var artist: Artist
    var artists: [Artist]
    var blurPicUrl: String
    var briefDesc: String
    var commentThreadId: String
    var company: String?
    var companyId: Int
    var copyrightId: Int
    var description: String
    var id: Int
//    var info: Any
    var mark: Int
    var name: String
    var onSale: Bool
    var paid: Bool
    var pic: Int
    var picId: Int
    var picId_str: String
    var picUrl: String
    var publishTime: Int
    var size: Int
//    var songs: Any
    var status: Int
    var subType: String
    var tags: String
    var type: String
}

//{
//    albumSize = 39;
//    alias =     (
//        "Jay Chou"
//    );
//    briefDesc = "";
//    followed = 1;
//    id = 6452;
//    img1v1Id = 109951163111191410;
//    "img1v1Id_str" = 109951163111191410;
//    img1v1Url = "https://p1.music.126.net/o-FjCrUlhyFC96xiVvJZ8g==/109951163111191410.jpg";
//    musicSize = 643;
//    mvSize = 8;
//    name = "\U5468\U6770\U4f26";
//    picId = 109951163111196186;
//    "picId_str" = 109951163111196186;
//    picUrl = "https://p1.music.126.net/ql3nSwy0XKow_HAoZzRZgw==/109951163111196186.jpg";
//    publishTime = 1516594084751;
//    topicPerson = 0;
//    trans = "";
//}
struct Artist: Codable, Identifiable {
    var albumSize: Int
    var alias: [String]
    var briefDesc: String
    var followed: Bool
    var id: Int
    var img1v1Id: Int
    var img1v1Id_str: String
    var img1v1Url: String
    var musicSize: Int
    var mvSize: Int?// optional for Album
    var name: String
    var picId: Int
    var picId_str: String?// optional for Album
    var picUrl: String
    var publishTime: Int?// optional for Album
    var topicPerson: Int
    var trans: String
}

//{
//    commentCount = 17;
//    commentThread =         {
//        commentCount = 17;
//        hotCount = 0;
//        id = "R_AL_3_36693523";
//        latestLikedUsers = "<null>";
//        likedCount = 0;
//        resourceId = 36693523;
//        resourceInfo =             {
//            creator = "<null>";
//            encodedId = "<null>";
//            id = 36693523;
//            imgUrl = "https://p3.music.126.net/wchJJxgOtv0a2SRKuLV0hw==/109951164430998564.jpg";
//            name = "\U6587\U592b";
//            subTitle = "<null>";
//            userId = "-1";
//            webUrl = "<null>";
//        };
//        resourceOwnerId = "-1";
//        resourceTitle = "\U6587\U592b";
//        resourceType = 3;
//        shareCount = 10;
//    };
//    comments = "<null>";
//    latestLikedUsers = "<null>";
//    liked = 0;
//    likedCount = 0;
//    resourceId = 36693523;
//    resourceType = 3;
//    shareCount = 10;
//    threadId = "R_AL_3_36693523";
//}
//struct AlbumInfo {
//
//}
