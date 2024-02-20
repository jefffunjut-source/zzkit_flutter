// ignore_for_file: no_leading_underscores_for_local_identifiers
library zzkit;

class HtResponseDynamicResource {
  String? code;
  String? msg;
  Data? data;

  HtResponseDynamicResource({this.code, this.msg, this.data});

  HtResponseDynamicResource.fromJson(Map<String, dynamic> json) {
    if (json["code"] is String) {
      code = json["code"];
    }
    if (json["msg"] is String) {
      msg = json["msg"];
    }
    if (json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["code"] = code;
    _data["msg"] = msg;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  String? verifyType;
  String? recommendSearchKey;
  List<dynamic>? recommendSearchKeyArrs;
  String? simpleKvJson;
  String? dealTitleFilter;
  String? shoeRecommendSearchKey;
  SpecialIcon? specialIcon;

  Data(
      {this.verifyType,
      this.recommendSearchKey,
      this.recommendSearchKeyArrs,
      this.simpleKvJson,
      this.dealTitleFilter,
      this.shoeRecommendSearchKey,
      this.specialIcon});

  Data.fromJson(Map<String, dynamic> json) {
    if (json["verify_type"] is String) {
      verifyType = json["verify_type"];
    }
    if (json["recommend_search_key"] is String) {
      recommendSearchKey = json["recommend_search_key"];
    }
    if (json["recommend_search_key_arrs"] is List) {
      recommendSearchKeyArrs = json["recommend_search_key_arrs"] ?? [];
    }
    if (json["simple_kv_json"] is String) {
      simpleKvJson = json["simple_kv_json"];
    }
    if (json["deal_title_filter"] is String) {
      dealTitleFilter = json["deal_title_filter"];
    }
    if (json["shoe_recommend_search_key"] is String) {
      shoeRecommendSearchKey = json["shoe_recommend_search_key"];
    }
    if (json["special_icon"] is Map) {
      specialIcon = json["special_icon"] == null
          ? null
          : SpecialIcon.fromJson(json["special_icon"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["verify_type"] = verifyType;
    _data["recommend_search_key"] = recommendSearchKey;
    if (recommendSearchKeyArrs != null) {
      _data["recommend_search_key_arrs"] = recommendSearchKeyArrs;
    }
    _data["simple_kv_json"] = simpleKvJson;
    _data["deal_title_filter"] = dealTitleFilter;
    _data["shoe_recommend_search_key"] = shoeRecommendSearchKey;
    if (specialIcon != null) {
      _data["special_icon"] = specialIcon?.toJson();
    }
    return _data;
  }
}

class SpecialIcon {
  DFloatView? dFloatView;

  SpecialIcon({this.dFloatView});

  SpecialIcon.fromJson(Map<String, dynamic> json) {
    if (json["d_float_view"] is Map) {
      dFloatView = json["d_float_view"] == null
          ? null
          : DFloatView.fromJson(json["d_float_view"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (dFloatView != null) {
      _data["d_float_view"] = dFloatView?.toJson();
    }
    return _data;
  }
}

class DFloatView {
  String? styleId;
  String? name;
  String? imgUrl;
  String? linkType;
  String? linkData;

  DFloatView(
      {this.styleId, this.name, this.imgUrl, this.linkType, this.linkData});

  DFloatView.fromJson(Map<String, dynamic> json) {
    if (json["style_id"] is String) {
      styleId = json["style_id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["img_url"] is String) {
      imgUrl = json["img_url"];
    }
    if (json["link_type"] is String) {
      linkType = json["link_type"];
    }
    if (json["link_data"] is String) {
      linkData = json["link_data"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["style_id"] = styleId;
    _data["name"] = name;
    _data["img_url"] = imgUrl;
    _data["link_type"] = linkType;
    _data["link_data"] = linkData;
    return _data;
  }
}
