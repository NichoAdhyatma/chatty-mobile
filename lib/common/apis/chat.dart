import 'package:dio/dio.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/utils/utils.dart';
import 'package:flutter/foundation.dart';

class ChatAPI {
  static Future<BaseResponseEntity> bind_fcmtoken(
      {BindFcmTokenRequestEntity? params}) async {
    var response = await HttpUtil().post(
      'api/bind_fcmtoken',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> call_notifications(
      {CallRequestEntity? params}) async {
    var response = await HttpUtil().post(
      'api/send_notice',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> call_token(
      {CallTokenRequestEntity? params}) async {
    var response = await HttpUtil().post(
      'api/get_rtc_token',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> send_message(
      {ChatRequestEntity? params}) async {
    var response = await HttpUtil().post(
      'api/message',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> upload_img({dynamic file}) async {
    try {
      late FormData data;

      if (kIsWeb) {
        // For web platform
        if (file is Uint8List) {
          data = FormData.fromMap({
            "file": MultipartFile.fromBytes(
              file,
              filename: '${DateTime.now().microsecondsSinceEpoch}.jpg', // Or generate a unique name
            ),
          });
        }
      } else {
        // For mobile/desktop platforms
        String fileName = file.path.split('/').last;
        data = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        });
      }

      var response = await HttpUtil().post(
        'api/upload_photo',
        data: data,
      );
      return BaseResponseEntity.fromJson(response);
    } catch (e) {
      print('Upload error: $e');
      throw e; // Or handle error appropriately
    }
  }

  static Future<SyncMessageResponseEntity> sync_message(
      {SyncMessageRequestEntity? params}) async {
    var response = await HttpUtil().post(
      'api/sync_message',
      queryParameters: params?.toJson(),
    );
    return SyncMessageResponseEntity.fromJson(response);
  }
}
