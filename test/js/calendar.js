// Generated by CoffeeScript 1.5.0
(function() {
  var Calendar;

  Calendar = (function() {

    function Calendar(selectedDate) {
      this.selectedDate = selectedDate;
      this.currentDate = this.selectedDate || new DateSupport;
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
        if (this.selectedDate ? this.selectedDate.isEqual(currentDate) : void 0) {
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

}).call(this);
