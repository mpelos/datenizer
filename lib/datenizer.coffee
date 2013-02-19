jQuery ($) ->
  $.datenizer =
    _defaultLocale:
      monthNames: ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December']
      abbrMonthNames: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
        'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
      dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday']
      abbrDayNames: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']

    setLocale: (locale) ->
      @currentLocale = @locale[locale]

  $.datenizer.currentLocale = $.datenizer._defaultLocale

  $.fn.datenizer = (options) ->
    options = $.extend($.datenizer.defaults, options)

    @calendar = new Calendar

    @calendar.element.hide().css
      position: "absolute"
      top: @offset().top + @innerHeight() - 1
      left: @offset().left

    @on "focus", (e) =>
      @calendar.element.show()
      @trigger "open"

    @on "change", (e) =>
      @calendar.element.hide()
      @trigger "close"

    @on "click", (e) =>
      e.stopPropagation()

    @calendar.element.on "click", (e) =>
      e.stopPropagation()

    @calendar.element.on "click", ".day", (e) =>
      @trigger "change"

    $(document).click =>
      @calendar.element.hide()
