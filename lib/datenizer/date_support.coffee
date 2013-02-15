class DateSupport
  constructor: (@current = new Date) ->

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

  daysAgo: (n) ->
    daysInMiliseconds = n * 24 * 60 * 60 * 1000
    dateInMiliseconds = Date.parse(@current.toString())
    new Date(dateInMiliseconds - daysInMiliseconds)
