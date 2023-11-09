import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonSerializable()
class NewsGalleryResponse {
  @JsonKey(name: 'status')
  int? status;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'data')
  NewsGalleryListData? newsGalleryListData;

  NewsGalleryResponse({
    this.status,
    this.message,
    this.newsGalleryListData,
  });

  factory NewsGalleryResponse.fromJson(Map<String, dynamic> json) =>
      NewsGalleryResponse(
        status: json["status"],
        message: json["message"],
        newsGalleryListData: json["data"] == null
            ? null
            : NewsGalleryListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": newsGalleryListData?.toJson(),
      };
}

class NewsGalleryListData {
  @JsonKey(name: 'newsList')
  List<NewsGalleryList> newsGalleryList;
  @JsonKey(name: 'pageNumber')
  int? pageNumber;
  @JsonKey(name: 'pageSize')
  int? pageSize;
  @JsonKey(name: 'totalCount')
  int? totalCount;

  NewsGalleryListData({
    required this.newsGalleryList,
    this.pageNumber,
    this.pageSize,
    this.totalCount,
  });

  factory NewsGalleryListData.fromJson(Map<String, dynamic> json) =>
      NewsGalleryListData(
        newsGalleryList: List<NewsGalleryList>.from(
            json["newsList"].map((x) => NewsGalleryList.fromJson(x))),
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toJson() => {
        "newsList":
            List<NewsGalleryList>.from(newsGalleryList.map((x) => x.toJson())),
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalCount": totalCount,
      };
}

@JsonSerializable()
class NewsGalleryList {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'heading')
  String? heading;
  @JsonKey(name: 'subHeading')
  String? subHeading;
  @JsonKey(name: 'newsContent')
  String? newsContent;
  @JsonKey(name: 'categories')
  List<Category>? categories;
  @JsonKey(name: 'locationId')
  String? locationId;
  @JsonKey(name: 'location')
  String? location;
  @JsonKey(name: 'mediaList')
  MediaList? mediaList;
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'publishedOn')
  DateTime? publishedOn;
  @JsonKey(name: 'publishedBy')
  String? publishedBy;
  @JsonKey(name: 'createdBy')
  String? createdBy;
  @JsonKey(name: 'createdOn')
  String? createdOn;
  @JsonKey(name: 'lastUpdatedOn')
  String? lastUpdatedOn;
  @JsonKey(name: 'lastUpdatedBy')
  String? lastUpdatedBy;
  @JsonKey(name: 'newsType')
  String? newsType;
  @JsonKey(name: 'newsTypeId')
  int? newsTypeId;
  @JsonKey(name: 'isActive')
  bool? isActive;

  NewsGalleryList({
    this.id,
    this.heading,
    this.subHeading,
    this.newsContent,
    this.categories,
    this.locationId,
    this.location,
    this.mediaList,
    this.status,
    this.publishedOn,
    this.publishedBy,
    this.createdBy,
    this.createdOn,
    this.lastUpdatedOn,
    this.lastUpdatedBy,
    this.isActive,
    this.newsType,
    this.newsTypeId,
  });

  factory NewsGalleryList.fromRawJson(String str) =>
      NewsGalleryList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewsGalleryList.fromJson(Map<String, dynamic> json) =>
      NewsGalleryList(
        id: json["id"],
        heading: json["heading"],
        subHeading: json["subHeading"],
        newsContent: json["newsContent"],
        newsType: json["newsType"],
        newsTypeId: json["newsTypeId"],
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x))),
        locationId: json["locationId"],
        location: json["location"],
        mediaList: json["mediaList"] != null
            ? MediaList.fromJson(json["mediaList"])
            : null,
        status: json["status"],
        publishedOn: json["publishedOn"] == null
            ? null
            : DateTime.parse(json["publishedOn"]),
        publishedBy: json["publishedBy"],
        createdBy: json["createdBy"],
        createdOn: json["createdOn"],
        lastUpdatedOn: json["lastUpdatedOn"],
        lastUpdatedBy: json["lastUpdatedBy"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "subHeading": subHeading,
        "newsContent": newsContent,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "locationId": locationId,
        "location": location,
        "mediaList": mediaList,
        "status": status,
        "publishedOn": publishedOn,
        "publishedBy": publishedBy,
        "createdBy": createdBy,
        "createdOn": createdOn,
        "lastUpdatedOn": lastUpdatedOn,
        "lastUpdatedBy": lastUpdatedBy,
        "isActive": isActive,
      };
}

class Category {
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'hindiName')
  String? hindiName;

  Category({
    this.id,
    this.name,
    this.hindiName,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        hindiName: json["hindiName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "hindiName": hindiName,
      };
}

class MediaList {
  List<ImageList>? imageList;
  List<VideoList>? videoList;
  List<AudioList>? audioList;

  MediaList({
    this.imageList,
    this.videoList,
    this.audioList,
  });

  factory MediaList.fromJson(Map<String, dynamic> json) => MediaList(
        imageList: List<ImageList>.from(
            json["imageList"].map((x) => ImageList.fromJson(x))),
        videoList: List<VideoList>.from(
            json["videoList"].map((x) => VideoList.fromJson(x))),
        audioList: List<AudioList>.from(
            json["audioList"].map((x) => AudioList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "imageList": List<dynamic>.from(imageList!.map((x) => x.toJson())),
        "videoList": List<dynamic>.from(videoList!.map((x) => x.toJson())),
        "audioList": List<dynamic>.from(audioList!.map((x) => x.toJson())),
      };
}

class ImageList {
  String? url;
  String? type;
  String? placeholder;

  ImageList({
    this.url,
    this.type,
    this.placeholder,
  });

  factory ImageList.fromJson(Map<String, dynamic> json) => ImageList(
        url: json["url"],
        type: json["type"],
        placeholder: json["placeholder"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "type": type,
        "placeholder": placeholder,
      };
}

class VideoList {
  String? url;
  String? type;
  String? placeholder;

  VideoList({
    this.url,
    this.type,
    this.placeholder,
  });

  factory VideoList.fromJson(Map<String, dynamic> json) => VideoList(
        url: json["url"],
        type: json["type"],
        placeholder: json["placeholder"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "type": type,
        "placeholder": placeholder,
      };
}

class AudioList {
  String? url;
  String? type;
  String? placeholder;

  AudioList({
    this.url,
    this.type,
    this.placeholder,
  });

  factory AudioList.fromJson(Map<String, dynamic> json) => AudioList(
        url: json["url"],
        type: json["type"],
        placeholder: json["placeholder"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "type": type,
        "placeholder": placeholder,
      };
}
