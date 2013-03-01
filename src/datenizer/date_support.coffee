class DateSupport
  # Formats:
  # %Y - Year (4 digits)
  # %y - year (00..99)
  # %m - Month of the year, zero-padded (01..12)
  # %_m  blank-padded ( 1..12)
  # %-m  no-padded (1..12)
  # %B - The full month name ("January")
  # %^B  uppercased ("JANUARY")
  # %b - The abbreviated month name ("Jan")
  # %^b  uppercased ("JAN")
  # %h - Equivalent to %b
  # %d - Day of the month, zero-padded (01..31)
  # %-d  no-padded (1..31)
  # %e - Day of the month, blank-padded ( 1..31)

  constructor: ->
    @current = switch arguments.length
                 when 0
                   new Date
                 when 1
                   if arguments[0] instanceof Date then arguments[0] else new Date(arguments[0])
                 when 2
                   new Date(arguments[0], arguments[1])
                 when 3
                   new Date(arguments[0], arguments[1], arguments[2])

    # ignores the time
    @current = new Date(@current.getFullYear(), @current.getMonth(), @current.getDate())

  # class methods
  @defaultLocale:
    monthNames: ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December']
    abbrMonthNames: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
        'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

  @parse = (formatted, format) ->
    year = new Date().getFullYear()
    month = new Date().getMonth()
    day = new Date().getDate()

    parseMonthName = (index, abbr = false) ->
      monthNames = if abbr
                     DateSupport.defaultLocale.abbrMonthNames
                   else
                     DateSupport.defaultLocale.monthNames

      for monthName, monthIndex in monthNames
        if formatted.slice(index).toLowerCase().indexOf(monthName.toLowerCase()) isnt -1
          return monthIndex

    for letter, index in format
      if letter is "%"
        switch format[index + 1]
          when "Y"
            year = formatted.slice(index, index + 4)
            formatted = formatted.replace year, "%Y"
          when "y"
            year = formatted.slice(index, index + 2)
            formatted = formatted.replace year, "%y"
            year = "20#{year}"
          when "m"
            month = formatted.slice(index, index + 2)
            formatted = formatted.replace month, "%m"
            month = parseInt(month, 10) - 1
          when "B"
            month = parseMonthName(index)
            formatted = formatted.replace DateSupport.defaultLocale.monthNames[month], "%B"
          when "b", "h"
            month = parseMonthName(index, true)
            formatted = formatted.replace DateSupport.defaultLocale.abbrMonthNames[month], "%b"
          when "d"
            day = formatted.slice(index, index + 2)
            formatted = formatted.replace day, "%d"
          when "e"
            day = formatted.slice(index, index + 2)
            formatted = formatted.replace day, "%e"
            day = parseInt(day)

        switch format.slice(index + 1, index + 3)
          when "_m"
            month = formatted.slice(index, index + 2)
            formatted = formatted.replace month, "%_m"
            month = parseInt(month) - 1
          when "-m"
            month = formatted.slice(index, index + 2)
            month = month[0] if 10 > parseInt(month) <= 12
            formatted = formatted.replace month, "%-m"
            month = parseInt(month) - 1
          when "^B"
            month = parseMonthName(index)
            formatted = formatted.replace DateSupport.defaultLocale.monthNames[month].toUpperCase(), "%B"
          when "^b"
            month = parseMonthName(index, true)
            formatted = formatted.replace DateSupport.defaultLocale.abbrMonthNames[month], "%^b"
          when "-d"
            day = formatted.slice(index, index + 2)
            day = day[0] if 10 > parseInt(day) <= 31
            formatted = formatted.replace day, "%-d"
            day = parseInt(day)

    new DateSupport year, month, day

  # instance methods
  beginningOfMonth: ->
    new DateSupport @current.getFullYear(), @current.getMonth()

  daysAgo: (n) ->
    daysInMiliseconds = n * dayInMiliseconds()
    new DateSupport @dateInMiliseconds() - daysInMiliseconds

  daysFromNow: (n) ->
    daysInMiliseconds = n * dayInMiliseconds()
    new DateSupport @dateInMiliseconds() + daysInMiliseconds

  daysInMonth: ->
    [31, (if @isLeapYear() then 29 else 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][@current.getMonth()]

  dateInMiliseconds: ->
    Date.parse(@current.toString())

  endOfMonth: ->
    for n in [31..28]
      date = new DateSupport @current.getFullYear(), @current.getMonth(), n
      break if date.getMonth() is @current.getMonth()

    date

  format: (format, locale = DateSupport.defaultLocale) ->
    # %Y - Year (4 digits)
    # %y - year (00..99)
    # %m - Month of the year, zero-padded (01..12)
    # %_m  blank-padded ( 1..12)
    # %-m  no-padded (1..12)
    # %B - The full month name ("January")
    # %^B  uppercased ("JANUARY")
    # %b - The abbreviated month name ("Jan")
    # %^b  uppercased ("JAN")
    # %h - Equivalent to %b
    # %d - Day of the month, zero-padded (01..31)
    # %-d  no-padded (1..31)
    # %e - Day of the month, blank-padded ( 1..31)

    formatted = format
    formatted = formatted.replace /%Y/g, @getFullYear()
    formatted = formatted.replace /%y/g, @getFullYear().toString()[2..3]
    formatted = formatted.replace /%m/g, zeroPadNumber(@getMonth() + 1)
    formatted = formatted.replace /%_m/g, blankPadNumber(@getMonth() + 1)
    formatted = formatted.replace /%-m/g, @getMonth() + 1
    formatted = formatted.replace /%B/g, locale.monthNames[@getMonth()]
    formatted = formatted.replace /%\^B/g, locale.monthNames[@getMonth()].toUpperCase()
    formatted = formatted.replace /%b/g, locale.abbrMonthNames[@getMonth()]
    formatted = formatted.replace /%\^b/g, locale.abbrMonthNames[@getMonth()].toUpperCase()
    formatted = formatted.replace /%d/g, zeroPadNumber(@getDate())
    formatted = formatted.replace /%-d/g, @getDate()
    formatted = formatted.replace /%e/g, blankPadNumber(@getDate())

  getDay: ->
    @current.getDay()

  getDate: ->
    @current.getDate()

  getMonth: ->
    @current.getMonth()

  getFullYear: ->
    @current.getFullYear()

  isEqual: (otherDate) ->
    @current.toString() == new DateSupport(otherDate).toString()

  isLeapYear: ->
    year = @current.getFullYear()
    ((0 == year % 4) && (0 != year % 100)) or (0 == year)

  isToday: ->
    @isEqual new Date

  monthsAgo: (n) ->
    daysInMiliseconds = n * @daysInMonth() * dayInMiliseconds()
    new DateSupport @dateInMiliseconds() - daysInMiliseconds

  monthsFromNow: (n) ->
    daysInMiliseconds = n * @daysInMonth() * dayInMiliseconds()
    new DateSupport @dateInMiliseconds() + daysInMiliseconds

  nextMonth: ->
    @monthsFromNow(1)

  previousMonth: ->
    @monthsAgo(1)

  toISOFormat: ->
    @format("%Y-%m-%d")

  toString: ->
    @current.toString()

  # protected

  dayInMiliseconds = ->
    24 * 60 * 60 * 1000

  zeroPadNumber = (n) ->
    if n < 10 then '0' + n else n

  blankPadNumber = (n) ->
    if n < 10 then ' ' + n else n

if exports? then exports.DateSupport = DateSupport