{DateSupport} = require("../src/datenizer/date_support")

year = new Date().getFullYear()
month = new Date().getMonth()
day   = new Date().getDate()

describe "DateSupport", ->
  # class methods
  describe ".ignoresTime()", ->
    it "returns the date ignoring the time", ->
      dateWithTime = new Date
      dateWithoutTime = new Date(dateWithTime.getFullYear(), dateWithTime.getMonth(), dateWithTime.getDate())
      DateSupport.ignoresTime(dateWithTime).toString().should.equal dateWithoutTime.toString()

  describe ".parse()", ->
    context "when passing only a year", ->
      context "and year is earlier than 2000", ->
        date = new Date(1987, month, day).toString()

        it "parses '%Y' into a four digits year", ->
          parsedDate = DateSupport.parse("1987", "%Y").toString()
          parsedDate.should.equal(date)

        it "parses '%y' into a two digits year", ->
          parsedDate = DateSupport.parse("87", "%y").toString()
          parsedDate.should.equal(date)

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

  # instance methods
  describe "#constructor()", ->
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

  describe "#beginningOfMonth()", ->
    it "returns the first day of the given month and year", ->
      dateSupport = new DateSupport()
      beginningOfMonth = dateSupport.beginningOfMonth().toString()
      firstOfThisMonth = new Date(year, month, 1).toString()

      beginningOfMonth.should.equal firstOfThisMonth

  describe "#dateInMiliseconds()", ->
    it "returns the current dateSupport date (without time) in miliseconds", ->
      dateSupport = new DateSupport()
      dateInMiliseconds = dateSupport.dateInMiliseconds().toString()
      todayInMiliseconds = Date.parse(new Date(year, month, day)).toString()

      dateInMiliseconds.should.equal todayInMiliseconds

  describe "#daysAgo()", ->
    it "returns a date a numbers of days earlier than current date equal to the given argument", ->
      dateSupport = new DateSupport()
      daysAgo = dateSupport.daysAgo(2).toString()
      twoDaysAgo = new Date(year, month, day - 2).toString()

      daysAgo.should.equal twoDaysAgo

  describe "#daysFromNow()", ->
    it "returns a date a number of days from now equal to the given argument", ->
      dateSupport = new DateSupport()
      daysFromNow = dateSupport.daysFromNow(4).toString()
      fourDaysFromNow = new Date(year, month, day + 4)

      daysFromNow.should.equal fourDaysFromNow.toString()

  describe "#daysInMonth()", ->
    it "returns the number of days the current dateSupport month has", ->
      dateSupport = new DateSupport(2013, 7)
      dateSupport.daysInMonth().should.equal 31

  describe "#endOfMonth()", ->
    it "returns the correct number of days of the current dateSupport month when the month has 31 days", ->
      dateSupport = new DateSupport(year, 0)
      endOfMonth = dateSupport.endOfMonth().toString()
      lastDayOfJan = new Date(year, 0, 31).toString()
      endOfMonth.should.equal lastDayOfJan

    it "returns the correct number of days of the current dateSupport month when the month has 30 days", ->
      dateSupport = new DateSupport(year, 3)
      endOfMonth = dateSupport.endOfMonth().toString()
      lastDayOfJan = new Date(year, 3, 30).toString()
      endOfMonth.should.equal lastDayOfJan

    it "returns the correct number of days of the current dateSupport month when it is Febuary", ->
      dateSupport = new DateSupport(2013, 1)
      endOfMonth = dateSupport.endOfMonth().toString()
      lastDayOfJan = new Date(2013, 1, 28).toString()
      endOfMonth.should.equal lastDayOfJan

      dateSupport = new DateSupport(2012, 1)
      endOfMonth = dateSupport.endOfMonth().toString()
      lastDayOfJan = new Date(2012, 1, 29).toString()
      endOfMonth.should.equal lastDayOfJan

  describe "#format()", ->
    dateSupport = new DateSupport(2000, 0, 1)

    context "when there is %Y in the string param", ->
      it "converts %Y to current date's year (4 digits)", ->
        dateSupport.format("%Y").should.be.equal("2000")

    context "when there is %y in the string param", ->
      it "converts %y to current date's year (2 digits)", ->
        dateSupport.format("%y").should.be.equal("00")

    context "when there is %m in the string param", ->
      it "converts %m to current date's month number zero-padded", ->
        dateSupport.format("%m").should.be.equal("01")

    context "when there is %_m in the string param", ->
      it "converts %_m to current date's month number blank-padded", ->
        dateSupport.format("%_m").should.be.equal(" 1")

    context "when there is %-m in the string param", ->
      it "converts %-m to current date's month number no-padded", ->
        dateSupport.format("%-m").should.be.equal("1")

    context "when there is %B in the string param", ->
      it "converts %B to current date's month name", ->
        dateSupport.format("%B").should.be.equal("January")

    context "when there is %^B in the string param", ->
      it "converts %^B to current date's uppercased month name", ->
        dateSupport.format("%^B").should.be.equal("JANUARY")

    context "when there is %b in the string param", ->
      it "converts %b to current date's abbreviated month name", ->
        dateSupport.format("%b").should.be.equal("Jan")

    context "when there is %^b in the string param", ->
      it "converts %^b to current date's uppercased abbreviated month name", ->
        dateSupport.format("%^b").should.be.equal("JAN")

    context "when there is %d in the string param", ->
      it "converts %d to current date's day of the month zero-padded", ->
        dateSupport.format("%d").should.be.equal("01")

    context "when there is %-d in the string param", ->
      it "converts %-d to current date's day of the month no-padded", ->
        dateSupport.format("%-d").should.be.equal("1")

    context "when there is %e in the string param", ->
      it "converts %e to current date's day of the month blank-padded", ->
        dateSupport.format("%e").should.be.equal(" 1")

  describe "#getDate()", ->
    it "delegates to native Date class", ->
      (new DateSupport).getDate().should.equal (new Date).getDate()

  describe "#getDay()", ->
    it "delegates to native Date class", ->
      (new DateSupport).getDay().should.equal (new Date).getDay()

  describe "#getMonth()", ->
    it "delegates to native Date class", ->
      (new DateSupport).getMonth().should.equal (new Date).getMonth()

  describe "#getFullYear()", ->
    it "delegates to native Date class", ->
      (new DateSupport).getFullYear().should.equal (new Date).getFullYear()

  describe "#isEqual()", ->
    date = new Date(2013, 10, 10)

    context "when the current date is equal to param date", ->
      it "returns true", ->
        dateSupport = new DateSupport(2013, 10, 10)
        dateSupport.isEqual(date).should.be.true

    context "when the current date is different to param date", ->
      it "returns false", ->
        dateSupport = new DateSupport(2012, 10, 10)
        dateSupport.isEqual(date).should.be.false

  describe "#isLeapYear()", ->
    context "when the current date is leap year", ->
      it "returns true", ->
        new DateSupport(2008, 1, 1).isLeapYear().should.be.true

    context "when the current date isn't leap year", ->
      it "returns false", ->
        new DateSupport(2010, 1, 1).isLeapYear().should.be.false

  describe "#isToday()", ->
    context "when the current date is today", ->
      it "returns true", ->
        new DateSupport(new Date).isToday().should.be.true

    context "when the current date isn't today", ->
      it "returns false", ->
        new DateSupport(2012, 11, 25).isToday().should.be.false

  describe "#monthsAgo()", ->
    it "calculates the date subtracting da param number to the current date", ->
      dateSupport = new DateSupport(1999, 11, 31)
      dateSupport.monthsAgo(13).getMonth().should.equal(10)

  describe "#monthsFromNow()", ->
    it "calculates the date adding da param number to the current date", ->
      dateSupport = new DateSupport(1999, 11, 31)
      dateSupport.monthsFromNow(13).getMonth().should.equal(1)

  describe "#nextMonth()", ->
    it "returns current date next month", ->
      dateSupport = new DateSupport(2012, 3, 3)
      dateSupport.nextMonth().getMonth().should.equal(4)

  describe "#previousMonth()", ->
    it "returns current date previous month", ->
      dateSupport = new DateSupport(2012, 3, 3)
      dateSupport.previousMonth().getMonth().should.equal(2)

  describe "#toISOFormat()", ->
    it "formats the current date to ISO 8601 format", ->
      dateSupport = new DateSupport(2011, 10, 11)
      dateSupport.toISOFormat().should.equal("2011-11-11")

  describe "#toString()", ->
    it "delegates to native Date class", ->
      date = DateSupport.ignoresTime(new Date)
      (new DateSupport).toString().should.equal date.toString()
