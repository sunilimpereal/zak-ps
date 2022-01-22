import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zak_mobile_app/networking/constants.dart';

class Response {
  bool didSucceed;
  dynamic object;
  String responseMessage;

  Response({@required this.didSucceed, @required this.object, @required this.responseMessage});
}
  var backendURL = 'http://awszts.afroaves.com:8080/api/v2/'; 

Future<Response> postRequest(
    {String accessToken,
    String api,
    dynamic body,
    bool signUp = false,
    int successStatusCode}) async {
  var didSucceed = false;
  var message = genericErrorMessage;
  var backendURL = 'http://awszts.afroaves.com:8080/api/v2/'; 
  final url = backendURL + api;
  dynamic decodedResponseBody;
  final headers = {contentTypeKey: applicationJSONTypeKey};
  if (!signUp) {
    headers[authorizationKey] = bearerKey + ' ' + accessToken;
  }
  try {
     log("api url : ${url}");
    log("api body : ${json.encode(body)}");
    // log("api response : ${response.body}");
    final response = await http.post(url, headers: headers, body: json.encode(body));
   
    decodedResponseBody = response.body;

    if (response.statusCode == successStatusCode) {
      didSucceed = true;
      message = 'Successful';
    } else {
      final body = json.decode(response.body.toString());
      if (body.values.first is List) {
        message = body.values.first.first;
      } else {
        message = body.values.first;
      }
    }
  } on SocketException catch (_) {
    message = internetUnavailableMessage;
  } catch (error) {
    message = genericErrorMessage;
  }
  final patientResponse =
      Response(didSucceed: didSucceed, responseMessage: message, object: decodedResponseBody);
  return patientResponse;
}

Future<Response> getRequest({
  String accessToken,
  String api,
  int successStatusCode,
}) async {
  var didSucceed = false;
  var message = genericErrorMessage;
  final url = backendURL + api;
  dynamic decodedResponseBody;
  try {
    final headers = {
      authorizationKey: bearerKey + ' ' + accessToken,
      contentTypeKey: applicationJSONTypeKey
    };
    final response = await http.get(url, headers: headers);
    log("api url : ${url}");
    log("api url : ${response.body}");
    if (response.statusCode == successStatusCode) {
      didSucceed = true;
      decodedResponseBody = response.body;

      message = 'Successful';
    } else {
      final body = json.decode(response.body.toString());
      message = body[messageKey];
    }
  } on SocketException catch (_) {
    message = internetUnavailableMessage;
  } catch (error) {
    message = error.toString();
  }
  return Response(didSucceed: didSucceed, responseMessage: message, object: decodedResponseBody);
}

Future<Response> patchRequest({
  dynamic body,
  String accessToken,
  String api,
  int successStatusCode,
}) async {
  var didSucceed = false;
  var message = genericErrorMessage;
  final url = backendURL + api;
  dynamic decodedResponseBody;

  try {
    final headers = {
      authorizationKey: bearerKey + ' ' + accessToken,
      contentTypeKey: applicationJSONTypeKey
    };
    final response = await http.patch(url, headers: headers, body: json.encode(body));
    log("api url : ${url}");
    log("api body : ${json.encode(body)}");
    log("api response : ${response.body}");
    if (response.statusCode == successStatusCode) {
      didSucceed = true;
      decodedResponseBody = response.body;

      message = 'Successful';
    } else {
      final body = json.decode(response.body);
      message = body[messageKey];
    }
  } on SocketException catch (_) {
    message = internetUnavailableMessage;
  } catch (error) {
    message = error.toString();
  }
  return Response(didSucceed: didSucceed, responseMessage: message, object: decodedResponseBody);
}
