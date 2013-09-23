tat = require('./scenarios/testingATester')

expect = require('chai').expect

describe 'testing a tester', ->
  it 'should be illegal', ->
    expect(tat.testingATester()).to.equal 'it should not be legal'
