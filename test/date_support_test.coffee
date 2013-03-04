{DateSupport} = require("../src/datenizer/date_support")

year = new Date().getFullYear()
month = new Date().getMonth()
day   = new Date().getDate()

describe "#constructor", ->
  removeTime = (date) ->
    date = new Date(date.getFullYear(), date.getMonth(), date.getDate())

  context "with no arguments", ->
    today = new Date(year, month, day)
    dateSupport = new DateSupport()

    it "sets current property to current date (with no time)", ->
      dateSupport.toString().should.equal(today.toString())

  context "with one argument", ->
    date = "2012-1-3"

    context "when the argument is a Date", ->
      date = removeTime(new Date(date))
      dateSupport = new DateSupport(date)

      it "sets current property to use the given date (with no time)", ->
        dateSupport.toString().should.equal(date.toString())

    context "when the argument is not a date", ->
      dateSupport = new DateSupport(date)

      it "delegates the argument to javascript's new Date and set current property with its return", ->
        dateSupport.toString().should.equal(date.toString())

  context "with two arguments", ->
    [arg1, arg2] = [2012, 8]
    date = removeTime(new Date(arg1, arg2))
    dateSupport = new DateSupport(arg1, arg2)

    it "delegates the arguments to javascript's new Date and set current property with its return", ->
      dateSupport.toString().should.equal(date.toString())

  context "with three arguments", ->
    [arg1, arg2, arg3] = [2012, 8, 4]
    date = removeTime(new Date(arg1, arg2))
    dateSupport = new DateSupport(arg1, arg2)

    it "delegates the arguments to javascript's new Date and set current property with its return", ->
      dateSupport.toString().should.equal(date.toString())

describe "#beginningOfMonth", ->
  it "returns the first day of the given month and year", ->
    dateSupport = new DateSupport()
    beginningOfMonth = dateSupport.beginningOfMonth().toString()
    firstOfThisMonth = new Date(year, month, 1)

    beginningOfMonth.should.equal(firstOfThisMonth.toString())

describe ".parse", ->

  context "when passing only a year", ->

    # context "and year is earlier than 2000", ->
    #   date = new Date(1987, month, day).toString()

    #   it "parses '%Y' into a four digits year", ->
    #     parsedDate = DateSupport.parse("1987", "%Y").toString()
    #     parsedDate.should.equal(date)

    #   it "parses '%y' into a two digits year", ->
    #     parsedDate = DateSupport.parse("87", "%y").toString()
    #     parsedDate.should.equal(date)

    context "and year is 2000 or later", ->
      date = new Date(2012, month, day).toString()
      
      it "parses '%Y' into a four digits year", ->
        parsedDate = DateSupport.parse("2012", "%Y").toString()
        parsedDate.should.equal(date)

      it "parses '%y' into a two digits year", ->
        parsedDate = DateSupport.parse("12", "%y").toString()
        parsedDate.should.equal(date)

  context "when passing only a month", ->

    context "and month is a number below 10", ->
      date = new Date(year, 7, day).toString()

      it "parses '%m' into a zero-padded month", ->
        parsedDate = DateSupport.parse("08", "%m").toString()
        parsedDate.should.equal(date)

      it "parses '%_m' into a blank-padded month", ->
        parsedDate = DateSupport.parse(" 8", "%_m").toString()
        parsedDate.should.equal(date)

      it "parses '%-m' into a no-padded month", ->
        parsedDate = DateSupport.parse("8", "%-m").toString()
        parsedDate.should.equal(date)

    context "and month is a number equal 10 or grater", ->
      date = new Date(year, 10, day).toString()

      it "parses '%m' into a zero-padded month", ->
        parsedDate = DateSupport.parse("11", "%m").toString()
        parsedDate.should.equal(date)

      it "parses '%_m' into a blank-padded month", ->
        parsedDate = DateSupport.parse("11", "%_m").toString()
        parsedDate.should.equal(date)

      it "parses '%-m' into a no-padded month", ->
        parsedDate = DateSupport.parse("11", "%-m").toString()
        parsedDate.should.equal(date)

    context "and month is a string", ->
      date = new Date(year, 7, day).toString()

      it "parses '%B' into a full month name", ->
        parsedDate = DateSupport.parse("August", "%B").toString()
        parsedDate.should.equal(date)

      it "parses '%^B' into a uppercased full month name", ->
        parsedDate = DateSupport.parse("AUGUST", "%^B").toString()
        parsedDate.should.equal(date)

      it "parses '%b' into a abbreviated month name", ->
        parsedDate = DateSupport.parse("aug", "%b").toString()
        parsedDate.should.equal(date)

      it "parses '%^b' into a uppercased abbreviated month name", ->
        parsedDate = DateSupport.parse("AUG", "%^b").toString()
        parsedDate.should.equal(date)

      it "parses '%h' into a abbreviated month name", ->
        parsedDate = DateSupport.parse("aug", "%h").toString()
        parsedDate.should.equal(date)

  context "when passing only a day", ->

    context "and day is a number below 10", ->
      date = new Date(year, month, 8).toString()

      it "parses '%d' into a zero-padded day of the month", ->
        parsedDate = DateSupport.parse("08", "%d").toString()
        parsedDate.should.equal(date)

      it "parses '%-d' into a no-padded day of the month", ->
        parsedDate = DateSupport.parse("8", "%-d").toString()
        parsedDate.should.equal(date)

      it "parses '%e' into a blank-padded day of the month", ->
        parsedDate = DateSupport.parse(" 8", "%e").toString()
        parsedDate.should.equal(date)

    context "and day is a number equal 10 or grater", ->
      date = new Date(year, month, 22).toString()

      it "parses '%d' into a zero-padded day of the month", ->
        parsedDate = DateSupport.parse("22", "%d").toString()
        parsedDate.should.equal(date)

      it "parses '%-d' into a no-padded day of the month", ->
        parsedDate = DateSupport.parse("22", "%-d").toString()
        parsedDate.should.equal(date)

      it "parses '%e' into a blank-padded day of the month", ->
        parsedDate = DateSupport.parse("22", "%e").toString()
        parsedDate.should.equal(date)

  context "when passing only day and month", ->
    date = new Date(year, 9, 2).toString()

    it "parses '%^b %d' into a white-space-separated date", ->
      parsedDate = DateSupport.parse("OCT 02", "%^b %d").toString()
      parsedDate.should.equal(date)

  context "when passing a full date", ->
    date = new Date(2010, 5, 8).toString()

    it "parses '%Y-%m-%d' into a dash-separated date", ->
      parsedDate = DateSupport.parse("2010-06-08", "%Y-%m-%d").toString()
      parsedDate.should.equal(date)

    it "parses '%-d/%-m/%y' into a slash-separated date", ->
      parsedDate = DateSupport.parse("8/6/10", "%-d/%-m/%y").toString()
      parsedDate.should.equal(date)

    it "parses '%e/%_m/%y' into a blank-padded slash-separated date", ->
      parsedDate = DateSupport.parse(" 8/ 6/10", "%e/%_m/%y").toString()
      parsedDate.should.equal(date)

    it "parses '%B %d, %Y' into a white-space-and-comma-separated date", ->
      parsedDate = DateSupport.parse("June 08, 2010", "%B %d, %Y").toString()
      parsedDate.should.equal(date)

    it "parses 'asd%Yqwe%d zxc%m' into a custom-characters-separated date", ->
      parsedDate = DateSupport.parse("asd2010qwe08 zxc06", "asd%Yqwe%d zxc%m").toString()
      parsedDate.should.equal(date)