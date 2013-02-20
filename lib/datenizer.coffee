jQuery ($) ->
  $.datenizer =
    defaults:
      format: "%Y-%m-%d"
      submitISOFormat: false

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
    this.each ->
      @options = $.extend($.datenizer.defaults, options)
      initialDate = if $(this).val() then DateSupport.parse($(this).val(), @options.format) else null

      @hiddenField = if @options.submitISOFormat
                       $(this).after("<input type='hidden'>").next()
                         .attr("name", $(this).attr("name"))
                         .val(initialDate.toISOFormat())

      @calendar = new Calendar(initialDate)

      @calendar.element.hide().css
        position: "absolute"
        top: $(this).offset().top + $(this).innerHeight() - 1
        left: $(this).offset().left

      $(this).on "focus", (e) =>
        @calendar.element.show()
        $(this).trigger "open"

      $(this).on "change", (e) =>
        @calendar.element.hide()
        $(this).trigger "close"

      $(this).on "click", (e) =>
        e.stopPropagation()

      @calendar.element.on "click", (e) =>
        e.stopPropagation()

      @calendar.element.on "click", ".day", (e) =>
        $(this).val @calendar.selectedDate.format(@options.format, $.datenizer.defaultLocale)
        @hiddenField?.val @calendar.selectedDate.toISOFormat()
        $(this).trigger "change"

      $(document).click =>
        @calendar.element.hide()
