class Calendar
  constructor: (@selectedDate = new Date) ->
    @currentDate = @selectedDate
    @element = jQuery("body").append("<div class='datenizer'></div>").children(".datenizer:last")
    @render()

  locale: ->
    jQuery.datenizer.currentLocale

  render: ->
    @element.empty()
    @renderMonthName()
    @renderTable()
    @renderDays()

    @element

  renderMonthName: ->
    month = @currentDate.getMonth()
    monthName = @locale().monthNames[month]
    year = @currentDate.getFullYear()
    @element.append("<h5 class='header month'>#{monthName} #{year}</h5>")

  renderTable: ->
    table = """
      <table class="calendar">
        <tr>
          <th>#{@locale().abbrDayNames[0]}</th>
          <th>#{@locale().abbrDayNames[1]}</th>
          <th>#{@locale().abbrDayNames[2]}</th>
          <th>#{@locale().abbrDayNames[3]}</th>
          <th>#{@locale().abbrDayNames[4]}</th>
          <th>#{@locale().abbrDayNames[5]}</th>
          <th>#{@locale().abbrDayNames[6]}</th>
        </tr>
      </table>
    """

    @element.append(table)

  renderDays: ->
    # calculate overflow
    startDate = new DateSupport(@currentDate).beginningOfMonth()
    totalDays = new DateSupport(@currentDate).endOfMonth().getDate()
    daysBefore = startDate.getDay()
    daysPerWeek = 7
    totalDaysShown = daysPerWeek * Math.ceil((totalDays + daysBefore) / daysPerWeek)
    daysAfter = totalDaysShown - (totalDays + daysBefore)

    for n in [0..totalDaysShown - 1]
      day = n - daysBefore + 1

      if day < 1
        day = new DateSupport(startDate).daysAgo(daysBefore - n).getDate()
      else if day > new DateSupport(startDate).daysInMonth()
        day = day - new DateSupport(startDate).daysInMonth()

      if n % daysPerWeek is 0
        @element.children(".calendar").append("<tr></tr>")

      @element.find(".calendar tr:last").append("<td>#{day}</td>")

    @element
