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
    year = @current.getFullYear()
    month = @current.getMonth()
    day = @current.getDate() - n

    daysPerLoop = 28
    loopCount = if day is 0 then 1 else Math.ceil(-day / 28)

    for i in [1..loopCount]
      subtractDays = if day <= daysPerLoop then day else -daysPerLoop

      if subtractDays < 1
        month -= 1

        if month < 0
          year -= 1
          month = 11

        daysInMonth = new DateSupport(new Date(year, month)).daysInMonth()
        day = daysInMonth + subtractDays

    new Date(year, month, day)
