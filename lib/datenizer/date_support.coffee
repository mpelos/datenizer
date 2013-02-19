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
