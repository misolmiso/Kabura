assert = require('chai').assert

suite 'sample test', ->
  test 'sample 1', ->
    assert.ok(true, "this is sample test")

suite 'sample test', ->
  test 'sample 2', ->
    assert.notOk(false, "this is sample test")

