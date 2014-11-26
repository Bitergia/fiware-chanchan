'use strict';

describe('chanchanApp.version module', function() {
  beforeEach(module('chanchanApp.version'));

  describe('version service', function() {
    it('should return current version', inject(function(version) {
      expect(version).toEqual('0.1');
    }));
  });
});
