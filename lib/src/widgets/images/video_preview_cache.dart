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
  // Controllers with refCount==0 that are kept for reuse (LRU by insertion order)
  static final LinkedHashMap<String, VideoPlayerController> _available =
      LinkedHashMap();

  // Maximum number of idle controllers to keep
  static const int _maxIdleControllers = 6;

  static Future<VideoPlayerController?> acquire(String url) {
    // If an initialized controller exists, bump ref and return it
    final handle = _controllers[url];
    if (handle != null) {
      handle.refCount += 1;
      return Future.value(handle.controller);
    }

    // If an idle controller exists in the pool, move it to active and return
    final idle = _available.remove(url);
    if (idle != null) {
      _controllers[url] = VideoPreviewHandle(idle, 1);
      return Future.value(idle);
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

  static bool _isLocalAsset(String url) {
    return url.startsWith('assets/') || url.startsWith('../assets/');
  }

  static Future<VideoPlayerController?> _initialize(String url) async {
    try {
      VideoPlayerController controller;

      // Check if it's a local asset
      if (_isLocalAsset(url)) {
        controller = VideoPlayerController.asset(url);
      } else {
        // Assume it's a network URL
        controller = VideoPlayerController.networkUrl(Uri.parse(url));
      }

      await controller.initialize();
      await controller.setVolume(0);
      await controller.pause();
      return controller;
    } catch (error) {
      return null;
    }
  }

  static void release(String url) {
    final handle = _controllers[url];
    if (handle == null) return;
    handle.refCount -= 1;
    if (handle.refCount <= 0) {
      // Move to idle pool for reuse
      final controller = handle.controller;
      _controllers.remove(url);
      // Refresh LRU position if already present
      _available.remove(url);
      _available[url] = controller;

      // Enforce capacity: dispose least-recently-used idle controllers
      while (_available.length > _maxIdleControllers) {
        final String oldestKey = _available.keys.first;
        _available.remove(oldestKey)?.dispose();
      }
    }
  }
}
