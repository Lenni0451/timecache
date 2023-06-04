module timecache

import time

[noinit]
pub struct Cache[K, V] {
mut:
	access_timeout time.Duration = -1
	write_timeout  time.Duration = -1
	content        map[K]&TimedValue[V]
}

struct TimedValue[V] {
	val V
mut:
	access_time time.Time = time.now()
	write_time  time.Time = time.now()
}

// new_cache Create a new cache
pub fn new_cache[K, V]() Cache[K, V] {
	return Cache[K, V]{
		content: map[K]TimedValue[V]{}
	}
}

// access_timeout Remove entries which have not been accessed for the given timeout (in nanoseconds)
pub fn (mut c Cache[K, V]) access_timeout(timeout time.Duration) {
	c.access_timeout = timeout
}

// write_timeout Remove entries after the given timeout (in nanoseconds)
pub fn (mut c Cache[K, V]) write_timeout(timeout time.Duration) {
	c.write_timeout = timeout
}

// cleanup Remove entries which have reached their timeout
pub fn (mut c Cache[K, V]) cleanup() {
	now := time.now()
	if c.write_timeout >= 0 {
		for k, v in c.content {
			if now - v.write_time >= c.write_timeout {
				c.content.delete(k)
			}
		}
	}
	if c.access_timeout >= 0 {
		for k, v in c.content {
			if now - v.access_time >= c.access_timeout {
				c.content.delete(k)
			}
		}
	}
}

pub fn (c Cache[K, V]) str() string {
	return c.content.str()
}

// put Add an entry to the cache
pub fn (mut c Cache[K, V]) put(k K, v V) V {
	c.content[k] = &TimedValue[V]{
		val: v
	}
	c.cleanup()
	return v
}

// remove Remove an entry from the cache
pub fn (mut c Cache[K, V]) remove(k K) {
	c.cleanup()
	c.content.delete(k)
}

// get Get an option entry from the cache
pub fn (mut c Cache[K, V]) get(k K) ?V {
	c.cleanup()
	mut val := c.content[k] or { return none }
	val.access_time = time.now()
	return val.val
}

// def_get Get an entry from the cache, or return the default value
pub fn (mut c Cache[K, V]) def_get(k K, def V) V {
	c.cleanup()
	mut val := c.content[k] or { return def }
	val.access_time = time.now()
	return val.val
}

// contains Check if an entry is in the cache
pub fn (mut c Cache[K, V]) contains(k K) bool {
	c.cleanup()
	if _ := c.content[k] {
		return true
	} else {
		return false
	}
}
