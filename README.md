# timecache
A temporary cache with configurable read/write timeout written in V.

## Usage
````vlang
import timecache
import time

fn main() {
    // Create a new cache with string keys and values
    mut cache := timecache.new_cache[string, string]()

    // Set the timeout after which a key will be removed from the cache
    // The access_timeout is reset every time a key is accessed
    cache.access_timeout(1 * time.second)
    // The write_timeout is reset every time a key is written to
    cache.write_timeout(1 * time.second)
    // If the time since the last access or write exceeds the timeout, the key is removed

    // Put a new value into the cache
    cache.put('key', 'value')
    // Get a value from the cache
    mut val := cache.get('key') or { 'Not in cache' }
    // Get a value from the cache, or the given default value
    val = cache.def_get('key', 'default value')
    // Remove a value from the cache
    cache.remove('key')
    // Check if the cache contains a key
    if cache.contains('key') {
        println('Key is in cache')
    }

    // Cleanup the cache and remove all expired keys
    // Calling this function manually is not necessary, as it is called automatically
    cache.cleanup()
}
````
