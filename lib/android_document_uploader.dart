// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:platform/platform.dart';

const String kChannelName = 'plugins.flutter.io/android_intent';

/// Flutter plugin for launching arbitrary Android Intents.
class AndroidIntent {
  final String action;
  final String category;
  final String data;
  final String type;
  final Map<String, dynamic> arguments;
  final String package;
  final MethodChannel _channel;
  final Platform _platform;

  /// Builds an Android intent with the following parameters
  /// [action] refers to the action parameter of the intent.
  /// [category] refers to the category of the intent, can be null.
  /// [data] refers to the string format of the URI that will be passed to
  /// intent.
  /// [arguments] is the map that will be converted into an extras bundle and
  /// passed to the intent.
  const AndroidIntent({
    @required this.action,
    this.type,
    Platform platform,
  })
      : assert(action != null),
        _channel = const MethodChannel(kChannelName),
        _platform = platform ?? const LocalPlatform();

  /// Launch the intent.
  ///
  /// This works only on Android platforms. Please guard the call so that your
  /// iOS app does not crash. Checked mode will throw an assert exception.
  Future<File> launch() async {
    assert(_platform.isAndroid);
    final Map<String, dynamic> args = <String, dynamic>{'action': action};
    if (type != null) {
      args['type'] = type;
    }

    final String path = await _channel.invokeMethod('launch', args);
    print('**New** Getting URI: $path');
    return new File(path);
  }
}
