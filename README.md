Datenizer
=========

Datenizer is a simple jQuery datepicker that tries not to suck so much.


Usage
-----

### Via data-attributes

Use with default options:

    <input name="date" type="text" data-datepicker="datenizer" />

Or customize:

    <input name="date" type="text" data-datepicker="datenizer" data-format="%d/%m/%Y" />

### Via javascript

Use with default options:

    $(".datepicker").datenizer();

Or customize:

    $(".datepicker").datenizer({
        format: "%d/%m/%Y"
    });


Options
-------

### format (default: "%Y-%m-%d")
Formats time according to the directives in the given format string. The directives begins with a percent (%) character.

%Y - Year (4 digits)
%y - year (00..99)
%m - Month of the year, zero-padded (01..12)
%_m  blank-padded ( 1..12)
%-m  no-padded (1..12)
%B - The full month name ("January")
%^B  uppercased ("JANUARY")
%b - The abbreviated month name ("Jan")
%^b  uppercased ("JAN")
%h - Equivalent to %b
%d - Day of the month, zero-padded (01..31)
%-d  no-padded (1..31)
%e - Day of the month, blank-padded ( 1..31)
%j - Day of the year (001..366)

#### Example
    $(".datepicker").datenizer({
        format: "%B %d, %Y"
    });
    
    // or:
    <input name="date" type="text" data-datepicker="datenizer" data-format="%B %d, %Y" />


### submitISOFormat (default: false)
Send the ISO 8601 date format (e.g. 2012-01-28) on form submition ignoring the formatted value in the text field.

#### Example
    $(".datepicker").datenizer({
        submitISOFormat: true
    });
    
    // or:
    <input name="date" type="text" data-datepicker="datenizer" data-submit-iso-format="true" />


Callbacks
---------

### change
Triggered when the date changes.

### close
Triggered when the calendar hides.

### open
Triggered when the calendar shows up.


Internationalization
--------------------

### Using an existing locale:
    $.datenizer.setLocale("en");

### Defining a new locale: 
    $.datenizer.locale["pt-BR"] = {
        monthNames: ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
            'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'],

        abbrMonthNames: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul',
            'Ago', 'Set', 'Out', 'Nov', 'Dez'],

        dayNames: ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta',
            'Sexta', 'Sábado'],

        abbrDayNames: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab']
    }

    $.datenizer.setLocale("pt-BR");


Global setups
-------------
You can set a global configuration to be used by all datenizers in your application.

    $.datenizer.defaults = {
        format: "%d/%m/%Y",
        submitISOFormat: true
    }
