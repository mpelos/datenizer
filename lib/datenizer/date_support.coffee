class DateSupport
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

  format: (format, locale = {}) ->
    locale.monthNames ?= ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December']
    locale.abbrMonthNames ?= ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
        'Aug', 'Sep', 'Oct', 'Nov', 'Dec']

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

  toString: ->
    @current.toString()

  # protected

  dayInMiliseconds = ->
    24 * 60 * 60 * 1000

  zeroPadNumber = (n) ->
    if n < 10 then '0' + n else n

  blankPadNumber = (n) ->
    if n < 10 then ' ' + n else n
