class Calendar
  constructor: (@selectedDate = new DateSupport) ->
    @currentDate = @selectedDate
    @element = jQuery("body").append("<div class='datenizer'></div>").children(".datenizer:last")
    @render()
    @insertEventListeners()

  locale: ->
    jQuery.datenizer.currentLocale

  render: ->
    @element.empty()
    @renderTable()
    @renderDays()
    @twitterBootstrapStyle()

    @element

  renderTable: ->
    monthName = @locale().monthNames[@currentDate.getMonth()]
    year = @currentDate.getFullYear()

    table = """
      <table class="calendar" style="text-align: center">
        <thead>
          <tr>
            <th><a href="#" class="previous month">«</a></th>
            <th colspan="5" class="month"><h5>#{monthName} #{year}</h5></th>
            <th><a href="#" class="next month">»</a></th>
          </tr>

          <tr>
            <th>#{@locale().abbrDayNames[0]}</th>
            <th>#{@locale().abbrDayNames[1]}</th>
            <th>#{@locale().abbrDayNames[2]}</th>
            <th>#{@locale().abbrDayNames[3]}</th>
            <th>#{@locale().abbrDayNames[4]}</th>
            <th>#{@locale().abbrDayNames[5]}</th>
            <th>#{@locale().abbrDayNames[6]}</th>
          </tr>
        </thead>

        <tbody></tbody>
      </table>
    """

    @element.append(table)

  renderDays: ->
    # calculate overflow
    startDate = @currentDate.beginningOfMonth()
    totalDays = @currentDate.endOfMonth().getDate()
    daysBefore = startDate.getDay()
    daysPerWeek = 7
    totalDaysShown = daysPerWeek * Math.ceil((totalDays + daysBefore) / daysPerWeek)
    daysAfter = totalDaysShown - (totalDays + daysBefore)

    for n in [0..totalDaysShown - 1]
      day = n - daysBefore + 1
      daysInMonth = startDate.daysInMonth()
      currentDate = new DateSupport(startDate.getFullYear(), startDate.getMonth(), day)
      loopDate = currentDate

      if day < 1 or day > daysInMonth
        loopDate = if day < 1
                    startDate.daysAgo(daysBefore - n)
                  else
                    startDate.daysFromNow(n - daysBefore + 1)

      if n % daysPerWeek is 0
        @element.children(".calendar").append("<tr></tr>")

      classNames = "day"
      classNames += " other-month" if loopDate.getMonth() isnt startDate.getMonth()
      classNames += " today"       if loopDate.isToday()
      classNames += " selected"    if @selectedDate.isEqual(currentDate)

      @element.find(".calendar tbody tr:last")
        .append("<td><a href='#' class='#{classNames}' data-date='#{loopDate.dateInMiliseconds()}'>#{loopDate.getDate()}</a></td>")

    @element

  twitterBootstrapStyle: ->
    # style wrapper
    @element.addClass("dropdown-menu")
      .css
        minWidth: "auto"
        padding: "10px"
      .show()

    # style header
    @element.find(".calendar tr:first th").css
      marginBottom: "6px"
      textAlign: "center"

    @element.find(".calendar .month h5").css("margin", 0)

    # style cells
    @element.find("th a, td a").css
      display: "inline-block"
      padding: "5px"

    @element.find(".other-month.day").addClass("muted")
    @element.find(".selected").addClass("btn btn-primary")
    @element.find("th a, td a:not(.muted, .btn)").css("color", "rgb(51, 51, 51)")

    @element

  insertEventListeners: ->
    @element.on "click", "a", (e) ->
      e.preventDefault()

    @element.on "click", ".previous", this, (e) ->
      calendar = e.data
      calendar.currentDate = calendar.currentDate.previousMonth()
      calendar.render()

    @element.on "click", ".next", this, (e) ->
      calendar = e.data
      calendar.currentDate = calendar.currentDate.nextMonth()
      calendar.render()

    @element.on "click", ".day", this, (e) ->
      calendar = e.data
      selectedDate = jQuery(e.currentTarget).data("date")
      calendar.selectedDate = new DateSupport(selectedDate)
      calendar.currentDate = calendar.selectedDate
      calendar.render()
