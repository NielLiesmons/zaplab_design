import 'dart:collection';
import 'package:video_player/video_player.dart';

class VideoPreviewHandle {
  final VideoPlayerController controller;
  int refCount;
  VideoPreviewHandle(this.controller, this.refCount);
}

class VideoPreviewCache {
  static final Map<String, Future<VideoPlayerController?>> _initFutures = {};
  static final Map<String, VideoPreviewHandle> _controllers = {};

  static Future<VideoPlayerController?> acquire(String url) {
    // If an initialized controller exists, bump ref and return it
    final handle = _controllers[url];
    if (handle != null) {
      handle.refCount += 1;
      return Future.value(handle.controller);
    }

    // If an init is in-flight, attach to it and on success, store with ref=1
    final existing = _initFutures[url];
    if (existing != null) {
      return existing.then((c) {
        if (c != null) {
          final h = _controllers[url];
          if (h != null) {
            h.refCount += 1;
          } else {
            _controllers[url] = VideoPreviewHandle(c, 1);
          }
        }
        return c;
      });
    }

    // Start init
    final future = _initialize(url);
    _initFutures[url] = future;
    return future.then((c) {
      _initFutures.remove(url);
      if (c != null) {
        _controllers[url] = VideoPreviewHandle(c, 1);
      }
      return c;
    });
  }

  static Future<VideoPlayerController?> _initialize(String url) async {
    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();
      await controller.setVolume(0);
      await controller.pause();
      return controller;
    } catch (_) {
      return null;
    }
  }

  static void release(String url) {
    final handle = _controllers[url];
    if (handle == null) return;
    handle.refCount -= 1;
    if (handle.refCount <= 0) {
      handle.controller.dispose();
      _controllers.remove(url);
    }
  }
}
