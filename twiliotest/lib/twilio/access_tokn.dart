import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AccessToken{

  String generateAccessToken({
    required String identity,
    required String roomName,
  }) {
    final jwt = JWT(
      {
        'jti': '${"APiSid"}-${DateTime.now().millisecondsSinceEpoch}',
        'iss': "ApiSid",
        'sub': "AuthToken",
        'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600,
        'grants': {
          'identity': identity,
          'chat': {
            'service_sid': "conversationSId" ,
          },
          'video': {'room': roomName}
        },
      },
    );

    return jwt.sign(SecretKey("APiSecret",isBase64Encoded: true), algorithm: JWTAlgorithm.HS256);
  }


}