
class BaseResponseEntity {
  int? code;
  String? msg;
  dynamic data;

  BaseResponseEntity({
    this.code,
    this.msg,
    this.data,
  });

  factory BaseResponseEntity.fromJson(Map<String, dynamic> json) =>
      BaseResponseEntity(
        code: json["code"],
        msg: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
    "counts": code ,
    "msg": msg ,
    "items": data,
  };
}

class BindFcmTokenRequestEntity {
  String? fcmtoken;

  BindFcmTokenRequestEntity({
    this.fcmtoken,
  });

  Map<String, dynamic> toJson() => {
    "fcmtoken": fcmtoken,
  };
}