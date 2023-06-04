module timecache

import time

fn init_cache() Cache[string, string] {
	mut cache := new_cache[string, string]()
	cache.put('key', 'value')
	return cache
}

fn test_access_timeout() {
	mut cache := init_cache()
	cache.access_timeout(2 * time.second)
	for _ in 0 .. 5 {
		assert cache.get('key')? == 'value'
		time.sleep(1 * time.second)
	}
	time.sleep(2 * time.second)
	assert cache.def_get('key', '') == ''
}

fn test_write_timeout() {
	mut cache := init_cache()
	cache.write_timeout(6 * time.second)
	for _ in 0 .. 5 {
		assert cache.get('key')? == 'value'
		time.sleep(1 * time.second)
	}
	time.sleep(1 * time.second)
	assert cache.def_get('key', '') == ''
}

fn test_contains() {
	mut cache := init_cache()
	assert cache.contains('key')
	assert !cache.contains('nokey')
}
