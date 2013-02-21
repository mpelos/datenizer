// Generated by CoffeeScript 1.3.3
(function() {
  var Calendar, DateSupport;

  Calendar = (function() {

    function Calendar(selectedDate) {
      this.selectedDate = selectedDate != null ? selectedDate : new DateSupport;
      this.currentDate = this.selectedDate;
      this.element = jQuery("body").append("<div class='datenizer'></div>").children(".datenizer:last");
      this.render();
      this.insertEventListeners();
    }

    Calendar.prototype.locale = function() {
      return jQuery.datenizer.currentLocale;
    };

    Calendar.prototype.render = function() {
      this.element.empty();
      this.renderTable();
      this.renderDays();
      this.twitterBootstrapStyle();
      return this.element;
    };

    Calendar.prototype.renderTable = function() {
      var monthName, table, year;
      monthName = this.locale().monthNames[this.currentDate.getMonth()];
      year = this.currentDate.getFullYear();
      table = "<table class=\"calendar\" style=\"text-align: center\">\n  <thead>\n    <tr>\n      <th><a href=\"#\" class=\"previous month\">«</a></th>\n      <th colspan=\"5\" class=\"month\"><h5>" + monthName + " " + year + "</h5></th>\n      <th><a href=\"#\" class=\"next month\">»</a></th>\n    </tr>\n\n    <tr>\n      <th>" + (this.locale().abbrDayNames[0]) + "</th>\n      <th>" + (this.locale().abbrDayNames[1]) + "</th>\n      <th>" + (this.locale().abbrDayNames[2]) + "</th>\n      <th>" + (this.locale().abbrDayNames[3]) + "</th>\n      <th>" + (this.locale().abbrDayNames[4]) + "</th>\n      <th>" + (this.locale().abbrDayNames[5]) + "</th>\n      <th>" + (this.locale().abbrDayNames[6]) + "</th>\n    </tr>\n  </thead>\n\n  <tbody></tbody>\n</table>";
      return this.element.append(table);
    };

    Calendar.prototype.renderDays = function() {
      var classNames, currentDate, day, daysAfter, daysBefore, daysInMonth, daysPerWeek, loopDate, n, startDate, totalDays, totalDaysShown, _i, _ref;
      startDate = this.currentDate.beginningOfMonth();
      totalDays = this.currentDate.endOfMonth().getDate();
      daysBefore = startDate.getDay();
      daysPerWeek = 7;
      totalDaysShown = daysPerWeek * Math.ceil((totalDays + daysBefore) / daysPerWeek);
      daysAfter = totalDaysShown - (totalDays + daysBefore);
      for (n = _i = 0, _ref = totalDaysShown - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; n = 0 <= _ref ? ++_i : --_i) {
        day = n - daysBefore + 1;
        daysInMonth = startDate.daysInMonth();
        currentDate = new DateSupport(startDate.getFullYear(), startDate.getMonth(), day);
        loopDate = currentDate;
        if (day < 1 || day > daysInMonth) {
          loopDate = day < 1 ? startDate.daysAgo(daysBefore - n) : startDate.daysFromNow(n - daysBefore + 1);
        }
        if (n % daysPerWeek === 0) {
          this.element.children(".calendar").append("<tr></tr>");
        }
        classNames = "day";
        if (loopDate.getMonth() !== startDate.getMonth()) {
          classNames += " other-month";
        }
        if (loopDate.isToday()) {
          classNames += " today";
        }
        if (this.selectedDate.isEqual(currentDate)) {
          classNames += " selected";
        }
        this.element.find(".calendar tbody tr:last").append("<td><a href='#' class='" + classNames + "' data-date='" + (loopDate.dateInMiliseconds()) + "'>" + (loopDate.getDate()) + "</a></td>");
      }
      return this.element;
    };

    Calendar.prototype.twitterBootstrapStyle = function() {
      this.element.addClass("dropdown-menu").css({
        minWidth: "auto",
        padding: "10px"
      }).show();
      this.element.find(".calendar tr:first th").css({
        marginBottom: "6px",
        textAlign: "center"
      });
      this.element.find(".calendar .month h5").css("margin", 0);
      this.element.find("th a, td a").css({
        display: "inline-block",
        padding: "5px"
      });
      this.element.find(".other-month.day").addClass("muted");
      this.element.find(".selected").addClass("btn btn-primary");
      this.element.find("th a, td a:not(.muted, .btn)").css("color", "rgb(51, 51, 51)");
      return this.element;
    };

    Calendar.prototype.insertEventListeners = function() {
      this.element.on("click", "a", function(e) {
        return e.preventDefault();
      });
      this.element.on("click", ".previous", this, function(e) {
        var calendar;
        calendar = e.data;
        calendar.currentDate = calendar.currentDate.previousMonth();
        return calendar.render();
      });
      this.element.on("click", ".next", this, function(e) {
        var calendar;
        calendar = e.data;
        calendar.currentDate = calendar.currentDate.nextMonth();
        return calendar.render();
      });
      return this.element.on("click", ".day", this, function(e) {
        var calendar, selectedDate;
        calendar = e.data;
        selectedDate = jQuery(e.currentTarget).data("date");
        calendar.selectedDate = new DateSupport(selectedDate);
        calendar.currentDate = calendar.selectedDate;
        return calendar.render();
      });
    };

    return Calendar;

  })();

  DateSupport = (function() {
    var blankPadNumber, dayInMiliseconds, zeroPadNumber;

    function DateSupport() {
      this.current = (function() {
        switch (arguments.length) {
          case 0:
            return new Date;
          case 1:
            if (arguments[0] instanceof Date) {
              return arguments[0];
            } else {
              return new Date(arguments[0]);
            }
            break;
          case 2:
            return new Date(arguments[0], arguments[1]);
          case 3:
            return new Date(arguments[0], arguments[1], arguments[2]);
        }
      }).apply(this, arguments);
      this.current = new Date(this.current.getFullYear(), this.current.getMonth(), this.current.getDate());
    }

    DateSupport.defaultLocale = {
      monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
      abbrMonthNames: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    };

    DateSupport.parse = function(formatted, format) {
      var day, index, letter, month, parseMonthName, year, _i, _len, _ref, _ref1;
      year = new Date().getFullYear();
      month = new Date().getMonth();
      day = new Date().getDate();
      parseMonthName = function(index, abbr) {
        var monthIndex, monthName, monthNames, _i, _len;
        if (abbr == null) {
          abbr = false;
        }
        monthNames = abbr ? DateSupport.defaultLocale.abbrMonthNames : DateSupport.defaultLocale.monthNames;
        for (monthIndex = _i = 0, _len = monthNames.length; _i < _len; monthIndex = ++_i) {
          monthName = monthNames[monthIndex];
          if (formatted.slice(index).toLowerCase().indexOf(monthName.toLowerCase()) !== -1) {
            return monthIndex;
          }
        }
      };
      for (index = _i = 0, _len = format.length; _i < _len; index = ++_i) {
        letter = format[index];
        if (letter === "%") {
          switch (format[index + 1]) {
            case "Y":
              year = formatted.slice(index, index + 4);
              formatted = formatted.replace(year, "%Y");
              break;
            case "y":
              year = formatted.slice(index, index + 2);
              formatted = formatted.replace(year, "%y");
              year = "20" + year;
              break;
            case "m":
              month = formatted.slice(index, index + 2);
              formatted = formatted.replace(month, "%m");
              month = parseInt(month) - 1;
              break;
            case "B":
              month = parseMonthName(index);
              formatted = formatted.replace(DateSupport.defaultLocale.monthNames[month], "%B");
              break;
            case "b":
            case "h":
              month = parseMonthName(index, true);
              formatted = formatted.replace(DateSupport.defaultLocale.abbrMonthNames[month], "%b");
              break;
            case "d":
              day = formatted.slice(index, index + 2);
              formatted = formatted.replace(day, "%d");
              break;
            case "e":
              day = formatted.slice(index, index + 2);
              formatted = formatted.replace(day, "%e");
              day = parseInt(day);
          }
          switch (format.slice(index + 1, index + 3)) {
            case "_m":
              month = formatted.slice(index, index + 2);
              formatted = formatted.replace(month, "%_m");
              month = parseInt(month) - 1;
              break;
            case "-m":
              month = formatted.slice(index, index + 2);
              if ((10 > (_ref = parseInt(month)) && _ref <= 12)) {
                month = month[0];
              }
              formatted = formatted.replace(month, "%-m");
              month = parseInt(month) - 1;
              break;
            case "^B":
              month = parseMonthName(index);
              formatted = formatted.replace(DateSupport.defaultLocale.monthNames[month].toUpperCase(), "%B");
              break;
            case "^b":
              month = parseMonthName(index, true);
              formatted = formatted.replace(DateSupport.defaultLocale.abbrMonthNames[month], "%^b");
              break;
            case "-d":
              day = formatted.slice(index, index + 2);
              if ((10 > (_ref1 = parseInt(day)) && _ref1 <= 31)) {
                day = day[0];
              }
              formatted = formatted.replace(day, "%-d");
              day = parseInt(day);
          }
        }
      }
      return new DateSupport(year, month, day);
    };

    DateSupport.prototype.beginningOfMonth = function() {
      return new DateSupport(this.current.getFullYear(), this.current.getMonth());
    };

    DateSupport.prototype.daysAgo = function(n) {
      var daysInMiliseconds;
      daysInMiliseconds = n * dayInMiliseconds();
      return new DateSupport(this.dateInMiliseconds() - daysInMiliseconds);
    };

    DateSupport.prototype.daysFromNow = function(n) {
      var daysInMiliseconds;
      daysInMiliseconds = n * dayInMiliseconds();
      return new DateSupport(this.dateInMiliseconds() + daysInMiliseconds);
    };

    DateSupport.prototype.daysInMonth = function() {
      return [31, (this.isLeapYear() ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][this.current.getMonth()];
    };

    DateSupport.prototype.dateInMiliseconds = function() {
      return Date.parse(this.current.toString());
    };

    DateSupport.prototype.endOfMonth = function() {
      var date, n, _i;
      for (n = _i = 31; _i >= 28; n = --_i) {
        date = new DateSupport(this.current.getFullYear(), this.current.getMonth(), n);
        if (date.getMonth() === this.current.getMonth()) {
          break;
        }
      }
      return date;
    };

    DateSupport.prototype.format = function(format, locale) {
      var formatted;
      if (locale == null) {
        locale = DateSupport.defaultLocale;
      }
      formatted = format;
      formatted = formatted.replace(/%Y/g, this.getFullYear());
      formatted = formatted.replace(/%y/g, this.getFullYear().toString().slice(2, 4));
      formatted = formatted.replace(/%m/g, zeroPadNumber(this.getMonth() + 1));
      formatted = formatted.replace(/%_m/g, blankPadNumber(this.getMonth() + 1));
      formatted = formatted.replace(/%-m/g, this.getMonth() + 1);
      formatted = formatted.replace(/%B/g, locale.monthNames[this.getMonth()]);
      formatted = formatted.replace(/%\^B/g, locale.monthNames[this.getMonth()].toUpperCase());
      formatted = formatted.replace(/%b/g, locale.abbrMonthNames[this.getMonth()]);
      formatted = formatted.replace(/%\^b/g, locale.abbrMonthNames[this.getMonth()].toUpperCase());
      formatted = formatted.replace(/%d/g, zeroPadNumber(this.getDate()));
      formatted = formatted.replace(/%-d/g, this.getDate());
      return formatted = formatted.replace(/%e/g, blankPadNumber(this.getDate()));
    };

    DateSupport.prototype.getDay = function() {
      return this.current.getDay();
    };

    DateSupport.prototype.getDate = function() {
      return this.current.getDate();
    };

    DateSupport.prototype.getMonth = function() {
      return this.current.getMonth();
    };

    DateSupport.prototype.getFullYear = function() {
      return this.current.getFullYear();
    };

    DateSupport.prototype.isEqual = function(otherDate) {
      return this.current.toString() === new DateSupport(otherDate).toString();
    };

    DateSupport.prototype.isLeapYear = function() {
      var year;
      year = this.current.getFullYear();
      return ((0 === year % 4) && (0 !== year % 100)) || (0 === year);
    };

    DateSupport.prototype.isToday = function() {
      return this.isEqual(new Date);
    };

    DateSupport.prototype.monthsAgo = function(n) {
      var daysInMiliseconds;
      daysInMiliseconds = n * this.daysInMonth() * dayInMiliseconds();
      return new DateSupport(this.dateInMiliseconds() - daysInMiliseconds);
    };

    DateSupport.prototype.monthsFromNow = function(n) {
      var daysInMiliseconds;
      daysInMiliseconds = n * this.daysInMonth() * dayInMiliseconds();
      return new DateSupport(this.dateInMiliseconds() + daysInMiliseconds);
    };

    DateSupport.prototype.nextMonth = function() {
      return this.monthsFromNow(1);
    };

    DateSupport.prototype.previousMonth = function() {
      return this.monthsAgo(1);
    };

    DateSupport.prototype.toISOFormat = function() {
      return this.format("%Y-%m-%d");
    };

    DateSupport.prototype.toString = function() {
      return this.current.toString();
    };

    dayInMiliseconds = function() {
      return 24 * 60 * 60 * 1000;
    };

    zeroPadNumber = function(n) {
      if (n < 10) {
        return '0' + n;
      } else {
        return n;
      }
    };

    blankPadNumber = function(n) {
      if (n < 10) {
        return ' ' + n;
      } else {
        return n;
      }
    };

    return DateSupport;

  })();

  (function($) {
    $.datenizer = {
      defaults: {
        format: "%Y-%m-%d",
        submitISOFormat: false
      },
      _defaultLocale: {
        monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        abbrMonthNames: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
        abbrDayNames: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
      },
      locale: {},
      setLocale: function(locale) {
        return this.currentLocale = this.locale[locale];
      }
    };
    $.datenizer.locale["en"] = $.datenizer._defaultLocale;
    $.datenizer.setLocale("en");
    return $.fn.datenizer = function(options) {
      return this.each(function() {
        var initialDate,
          _this = this;
        this.options = $.extend($.datenizer.defaults, options);
        initialDate = $(this).val() ? DateSupport.parse($(this).val(), this.options.format) : null;
        this.hiddenField = this.options.submitISOFormat ? $(this).after("<input type='hidden'>").next().attr("name", $(this).attr("name")).val(initialDate.toISOFormat()) : void 0;
        this.calendar = new Calendar(initialDate);
        this.calendar.element.hide().css({
          position: "absolute",
          top: $(this).offset().top + $(this).innerHeight() - 1,
          left: $(this).offset().left
        });
        $(this).on("focus", function(e) {
          _this.calendar.element.show();
          return $(_this).trigger("open");
        });
        $(this).on("change", function(e) {
          _this.calendar.element.hide();
          return $(_this).trigger("close");
        });
        $(this).on("click", function(e) {
          return e.stopPropagation();
        });
        this.calendar.element.on("click", function(e) {
          return e.stopPropagation();
        });
        this.calendar.element.on("click", ".day", function(e) {
          var _ref;
          $(_this).val(_this.calendar.selectedDate.format(_this.options.format, $.datenizer.defaultLocale));
          if ((_ref = _this.hiddenField) != null) {
            _ref.val(_this.calendar.selectedDate.toISOFormat());
          }
          return $(_this).trigger("change");
        });
        $(document).click(function() {
          return _this.calendar.element.hide();
        });
        return $(this).closest("form").on("submit", function() {
          var inputName;
          inputName = $(_this).attr("name");
          $(_this).removeAttr("name");
          return setTimeout(function() {
            return $(_this).attr("name", inputName);
          }, 200);
        });
      });
    };
  })(jQuery);

}).call(this);
