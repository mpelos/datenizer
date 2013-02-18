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
    @twitterBootstrapStyle()

    @element

  renderMonthName: ->
    month = @currentDate.getMonth()
    monthName = @locale().monthNames[month]
    year = @currentDate.getFullYear()
    @element.append("<h5 class='header month'>#{monthName} #{year}</h5>")

  renderTable: ->
    table = """
      <table class="calendar" style="text-align: center">
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
      daysInMonth = new DateSupport(startDate).daysInMonth()
      currentDate = new Date(startDate.getFullYear(), startDate.getMonth(), day)
      loopDate = currentDate

      if day < 1 or day > daysInMonth
        loopDate = if day < 1
                    new DateSupport(startDate).daysAgo(daysBefore - n)
                  else
                    new DateSupport(startDate).daysFromNow(n - daysBefore + 1)

      if n % daysPerWeek is 0
        @element.children(".calendar").append("<tr></tr>")

      classNames = "day "
      classNames += "other-month " if loopDate.getMonth() isnt startDate.getMonth()
      classNames += "today "       if new DateSupport(loopDate).isToday()
      classNames += "selected "    if new DateSupport(@selectedDate).equals(currentDate)

      @element.find(".calendar tr:last")
        .append("<td><a href='#' class='#{classNames}'>#{loopDate.getDate()}</a></td>")

    @element

  twitterBootstrapStyle: ->
    # style wrapper
    @element.addClass("dropdown-menu")
      .css
        minWidth: "auto"
        padding: "10px"
        position: "static"
      .show()

    # style header
    @element.find(".header").css
      margin: "0 0 5px 0"
      textAlign: "center"

    # style cells
    @element.find("th a, td a").css
      display: "inline-block"
      padding: "5px"

    @element.find(".other-month.day").addClass("muted")
    @element.find(".selected").addClass("btn btn-primary")
    @element.find("td a:not(.muted, .btn)").css("color", "rgb(51, 51, 51)")

    @element
