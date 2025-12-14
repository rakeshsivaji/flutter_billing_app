import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service to handle caching of API responses
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  static const String _cacheBoxName = 'api_cache';
  static const String _cacheMetadataBoxName = 'cache_metadata';
  Box? _cacheBox;
  Box? _metadataBox;
  bool _isInitialized = false;

  /// Cache expiration time in hours (default: 24 hours)
  int cacheExpirationHours = 24;

  /// Initialize cache service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Hive.initFlutter();
      _cacheBox = await Hive.openBox(_cacheBoxName);
      _metadataBox = await Hive.openBox(_cacheMetadataBoxName);
      _isInitialized = true;
      
      // Clean expired cache entries
      _cleanExpiredCache();
      
      if (kDebugMode) {
        print('CacheService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing CacheService: $e');
      }
    }
  }

  /// Get cached response for a URL
  Future<Map<String, dynamic>?> getCachedResponse(String url, {Map<String, String>? headers}) async {
    if (!_isInitialized || _cacheBox == null) {
      await initialize();
    }

    try {
      final cacheKey = _generateCacheKey(url, headers);
      final metadata = _metadataBox?.get(cacheKey) as Map?;
      
      if (metadata == null) return null;

      // Check if cache is expired
      final cachedTime = DateTime.parse(metadata['timestamp'] as String);
      final expirationTime = cachedTime.add(Duration(hours: cacheExpirationHours));
      
      if (DateTime.now().isAfter(expirationTime)) {
        // Cache expired, remove it
        await _cacheBox?.delete(cacheKey);
        await _metadataBox?.delete(cacheKey);
        return null;
      }

      final cachedData = _cacheBox?.get(cacheKey);
      if (cachedData != null) {
        if (kDebugMode) {
          print('Cache hit for: $url');
        }
        return json.decode(cachedData as String) as Map<String, dynamic>;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error reading cache: $e');
      }
    }
    
    return null;
  }

  /// Cache API response
  Future<void> cacheResponse(String url, Map<String, dynamic> response, {Map<String, String>? headers}) async {
    if (!_isInitialized || _cacheBox == null) {
      await initialize();
    }

    try {
      final cacheKey = _generateCacheKey(url, headers);
      final responseJson = json.encode(response);
      
      // Store response
      await _cacheBox?.put(cacheKey, responseJson);
      
      // Store metadata (timestamp, url)
      await _metadataBox?.put(cacheKey, {
        'timestamp': DateTime.now().toIso8601String(),
        'url': url,
        'headers': headers?.toString() ?? '',
      });
      
      if (kDebugMode) {
        print('Cached response for: $url');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error caching response: $e');
      }
    }
  }

  /// Invalidate cache for a specific URL
  Future<void> invalidateCache(String url, {Map<String, String>? headers}) async {
    if (!_isInitialized) return;

    try {
      final cacheKey = _generateCacheKey(url, headers);
      await _cacheBox?.delete(cacheKey);
      await _metadataBox?.delete(cacheKey);
      
      if (kDebugMode) {
        print('Cache invalidated for: $url');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error invalidating cache: $e');
      }
    }
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    if (!_isInitialized) return;

    try {
      await _cacheBox?.clear();
      await _metadataBox?.clear();
      
      if (kDebugMode) {
        print('All cache cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing cache: $e');
      }
    }
  }

  /// Clear expired cache entries
  void _cleanExpiredCache() {
    if (!_isInitialized || _metadataBox == null) return;

    try {
      final keys = _metadataBox!.keys.toList();
      final now = DateTime.now();
      
      for (final key in keys) {
        final metadata = _metadataBox!.get(key) as Map?;
        if (metadata != null) {
          final cachedTime = DateTime.parse(metadata['timestamp'] as String);
          final expirationTime = cachedTime.add(Duration(hours: cacheExpirationHours));
          
          if (now.isAfter(expirationTime)) {
            _cacheBox?.delete(key);
            _metadataBox?.delete(key);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cleaning expired cache: $e');
      }
    }
  }

  /// Generate cache key from URL and headers
  String _generateCacheKey(String url, Map<String, String>? headers) {
    // Create a unique key based on URL and relevant headers
    final keyParts = [url];
    
    // Include authorization header if present (for user-specific cache)
    if (headers != null && headers.containsKey('Authorization')) {
      keyParts.add(headers['Authorization']!);
    }
    
    return keyParts.join('|');
  }

  /// Get cache size information
  Future<Map<String, dynamic>> getCacheInfo() async {
    if (!_isInitialized || _cacheBox == null || _metadataBox == null) {
      return {'count': 0, 'size': 0};
    }

    try {
      final count = _cacheBox!.length;
      int totalSize = 0;
      
      for (final key in _cacheBox!.keys) {
        final value = _cacheBox!.get(key);
        if (value is String) {
          totalSize += value.length;
        }
      }
      
      return {
        'count': count,
        'size': totalSize,
        'sizeInMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      return {'count': 0, 'size': 0, 'error': e.toString()};
    }
  }
}
