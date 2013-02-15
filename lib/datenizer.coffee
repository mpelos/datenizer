jQuery ($) ->
  $.datenizer =
    _defaultLocale:
      monthNames: ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December']
      abbrMonthNames: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
        'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
      dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday']
      abbrDayNames: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

    setLocale: (locale) ->
      @currentLocale = @locale[locale]

  $.datenizer.currentLocale = $.datenizer._defaultLocale

  $.fn.datenizer = ->
