(($) ->
  $.datenizer =
    defaults:
      format: "%Y-%m-%d"
      submitISOFormat: false

    locale: {}

    setLocale: (locale) ->
      @currentLocale = @locale[locale]

  defaultLocale =
    monthNames: ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December']
    abbrMonthNames: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
      'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday']
    abbrDayNames: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']

  $.datenizer.locale["en"] = defaultLocale
  $.datenizer.setLocale("en")

  $.fn.datenizer = (options) ->
    this.each ->
      @options = $.extend($.datenizer.defaults, options)

      initialDate = if $(this).val()
                      DateSupport.parse($(this).val(), @options.format)
                    else
                      null

      @hiddenField = if @options.submitISOFormat
                       $(this).after("<input type='hidden'>").next()
                         .attr("name", $(this).attr("name"))
                         .val(initialDate.toISOFormat())

      @calendar = new Calendar(initialDate)

      positionCalendar = =>
        @calendar.element.css
          top: $(this).offset().top + $(this).innerHeight() - 1
          left: $(this).offset().left

      @calendar.element.hide().css("position", "absolute")
      positionCalendar()

      $(this).on "focus", (e) =>
        positionCalendar()
        @calendar.element.show()
        $(this).trigger "open"

      $(this).on "change", (e) =>
        @calendar.element.hide()
        $(this).trigger "close"

      $(window).on "resize", (e) ->
        positionCalendar()

      @calendar.element.on "click", (e) =>
        e.stopPropagation()

      @calendar.element.on "click", ".day", (e) =>
        $(this).val @calendar.selectedDate.format(@options.format, $.datenizer.defaultLocale)
        @hiddenField?.val @calendar.selectedDate.toISOFormat()
        $(this).trigger "change"

      $(document).click (event) =>
        if event.target isnt this
          @calendar.element.hide()

      # Removes the input's name attribute on submition to prevent the datepicker input value submits
      if @options.submitISOFormat
        $(this).closest("form").on "submit", =>
          inputName = $(this).attr("name")
          $(this).removeAttr("name")

          setTimeout =>
            $(this).attr("name", inputName)
          , 200
)(jQuery)
