// Generated by CoffeeScript 1.5.0
(function() {
  var DateSupport;

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

}).call(this);
