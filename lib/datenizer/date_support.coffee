class DateSupport
  constructor: (@current = new Date) ->
    # ignore time
    @current = new Date(@current.getFullYear(), @current.getMonth(), @current.getDate())

  toDate: ->
    @current

  toString: ->
    @current.toString()

  equals: (otherDate) ->
    @current.toString() == new DateSupport(otherDate).toString()

  isLeapYear: ->
    year = @current.getFullYear()
    ((0 == year % 4) && (0 != year % 100)) or (0 == year)

  beginningOfMonth: ->
    new Date @current.getFullYear(), @current.getMonth()

  endOfMonth: ->
    for n in [31..28]
      date = new Date @current.getFullYear(), @current.getMonth(), n
      break if date.getMonth() is @current.getMonth()

    date

  daysInMonth: ->
    [31, (if @isLeapYear() then 29 else 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][@current.getMonth()]

  dayInMiliseconds: ->
    24 * 60 * 60 * 1000

  dateInMiliseconds: ->
    Date.parse(@current.toString())

  daysAgo: (n) ->
    daysInMiliseconds = n * @dayInMiliseconds()
    new Date(@dateInMiliseconds() - daysInMiliseconds)

  daysFromNow: (n) ->
    daysInMiliseconds = n * @dayInMiliseconds()
    new Date(@dateInMiliseconds() + daysInMiliseconds)

  isToday: ->
    new DateSupport(@current).equals(new Date)
