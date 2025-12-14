import 'package:billing_app/services/cache_service.dart';
import 'package:flutter/foundation.dart';

/// Manager class for cache operations and invalidation strategies
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final CacheService _cacheService = CacheService();

  /// Invalidate cache for specific endpoints when data is modified
  Future<void> invalidateRelatedCache(String endpoint) async {
    if (kDebugMode) {
      print('Invalidating related cache for: $endpoint');
    }

    // Define cache invalidation patterns
    final invalidationMap = {
      'product': ['product', 'category', 'all-category'],
      'category': ['category', 'all-category', 'product'],
      'store': ['store', 'all-store', 'path-store', 'collection-store'],
      'path': ['path', 'all-path', 'collection-path', 'all-collection-path'],
      'user': ['user', 'profile', 'line-user-name'],
      'bill': ['bill-entry', 'user-bill-entry', 'bill-details', 'user-bill-details', 'total-bill'],
      'order': ['order-list', 'order-delivery', 'order-received', 'pending-order'],
      'stock': ['stock', 'admin-stock', 'user-stock', 'stock-history'],
    };

    // Find related endpoints to invalidate
    for (final key in invalidationMap.keys) {
      if (endpoint.contains(key)) {
        for (final relatedEndpoint in invalidationMap[key]!) {
          await _cacheService.invalidateCache(relatedEndpoint);
        }
        break;
      }
    }
  }

  /// Clear cache for user-specific data (useful on logout)
  Future<void> clearUserCache() async {
    if (kDebugMode) {
      print('Clearing user-specific cache');
    }
    
    // List of user-specific endpoints
    final userEndpoints = [
      'profile',
      'user-bill-entry',
      'user-bill-details',
      'user-individual-bill',
      'user-line',
      'user-stock',
      'order-list',
      'pending-order',
      'collection-path',
      'collection-store',
    ];

    for (final endpoint in userEndpoints) {
      await _cacheService.invalidateCache(endpoint);
    }
  }

  /// Pre-warm cache with critical data (call after login)
  Future<void> preWarmCache() async {
    if (kDebugMode) {
      print('Pre-warming cache with critical data');
    }
    // This can be called after successful login to pre-load critical data
    // The actual API calls will be made by the controllers, and responses will be cached
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStatistics() async {
    return await _cacheService.getCacheInfo();
  }

  /// Clear all cache (use with caution)
  Future<void> clearAllCache() async {
    await _cacheService.clearAllCache();
  }
}
