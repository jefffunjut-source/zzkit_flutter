// ignore_for_file: use_string_in_part_of_directives, prefer_interpolation_to_compose_strings, implementation_imports, library_prefixes, file_names
library zzkit;

import 'dart:convert';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/foundation.dart';
import 'package:zzkit_flutter/util/ZZExtension.dart';
import 'package:zzkit_flutter/util/api/ZZDevice.dart';
import 'package:zzkit_flutter/util/api/response/ht_response_dynamic_resource.dart';
import 'package:zzkit_flutter/util/core/ZZAppConsts.dart';
import 'package:zzkit_flutter/util/core/ZZAppManager.dart';

enum ZZAPIReqType { post, get, delete, put }

class ZZAPIUrl {
  static const test = "/api/test";
  static const dynamicResource = "/common/dynamic_resource";
}

class ZZAPIProvider {
  static void initailDio() async {
    String deviceId = await ZZDevice.deviceId() ?? "";
    String os = await ZZDevice.os() ?? "";
    String model = await ZZDevice.model() ?? "";
    String platform = ZZDevice.platform();
    double scale = ZZDevice.scale();
    String userToken = ZZDevice.userToken() ?? "";
    kUserTokenNotifier.addListener(() {
      kDio.options.baseUrl = kAPIHostNotifier.value;
    });
    kDio = Dio(BaseOptions(
      baseUrl: kAPIHostNotifier.value,
    )
      ..headers["v"] = "v3.1"
      ..headers["n"] = deviceId
      ..headers["client-v"] = kAppVersion.replaceFirst("V", "")
      ..headers["p"] = platform
      ..headers["os"] = os
      ..headers["model"] = model
      ..headers["net-type"] = "4G"
      ..headers["scale"] = scale
      ..headers["w"] = kScreenWidth.toString()
      ..headers["h"] = kScreenHeight.toString()
      ..headers["t"] = ""
      ..headers["api-token"] = ""
      ..headers["token"] = userToken
      ..followRedirects = true
      ..maxRedirects = 100);
  }

  static void updateDio() {
    String time = ZZDevice.secondsSince1970();
    kDio.options.headers["t"] = time;
    kDio.options.headers["api-token"] = "$time@55haitao".parse2MD5String();
    kDio.options.headers["token"] = kUserTokenNotifier.value;
  }

  static dynamic process(String url, Map<String, dynamic> json) {
    dynamic resp;
    switch (url) {
      case ZZAPIUrl.test:
        {
          ZZCommonResponse response = ZZCommonResponse();
          response.code = "0";
          response.msg = "";
          break;
        }
      case ZZAPIUrl.dynamicResource:
        resp = HtResponseDynamicResource.fromJson(json);
        break;
      default:
        {
          resp = ZZCommonResponse.fromJson(json);
        }
    }
    return resp;
  }
}

class ZZAPIError {
  String? code;
  String? errorMessage;

  ZZAPIError({this.code, this.errorMessage});
}

class ZZAPIResponse<T> {
  T? resp;
  ZZAPIError? error;
  List? rows;

  ZZAPIResponse(this.resp, this.error);
}

class ZZAPIRequest {
  // 0 post 1 get 2 delete
  ZZAPIReqType? type;
  final String apiUrl;
  Map? data;
  Map<String, dynamic>? dataFromMap;
  Map<String, dynamic>? params;
  CancelToken? cancelToken;
  String? pageName;
  bool? noToast;

  ZZAPIRequest(
      {this.type = ZZAPIReqType.post,
      required this.apiUrl,
      this.data,
      this.dataFromMap,
      this.params,
      this.cancelToken,
      this.pageName,
      this.noToast});

  Future<ZZAPIResponse> request() async {
    dynamic resp;
    ZZAPIError? error;
    String url = apiUrl;

    ZZAPIProvider.updateDio();

    try {
      // 支持Charles抓包
      // ignore: deprecated_member_use
      (kDio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        // client.findProxy = (uri) {
        // 进行抓包的主机IP和端口
        // return "PROXY 172.16.9.47:8888";
        // };
        client.badCertificateCallback = (cert, host, port) {
          return true;
        };
        return null;
      };

      if (url.contains("{id}")) {
        assert(
            (data != null && data!["id"] != null) ||
                (params != null && params!["id"] != null),
            "请检查输入data必须传id");
        var id = data?["id"] != null ? data!["id"] : params!["id"];
        url = url.replaceAll("{id}", id.toString());
      }

      // if (kDebugMode) {
      if (kDebugMode) {
        print('==========++++++++++API==========++++++++++');
        print(kAPIHostNotifier.value);
        print('dio.options.headers =  ${kDio.options.headers}');
        print('baseUrl =  ${kDio.options.baseUrl}');
        print("url = $url");
        print("parm = $params");
        print("data = $data");
      }
      debugPrint("dataFromMap = $dataFromMap");
      // }
      dynamic response;
      switch (type!) {
        case ZZAPIReqType.post:
          {
            if (dataFromMap != null) {
              response = await kDio.post(url,
                  data: DioFormData.FormData.fromMap(dataFromMap!),
                  queryParameters: params,
                  cancelToken: cancelToken);
            } else {
              response = await kDio.post(url,
                  data: data,
                  queryParameters: params,
                  cancelToken: cancelToken);
            }
            break;
          }
        case ZZAPIReqType.get:
          {
            response = await kDio.get(url,
                queryParameters: params, cancelToken: cancelToken);
            break;
          }
        case ZZAPIReqType.delete:
          {
            response = await kDio.delete(url,
                queryParameters: params, cancelToken: cancelToken);
            break;
          }
        case ZZAPIReqType.put:
          {
            response = await kDio.put(url,
                data: data, queryParameters: params, cancelToken: cancelToken);
            break;
          }
      }

      if (kDebugMode) {
        print("=========++++++++++Response==========++++++++++");
        print("url = $url \n ---   --- response =  ${response.data}");
      }

      var body = response.data;
      if (body is String) {
        body = jsonDecode(body);
      }
      resp = ZZAPIProvider.process(url, body);

      assert(resp != null, "处理映射关系");
      if (resp.code == 0 || resp.code == "0") {
        if (kDebugMode) {
          print("请求成功");
        }
      } else {
        if (resp.msg != null) {
          if (kDebugMode) {
            APP.toast("Oops,catch a server error:\n\n" + resp.msg!,
                duration: 3, pageName: pageName);
          } else {
            if (noToast == null || noToast == false) {
              APP.toast(resp.msg!, pageName: pageName);
            }
          }
        }
        error = ZZAPIError(
            code: resp.code is String ? resp.code : resp.code.toString(),
            errorMessage: resp.msg ?? "Server Error");
        resp = null;
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // 用户手动取消或者页面退出取消请求
        return ZZAPIResponse(null, null);
      } else if (e is TypeError) {
        if (kDebugMode) {
          APP.toast("Oops,catch a type error:\n\n$e\n\n${e.stackTrace}",
              duration: 3, pageName: pageName);
          return ZZAPIResponse(
              null, ZZAPIError(code: "100", errorMessage: e.toString()));
        }
      } else if (e.toString().contains("timeout") ||
          e.toString().contains("Timeout")) {
      } else if (e.toString().contains("OS Error")) {
        // 豁免该类报错
      } else {
        if (kDebugMode) {
          APP.toast("Oops,catch an error:\n\n$e",
              duration: 3, pageName: pageName);
        } else {
          String errorString = e.toString();
          if (kDebugMode) {
            print("请求失败 url = $url ------ response = $errorString ");
          }
          APP.toast('Please try again!', pageName: pageName);
        }
      }
      // }
      resp = null;
      error = ZZAPIError(code: "-1", errorMessage: e.toString());
    }
    return ZZAPIResponse(resp, error);
  }
}

class ZZCommonResponse {
  String? code;
  String? msg;

  ZZCommonResponse({this.code, this.msg});

  ZZCommonResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    return data;
  }
}
