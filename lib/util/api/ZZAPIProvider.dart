// ignore_for_file: use_string_in_part_of_directives, prefer_interpolation_to_compose_strings, implementation_imports, library_prefixes, file_names, unnecessary_library_name
library zzkit;

import 'dart:convert';
import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart' as DioFormData;
import 'package:flutter/foundation.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';
import 'package:zzkit_flutter/util/core/ZZManager.dart';

enum ZZHTTPMethod { post, get, delete, put }

/// Dio
late Dio zzDio;

abstract class ZZAPIProvider {
  /// 设置代理
  /// (uri) {
  ///    // 进行抓包的主机IP和端口
  ///    return "PROXY 172.16.9.47:8888";
  ///  }
  String Function(Uri url)? proxy;

  /// 初始化dio
  Future<bool> initDio();

  /// 更新dio
  void updateDio();

  /// 处理response和model的映射
  dynamic process(String url, Map<String, dynamic> json);
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
  ZZAPIProvider provider;
  String apiUrl;
  ZZHTTPMethod httpMethod;
  Map<String, dynamic>? datas;
  Map<String, dynamic>? params;
  bool enableFormData;
  bool enableErrorToast;
  bool enableDetailedError;
  CancelToken? cancelToken;
  bool checkCode;

  ZZAPIRequest({
    required this.provider,
    required this.apiUrl,
    this.httpMethod = ZZHTTPMethod.post,
    this.datas,
    this.params,
    this.enableFormData = true,
    this.enableErrorToast = true,
    this.enableDetailedError = true,
    this.cancelToken,
    this.checkCode = true,
  });

  Future<ZZAPIResponse> request() async {
    dynamic resp;
    ZZAPIError? error;
    String url = apiUrl;

    provider.updateDio();
    String? debugInfo;
    String? responseStr;
    try {
      // 支持Charles抓包
      // Dio 6.0之前的设置
      // ignore: deprecated_member_use
      // (zzDio.httpClientAdapter as DefaultHttpClientAdapter)
      //     .onHttpClientCreate = (HttpClient client) {
      //   client.findProxy = provider.proxy;
      //   client.badCertificateCallback = (cert, host, port) {
      //     return true;
      //   };
      //   return null;
      // };
      // Dio 6.0的抓包方式
      // zzDio.httpClientAdapter = IOHttpClientAdapter(
      //   createHttpClient: () {
      //     final client = HttpClient();
      //     client.findProxy = (uri) {
      //       // 设置代理，例如：
      //       return "PROXY localhost:8888";
      //     };
      //     client.badCertificateCallback =
      //         (X509Certificate cert, String host, int port) => true;
      //     return client;
      //   },
      // );

      // url中包含{id}这样的需要替换
      String originalUrl = url;
      if (url.contains("{id}")) {
        assert(
          (datas != null && datas!["id"] != null) ||
              (params != null && params!["id"] != null),
          "请检查输入datas或者params中必须传入一个{\"id\":\"xxx\"}的参数",
        );
        var id = datas?["id"] != null ? datas!["id"] : params!["id"];
        url = url.replaceAll("{id}", id.toString());
      }
      // url中包含{type}这样的需要替换
      if (url.contains("{type}")) {
        assert(
          (datas != null && datas!["type"] != null) ||
              (params != null && params!["type"] != null),
          "请检查输入datas或者params中必须传入一个{\"type\":\"xxx\"}的参数",
        );
        var type = datas?["type"] != null ? datas!["type"] : params!["type"];
        url = url.replaceAll("{type}", type.toString());
      }
      // url中包含{name}这样的需要替换
      if (url.contains("{name}")) {
        assert(
          (datas != null && datas!["name"] != null) ||
              (params != null && params!["name"] != null),
          "请检查输入datas或者params中必须传入一个{\"name\":\"xxx\"}的参数",
        );
        var name = datas?["name"] != null ? datas!["name"] : params!["name"];
        url = url.replaceAll("{name}", name.toString());
      }

      // 打印请求参数
      debugPrint(
        '[[[ZZAPI Request==[url = $url][headers =  ${zzDio.options.headers}][baseUrl = ${zzDio.options.baseUrl}][params = $params][datas = $datas][enableFormData = $enableFormData][enableErrorToast = $enableErrorToast]',
        wrapWidth: null,
      );

      dynamic response;
      switch (httpMethod) {
        case ZZHTTPMethod.post:
          {
            response = await zzDio.post(
              url,
              data:
                  enableFormData
                      ? DioFormData.FormData.fromMap(datas ?? {})
                      : datas,
              queryParameters: params,
              cancelToken: cancelToken,
            );
            break;
          }
        case ZZHTTPMethod.get:
          {
            response = await zzDio.get(
              url,
              queryParameters: params,
              cancelToken: cancelToken,
            );
            break;
          }
        case ZZHTTPMethod.delete:
          {
            response = await zzDio.delete(
              url,
              queryParameters: params,
              cancelToken: cancelToken,
            );
            break;
          }
        case ZZHTTPMethod.put:
          {
            response = await zzDio.put(
              url,
              data: datas,
              queryParameters: params,
              cancelToken: cancelToken,
            );
            break;
          }
      }

      debugInfo = "==ZZAPI Response 1==[url = $url]";
      responseStr = "]]]ZZAPI Response 2==[response = ${response.data}]";
      responseStr = responseStr.replaceAll("\n", "");

      var body = response.data;
      if (body is String) {
        body = jsonDecode(body);
      }
      resp = provider.process(originalUrl, body);

      assert(resp != null, "请在process方法中加入映射代码，将返回反射成model");

      if (checkCode) {
        if ((resp.code is String && resp.code == "0") ||
            ((resp.code is int || resp.code is Int) && resp.code == 0)) {
          debugInfo = "$debugInfo[请求成功]";
        } else {
          debugInfo = "$debugInfo[请求失败]";
          if (resp.msg != null && resp.msg is String) {
            if (enableErrorToast) {
              ZZ.toast(resp.msg);
            }
          }
          error = ZZAPIError(
            code: resp.code is String ? resp.code : resp.code.toString(),
            errorMessage: resp.msg is String ? resp.msg : resp.msg.toString(),
          );
          resp = null;
        }
      } else {
        debugInfo = "$debugInfo[请求成功]";
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // 豁免该类报错
        // 用户手动取消或者页面退出取消请求
        debugInfo = "$debugInfo[请求取消]";
        error = null;
        resp = null;
      } else if (e.toString().toLowerCase().contains("timeout")) {
        // 豁免Toast该类报错
        debugInfo = "$debugInfo[请求超时]";
        error = ZZAPIError(code: "-1", errorMessage: "Timeout");
        resp = null;
      } else if (e.toString().toLowerCase().contains("os error")) {
        // 豁免Toast该类报错
        debugInfo = "$debugInfo[请求OS Error]";
        error = ZZAPIError(code: "-2", errorMessage: "OS Error");
        resp = null;
      } else if (e is TypeError) {
        debugInfo =
            "$debugInfo[请求Type异常 error:${e.toString()} stackTrace:${e.stackTrace}]";
        ZZ.toast(
          (enableDetailedError
              ? "Something around type goes wrong with server.Please try again later.\n\n$e\n\n${e.stackTrace}"
              : "Something around type goes wrong with server.Please try again later."),
          duration: enableDetailedError ? 3 : 1,
        );
        error = ZZAPIError(code: "-3", errorMessage: e.toString());
        resp = null;
      } else {
        String errorString = e.toString();
        debugInfo = "$debugInfo[请求其它异常 error:$errorString]";
        ZZ.toast(
          enableDetailedError
              ? "Something goes wrong with server.Please try again later.\n\n$errorString"
              : "Something goes wrong with server.Please try again later.",
        );
        error = ZZAPIError(code: "-4", errorMessage: errorString);
        resp = null;
      }
    }
    debugPrint(debugInfo);
    debugPrint(responseStr);
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
