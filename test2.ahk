dt := datetime.datetime
time := datetime.time
date := datetime.date
tu := datetime.timeunit

c := dt.now()
b := dt.new(2023, 2, 29)
MsgBox dt.format_string(b, "%yy%.%mm%.%dd% %HH%:%M%:%s%")


class datetime {
    class date {
        static add(a, b) {
            for i, k in b.OwnProps() {
                if a.HasProp(i) {
                    a.%i% += k
                }
            }
            return this.new(a)
        }
        static subst(a, b) {
            for i, k in b.OwnProps() {
                if a.HasProp(i) {
                    a.%i% -= k
                }
            }
            return this.new(a)
        }
        static new(year := 0, month := 0, day := 0) {
            if IsObject(year) {
                dateobj := { year: (year.HasProp("year") ? year.year : 0),
                    month: (year.HasProp("month") ? year.month : 0),
                    day: (year.HasProp("day") ? year.day : 0)
                }
                dateobj.total_seconds := this.date_into_seconds(dateobj)
                dateobj.total_milliseconds := this.date_into_milliseconds(dateobj)
                if dateobj.total_milliseconds < 86400000 {
                    throw Error("incorrect time object")
                }
                return this.milliseconds_into_date(dateobj.total_milliseconds)
            }
            dateobj := { year: year,
                month: month,
                day: day,
            }
            dateobj.total_seconds := this.date_into_seconds(dateobj)
            dateobj.total_milliseconds := this.date_into_milliseconds(dateobj)
            if dateobj.total_milliseconds < 86400000 {
                throw Error("incorrect time object")
            }
            return this.milliseconds_into_date(dateobj.total_milliseconds)
        }
        static now() {
            dateobj := {}
            dateobj.year := Number(A_YYYY),
                dateobj.month := Number(A_MM),
                dateobj.day := Number(A_DD),
                dateobj.total_seconds := this.date_into_seconds(dateobj)
            dateobj.total_milliseconds := this.date_into_milliseconds(dateobj)
            return this.milliseconds_into_date(dateobj.total_milliseconds)
        }
        static date_into_seconds(dateobj) {
            return (
                this.months_into_days(dateobj.month, dateobj.day, this.leapyear(dateobj.year)) * 86400 +
                this.years_into_seconds(dateobj.year)
            )
        }
        static date_into_milliseconds(dateobj) {
            return (
                this.months_into_days(dateobj.month, dateobj.day, this.leapyear(dateobj.year)) * 86400 +
                this.years_into_seconds(dateobj.year)
            ) * 1000
        }
        static leapyear(year) {
            return Mod(year, 4) = 0
        }
        static years_into_seconds(years) {
            seconds := 0
            if years < 1 {
                return 0
            }
            for i in range(1, years, 1) {
                if this.leapyear(i) {
                    seconds += 86400 * 366
                    continue
                }
                seconds += 86400 * 365
            }
            return seconds
        }
        static seconds_into_date(seconds) {
            dateobj := {}
            dateobj.year := this.seconds_into_years(seconds)
            dateobj.month := this.leapyear(dateobj.year) ? this.days_into_month(this.seconds_into_days(seconds - this.years_into_seconds(dateobj.year)), 1) : this.days_into_month(this.seconds_into_days(seconds - this.years_into_seconds(dateobj.year)), 0)
            dateobj.day := this.seconds_into_monthday(seconds - this.years_into_seconds(dateobj.year), this.leapyear(dateobj.year))
            dateobj.total_seconds := this.date_into_seconds(dateobj)
            dateobj.total_milliseconds := this.date_into_milliseconds(dateobj)
            return this.milliseconds_into_date(dateobj.total_milliseconds)
        }
        static milliseconds_into_date(milliseconds) {
            dateobj := {}
            dateobj.year := this.seconds_into_years(milliseconds // 1000)
            dateobj.month := this.leapyear(dateobj.year) ? this.days_into_month(this.seconds_into_days(milliseconds // 1000 - this.years_into_seconds(dateobj.year)), 1) : this.days_into_month(this.seconds_into_days(milliseconds // 1000 - this.years_into_seconds(dateobj.year)), 0)
            dateobj.day := this.seconds_into_monthday(milliseconds // 1000 - this.years_into_seconds(dateobj.year), this.leapyear(dateobj.year))
            dateobj.total_seconds := this.date_into_seconds(dateobj)
            dateobj.total_milliseconds := this.date_into_milliseconds(dateobj)
            return this.milliseconds_into_date(dateobj.total_milliseconds)
        }
        static seconds_into_days(seconds) {
            if seconds <= 0 {
                return 0
            }
            return seconds // 86400
        }
        static seconds_into_monthday(seconds, leapyear := 0) {
            days_in_month := [
                31, (leapyear ? 29 : 28), 31, 30, 31,
                30, 31, 31, 30, 31, 30, 31
            ]
            days := this.seconds_into_days(seconds)
            for i in range(12) {
                if days - days_in_month[i] < 1 {
                    return days
                }
                days -= days_in_month[i]
                if days - days_in_month[i] < 1 {
                    return days
                }
            }
        }
        static seconds_into_years(seconds) {
            years := 0
            while seconds > 0 {
                if seconds >= (3 * (86400 * 36500) + 86400 * 36600) {
                    years += 400
                    seconds -= (3 * (86400 * 36500) + 86400 * 36600)
                    continue
                }
                if seconds >= (3 * (86400 * 3650) + 86400 * 3660) {
                    years += 40
                    seconds -= (3 * (86400 * 3650) + 86400 * 3660)
                    continue
                }
                if seconds >= (3 * (86400 * 365) + 86400 * 366) {
                    years += 4
                    seconds -= (3 * (86400 * 365) + 86400 * 366)
                    continue
                }
                else {
                    if seconds - 86400 * 365 > 0 {
                        years += 1
                        seconds -= 86400 * 365
                        continue
                    }
                    break
                }
            }
            return years
        }
        static days_into_month(days, leapyear := 0) {
            counter := 0
            days_in_month := [
                31, (leapyear ? 29 : 28), 31, 30, 31,
                30, 31, 31, 30, 31, 30, 31
            ]
            if days = 0 {
                return 0
            }
            if days > 365 + leapyear {
                throw Error("incorrect days")
            }
            if days > 0 {
                counter := 1
                while true {
                    if days - days_in_month[Mod(counter - 1, 12) + 1] <= 0 {
                        return Mod(counter - 1, 12) + 1
                    }
                    days -= days_in_month[Mod(counter - 1, 12) + 1]
                    counter++
                }
            }
            else if days <= 0 {
                counter := 1
                while true {
                    if days + days_in_month[Mod(counter - 1, 12) + 1] >= 0 {
                        return Mod(counter - 1, 12) + 1
                    }
                    days += days_in_month[Mod(counter - 1, 12) + 1]
                    counter++
                }
            }
        }
        static months_into_days(months, days := 0, leapyear := 0) {
            dayscounter := 0
            days_in_month := [
                31, (leapyear ? 29 : 28), 31, 30, 31,
                30, 31, 31, 30, 31, 30, 31
            ]
            if months > 1 {
                for i, k in range(months - 1) {
                    dayscounter += days_in_month[Mod(i - 1, 12) + 1]
                }
            }
            if months < 1 {
                for i, k in range(months - 1) {
                    dayscounter -= days_in_month[Mod(i - 1, 12) + 1]
                }
            }
            dayscounter += days
            return dayscounter
        }
    }
    class datetime {
        static add(a, b) {
            for i, k in b.OwnProps() {
                if a.HasProp(i) {
                    a.%i% += k
                }
            }
            return this.new(a)
        }
        static subst(a, b) {
            for i, k in b.OwnProps() {
                if a.HasProp(i) {
                    a.%i% -= k
                }
            }
            return this.new(a)
        }
        static new(year := 0, month := 1, day := 1, hours := 0, minutes := 0, seconds := 0, milliseconds := 0) {
            if IsObject(year) {

                datetimeobj := { year: (year.HasProp("year") ? year.year : 0),
                    month: (year.HasProp("month") ? year.month : 0),
                    day: (year.HasProp("day") ? year.day : 0),
                    hours: (year.HasProp("hours") ? year.hours : 0),
                    minutes: (year.HasProp("minutes") ? year.minutes : 0),
                    seconds: (year.HasProp("seconds") ? year.seconds : 0),
                    milliseconds: (year.HasProp("milliseconds") ? year.milliseconds : 0)
                }
                datetimeobj.total_seconds := this.datetime_into_seconds(datetimeobj)
                datetimeobj.total_milliseconds := this.datetime_into_milliseconds(datetimeobj)
                if datetimeobj.total_milliseconds < 86400000 {
                    throw Error("incorrect time object")
                }
                return this.milliseconds_into_datetime(datetimeobj.total_milliseconds)

            }
            datetimeobj := { year: year,
                month: month,
                day: day,
                hours: hours,
                minutes: minutes,
                seconds: seconds,
                milliseconds: milliseconds
            }
            datetimeobj.total_seconds := this.datetime_into_seconds(datetimeobj)
            datetimeobj.total_milliseconds := this.datetime_into_milliseconds(datetimeobj)
            if datetimeobj.total_milliseconds < 86400000 {
                throw Error("incorrect time object")
            }
            return this.milliseconds_into_datetime(datetimeobj.total_milliseconds)
        }
        static now() {
            datetimeobj := {}
            datetimeobj.year := Number(A_YYYY),
                datetimeobj.month := Number(A_MM),
                datetimeobj.day := Number(A_DD),
                datetimeobj.hours := Number(A_Hour),
                datetimeobj.minutes := Number(A_Min),
                datetimeobj.seconds := Number(A_Sec),
                datetimeobj.milliseconds := Number(A_MSec),
                datetimeobj.total_seconds := this.datetime_into_seconds(datetimeobj)
            datetimeobj.total_milliseconds := this.datetime_into_milliseconds(datetimeobj)
            return datetimeobj
        }
        static leapyear(year) {
            return Mod(year, 4) = 0
        }
        static months_into_days(months, days := 0, leapyear := 0) {
            dayscounter := 0
            days_in_month := [
                31, (leapyear ? 29 : 28), 31, 30, 31,
                30, 31, 31, 30, 31, 30, 31
            ]
            if months > 1 {
                for i, k in range(months - 1) {
                    dayscounter += days_in_month[Mod(i - 1, 12) + 1]
                }
            }
            if months < 1 {
                for i, k in range(months - 1) {
                    dayscounter -= days_in_month[Mod(i - 1, 12) + 1]
                }
            }
            dayscounter += days
            return dayscounter
        }
        static datetime_into_seconds(datetimeobj) {
            return (
                datetimeobj.seconds +
                datetimeobj.minutes * 60 +
                datetimeobj.hours * 3600 +
                this.months_into_days(datetimeobj.month, datetimeobj.day, this.leapyear(datetimeobj.year)) * 86400 +
                this.years_into_seconds(datetimeobj.year)
            )
        }
        static datetime_into_milliseconds(datetimeobj) {
            return (
                datetimeobj.seconds +
                datetimeobj.minutes * 60 +
                datetimeobj.hours * 3600 +
                this.months_into_days(datetimeobj.month, datetimeobj.day, this.leapyear(datetimeobj.year)) * 86400 +
                this.years_into_seconds(datetimeobj.year)) * 1000 +
                datetimeobj.milliseconds
        }
        static days_into_month(days, leapyear := 0) {
            counter := 0
            days_in_month := [
                31, (leapyear ? 29 : 28), 31, 30, 31,
                30, 31, 31, 30, 31, 30, 31
            ]
            if days = 0 {
                return 0
            }
            if days > 365 + leapyear {
                throw Error("incorrect days")
            }
            if days > 0 {
                counter := 1
                while true {
                    if days - days_in_month[Mod(counter - 1, 12) + 1] <= 0 {
                        return Mod(counter - 1, 12) + 1
                    }
                    days -= days_in_month[Mod(counter - 1, 12) + 1]
                    counter++
                }
            }
            else if days <= 0 {
                counter := 1
                while true {
                    if days + days_in_month[Mod(counter - 1, 12) + 1] >= 0 {
                        return Mod(counter - 1, 12) + 1
                    }
                    days += days_in_month[Mod(counter - 1, 12) + 1]
                    counter++
                }
            }
        }
        static seconds_into_days(seconds) {
            return seconds // 86400
        }
        static seconds_into_monthday(seconds, leapyear := 0) {
            days_in_month := [
                31, (leapyear ? 29 : 28), 31, 30, 31,
                30, 31, 31, 30, 31, 30, 31
            ]
            days := this.seconds_into_days(seconds)
            for i in range(12) {
                if days - days_in_month[i] < 1 {
                    return days
                }
                days -= days_in_month[i]
                if days - days_in_month[i] < 1 {
                    return days
                }
            }
        }
        static years_into_seconds(years) {
            seconds := 0
            if years < 1 {
                return 0
            }
            for i in range(1, years, 1) {
                if this.leapyear(i) {
                    seconds += 86400 * 366
                    continue
                }
                seconds += 86400 * 365
            }
            return seconds
        }
        static seconds_into_years(seconds) {
            years := 0
            while seconds > 0 {
                if seconds >= (3 * (86400 * 36500) + 86400 * 36600) {
                    years += 400
                    seconds -= (3 * (86400 * 36500) + 86400 * 36600)
                    continue
                }
                if seconds >= (3 * (86400 * 3650) + 86400 * 3660) {
                    years += 40
                    seconds -= (3 * (86400 * 3650) + 86400 * 3660)
                    continue
                }
                if seconds >= (3 * (86400 * 365) + 86400 * 366) {
                    years += 4
                    seconds -= (3 * (86400 * 365) + 86400 * 366)
                    continue
                }
                else {
                    if seconds - 86400 * 365 > 0 {
                        years += 1
                        seconds -= 86400 * 365
                        continue
                    }
                    break
                }
            }
            return years
        }
        static seconds_into_datetime(seconds) {
            datetimeobj := {}
            datetimeobj.seconds := Mod(seconds, 60),
                datetimeobj.minutes := Mod(seconds // 60, 60),
                datetimeobj.hours := Mod(seconds // 3600, 24),
                datetimeobj.year := this.seconds_into_years(seconds)
            datetimeobj.month := seconds - this.leapyear(datetimeobj.year) ? this.days_into_month(this.seconds_into_days(seconds - this.years_into_seconds(datetimeobj.year)), 1) : this.days_into_month(this.seconds_into_days(seconds - this.years_into_seconds(datetimeobj.year)), 0),
                datetimeobj.day := this.seconds_into_monthday(seconds - this.years_into_seconds(datetimeobj.year), this.leapyear(datetimeobj.year)),
                datetimeobj.milliseconds := 0,
                datetimeobj.total_seconds := seconds
            datetimeobj.total_milliseconds := seconds * 1000
            return datetimeobj
        }
        static milliseconds_into_datetime(milliseconds) {
            datetimeobj := {}
            datetimeobj.seconds := Mod((milliseconds // 1000), 60),
                datetimeobj.minutes := Mod((milliseconds // 60000), 60),
                datetimeobj.hours := Mod((milliseconds // 3600000), 24),
                datetimeobj.year := this.seconds_into_years((milliseconds // 1000))
            datetimeobj.month := (milliseconds // 1000) - this.leapyear(datetimeobj.year) ? this.days_into_month(this.seconds_into_days((milliseconds // 1000) - this.years_into_seconds(datetimeobj.year)), 1) : this.days_into_month(this.seconds_into_days((milliseconds // 1000) - this.years_into_seconds(datetimeobj.year)), 0),
                datetimeobj.day := this.seconds_into_monthday((milliseconds // 1000) - this.years_into_seconds(datetimeobj.year), this.leapyear(datetimeobj.year)),
                datetimeobj.milliseconds := Mod(milliseconds, 1000),
                datetimeobj.total_seconds := (milliseconds // 1000),
                datetimeobj.total_milliseconds := milliseconds
            return datetimeobj
        }
        /*
        - %y% - year without century (e.g. example 24)
        - %yy% - year with century (e.g. 2024)
        - %m% - 1-2 digit month (e.g. 1, 4, 11)
        - %mm% - 2 digit month (e.g. 01, 04, 11)
        - %d% - 1-2 digit day (e.g. 1, 4, 31)
        - %dd% - 2 digit day (e.g. 01, 09, 15)
        - %h% - 12-h format hour 2 digits (e.g. 01, 05, 12)
        - %hh% - 24-h format hour 2 digits (e.g. 01, 05, 24)
        - %H% - 12-h format hour 1-2 digits (e.g. 1, 5, 12)
        - %HH% - 24-h format hour 1-2 digits (e.g. 1, 5, 24)
        - %M% - 1-2 digit minutes (e.g. 1, 5, 59)
        - %MM% - 2 digit minutes (e.g. 01, 05, 59)
        - %s% - 1-2 digit seconds (e.g. 1, 5, 59)
        - %ss% - 2 digit seconds (e.g. 01, 05, 59)
        */
        static format_string(datetimeobj, string := "") {
            string := RegExReplace(string, "%y%", datetime.zeroformat(Mod(datetimeobj.year, 100)))
            string := RegExReplace(string, "%yy%", datetimeobj.year)
            string := RegExReplace(string, "%m%", datetimeobj.month)
            string := RegExReplace(string, "%mm%", datetime.zeroformat(datetimeobj.month))
            string := RegExReplace(string, "%d%", datetimeobj.day)
            string := RegExReplace(string, "%dd%", datetime.zeroformat(datetimeobj.day))
            string := RegExReplace(string, "%h%", datetime.zeroformat((Mod(datetimeobj.hours - 1, 12) + 1)))
            string := RegExReplace(string, "%hh%", datetime.zeroformat(datetimeobj.hours))
            string := RegExReplace(string, "%H%", (Mod(datetimeobj.hours - 1, 12) + 1))
            string := RegExReplace(string, "%HH%", datetimeobj.hours)
            string := RegExReplace(string, "%M%", datetimeobj.minutes)
            string := RegExReplace(string, "%MM%", datetime.zeroformat(datetimeobj.minutes))
            string := RegExReplace(string, "%s%", datetimeobj.seconds)
            string := RegExReplace(string, "%ss%", datetime.zeroformat(datetimeobj.seconds))
            return string
        }
    }
    class time {
        static add(a, b) {
            for i, k in b.OwnProps() {
                if a.HasProp(i) {
                    a.%i% += k
                }
            }
            return this.new(a)
        }
        static subst(a, b) {
            for i, k in b.OwnProps() {
                if a.HasProp(i) {
                    a.%i% -= k
                }
            }
            return this.new(a)
        }
        static new(hours := 0, minutes := 0, seconds := 0, milliseconds := 0) {
            if IsObject(hours) {
                timeobj := {
                    hours: (hours.HasProp("hours") ? hours.hours : 0),
                    minutes: (hours.HasProp("minutes") ? hours.minutes : 0),
                    seconds: (hours.HasProp("seconds") ? hours.seconds : 0),
                    milliseconds: (hours.HasProp("milliseconds") ? hours.milliseconds : 0)
                }
                timeobj.total_seconds := this.time_into_seconds(timeobj)
                timeobj.total_milliseconds := this.time_into_milliseconds(timeobj)
                return this.milliseconds_into_time(timeobj.total_milliseconds)
            }
            timeobj := {
                hours: hours,
                minutes: minutes,
                seconds: seconds,
                milliseconds: milliseconds
            }
            timeobj.total_seconds := this.time_into_seconds(timeobj)
            timeobj.total_milliseconds := this.time_into_milliseconds(timeobj)
            return this.milliseconds_into_time(timeobj.total_milliseconds)
        }
        static now() {
            timeobj := {}
            timeobj.hours := Number(A_Hour),
                timeobj.minutes := Number(A_Min),
                timeobj.seconds := Number(A_Sec),
                timeobj.milliseconds := Number(A_MSec),
                timeobj.total_seconds := this.time_into_seconds(timeobj)
            timeobj.total_milliseconds := this.time_into_milliseconds(timeobj)
            return this.milliseconds_into_time(timeobj.total_milliseconds)
        }
        static seconds_into_time(seconds) {
            timeobj := {}
            timeobj.seconds := Mod(seconds, 60),
                timeobj.minutes := Mod(seconds // 60, 60),
                timeobj.hours := Mod(seconds // 360, 24),
                timeobj.milliseconds := 0,
                timeobj.total_seconds :=
                timeobj.total_milliseconds := this.time_into_milliseconds(timeobj)
            return timeobj
        }
        static milliseconds_into_time(milliseconds) {
            timeobj := {}
            timeobj.seconds := Mod(milliseconds // 1000, 60),
                timeobj.minutes := Mod(milliseconds // 1000 // 60, 60),
                timeobj.hours := Mod(milliseconds // 1000 // 3600, 24),
                timeobj.milliseconds := 0,
                timeobj.total_seconds := this.time_into_seconds(timeobj)
            timeobj.total_milliseconds := this.time_into_milliseconds(timeobj)
            return timeobj
        }
        static time_into_seconds(timeobj) {
            if timeobj.seconds + timeobj.minutes * 60 + timeobj.hours * 3600 < 0 {
                return 86400 * (((Abs(timeobj.seconds + timeobj.minutes * 60 + timeobj.hours * 3600)) // 86400) + 1) - Abs(timeobj.seconds + timeobj.minutes * 60 + timeobj.hours * 3600)
            }
            return timeobj.seconds + timeobj.minutes * 60 + timeobj.hours * 3600
        }
        static time_into_milliseconds(timeobj) {
            if timeobj.total_seconds * 1000 + timeobj.milliseconds < 0 {
                return 86400 * (((Abs(timeobj.total_seconds * 1000 + timeobj.milliseconds)) // 86400) + 1) - Abs(timeobj.total_seconds * 1000 + timeobj.milliseconds)
            }
            return timeobj.total_seconds * 1000 + timeobj.milliseconds
        }
    }
    class timeunit {
        static new(years := 0, months := 0, days := 0, hours := 0, minutes := 0, seconds := 0, milliseconds := 0) {
            timeobj := {
                year: years,
                month: months,
                day: days,
                hours: hours,
                minutes: minutes,
                seconds: seconds,
                milliseconds: milliseconds
            }
            timeobj.total_milliseconds := this.timeunit_into_milliseconds(timeobj)
            timeobj.total_seconds := this.timeunit_into_seconds(timeobj)
            return this.milliseconds_into_timeunit(timeobj.total_milliseconds)
        }
        static days_into_month(days, leapyear := 0) {
            counter := 0
            days_in_month := [
                31, (leapyear ? 29 : 28), 31, 30, 31,
                30, 31, 31, 30, 31, 30, 31
            ]
            if days = 0 {
                return 0
            }
            if days > 365 + leapyear {
                throw Error("incorrect days")
            }
            if days > 0 {
                counter := 1
                while true {
                    if days - days_in_month[Mod(counter - 1, 12) + 1] <= 0 {
                        return Mod(counter - 1, 12) + 1
                    }
                    days -= days_in_month[Mod(counter - 1, 12) + 1]
                    counter++
                }
            }
            else if days <= 0 {
                counter := 1
                while true {
                    if days + days_in_month[Mod(counter - 1, 12) + 1] >= 0 {
                        return Mod(counter - 1, 12) + 1
                    }
                    days += days_in_month[Mod(counter - 1, 12) + 1]
                    counter++
                }
            }
        }
        static timeunit_into_seconds(timeunitobj) {
            return (
                timeunitobj.seconds +
                timeunitobj.minutes * 60 +
                timeunitobj.hours * 3600 +
                this.months_into_days(timeunitobj.month, timeunitobj.day, this.leapyear(timeunitobj.year)) * 86400 +
                this.years_into_seconds(timeunitobj.year)
            )
        }
        static timeunit_into_milliseconds(timeunitobj) {
            return (
                timeunitobj.seconds +
                timeunitobj.minutes * 60 +
                timeunitobj.hours * 3600 +
                this.months_into_days(timeunitobj.month, timeunitobj.day, this.leapyear(timeunitobj.year)) * 86400 +
                this.years_into_seconds(timeunitobj.year)) * 1000 +
                timeunitobj.milliseconds

        }
        static seconds_into_monthday(seconds, leapyear := 0) {
            days_in_month := [
                31, (leapyear ? 29 : 28), 31, 30, 31,
                30, 31, 31, 30, 31, 30, 31
            ]
            days := this.seconds_into_days(seconds)
            for i in range(12) {
                if days - days_in_month[i] < 1 {
                    return days
                }
                days -= days_in_month[i]
                if days - days_in_month[i] < 1 {
                    return days
                }
            }
        }
        static seconds_into_days(seconds) {
            return seconds // 86400
        }
        static seconds_into_timeunit(seconds) {
            datetimeobj := {}
            datetimeobj.seconds := Mod(seconds, 60),
                datetimeobj.minutes := Mod(seconds // 60, 60),
                datetimeobj.hours := Mod(seconds // 3600, 24),
                datetimeobj.year := this.seconds_into_years(seconds)
            datetimeobj.month := seconds - this.leapyear(datetimeobj.year) ? this.days_into_month(this.seconds_into_days(seconds - this.years_into_seconds(datetimeobj.year)), 1) : this.days_into_month(this.seconds_into_days(seconds - this.years_into_seconds(datetimeobj.year)), 0),
                datetimeobj.day := this.seconds_into_monthday(seconds - this.years_into_seconds(datetimeobj.year), this.leapyear(datetimeobj.year)),
                datetimeobj.milliseconds := 0,
                datetimeobj.total_seconds := seconds
            datetimeobj.total_milliseconds := seconds * 1000
            return datetimeobj
        }
        static milliseconds_into_timeunit(milliseconds) {
            timeunitobj := {}
            timeunitobj.seconds := Mod((milliseconds // 1000), 60),
                timeunitobj.minutes := Mod((milliseconds // 60000), 60),
                timeunitobj.hours := Mod((milliseconds // 3600000), 24),
                timeunitobj.year := this.seconds_into_years((milliseconds // 1000))
            timeunitobj.month := (milliseconds // 1000) - this.leapyear(timeunitobj.year) ? this.days_into_month(this.seconds_into_days((milliseconds // 1000) - this.years_into_seconds(timeunitobj.year)), 1) : this.days_into_month(this.seconds_into_days((milliseconds // 1000) - this.years_into_seconds(timeunitobj.year)), 0),
                timeunitobj.day := this.seconds_into_monthday((milliseconds // 1000) - this.years_into_seconds(timeunitobj.year), this.leapyear(timeunitobj.year)),
                timeunitobj.milliseconds := Mod(milliseconds, 1000),
                timeunitobj.total_seconds := (milliseconds // 1000),
                timeunitobj.total_milliseconds := milliseconds
            return timeunitobj
        }
        static leapyear(year) {
            return Mod(year, 4) = 0
        }
        static months_into_days(months, days := 0, leapyear := 0) {
            dayscounter := 0
            days_in_month := [
                31, (leapyear ? 29 : 28), 31, 30, 31,
                30, 31, 31, 30, 31, 30, 31
            ]
            if months > 1 {
                for i, k in range(months - 1) {
                    dayscounter += days_in_month[Mod(i - 1, 12) + 1]
                }
            }
            if months < 1 {
                for i, k in range(months - 1) {
                    dayscounter -= days_in_month[Mod(i - 1, 12) + 1]
                }
            }
            dayscounter += days
            return dayscounter
        }
        static years_into_seconds(years) {
            seconds := 0
            if years < 1 {
                return 0
            }
            for i in range(1, years, 1) {
                if this.leapyear(i) {
                    seconds += 86400 * 366
                    continue
                }
                seconds += 86400 * 365
            }
            return seconds
        }
        static seconds_into_years(seconds) {
            years := 0
            while seconds > 0 {
                if seconds >= (3 * (86400 * 36500) + 86400 * 36600) {
                    years += 400
                    seconds -= (3 * (86400 * 36500) + 86400 * 36600)
                    continue
                }
                if seconds >= (3 * (86400 * 3650) + 86400 * 3660) {
                    years += 40
                    seconds -= (3 * (86400 * 3650) + 86400 * 3660)
                    continue
                }
                if seconds >= (3 * (86400 * 365) + 86400 * 366) {
                    years += 4
                    seconds -= (3 * (86400 * 365) + 86400 * 366)
                    continue
                }
                else {
                    if seconds - 86400 * 365 > 0 {
                        years += 1
                        seconds -= 86400 * 365
                        continue
                    }
                    break
                }
            }
            return years
        }
    }

    static zeroformat(number) {
        return number < 10 ? "0" number : number
    }
}


/*
python's range method in AutoHotkey
    start - range's start position
    stop - range's stop position (included)
    step - range's step (difference between current and next item in list)
Usage ways:

    range(stop)
     - returns an array that contains numbers from 1 to stop with step 1
        (or from -1 to stop with step -1 if negative number was given)

    range(start, stop)
     - return an array that contains numbers from start to stop with step 1
        (or from start to stop with step -1 if start > stop)

    range(start, stop, step)
     - returns an array that contains numbers from start to stop with custom step
        (or from start to stop with custom step if negative number was given)

    - Works with negative step as well

Examples:
    range(10) -> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    range(10, 4) -> [10, 9, 8, 7, 6, 5, 4]
    range(-7) -> [-1, -2, -3, -4, -5, -6, -7]
    range(10, 4, 2) -> Incorrect step
    range(10, 3, -2) -> [10, 8, 6, 4]
*/
range(start := "null", stop := "null", step := "null") {
    if start = "null" {
        throw Error("specify at least 1 parameter")
    }
    if stop = "null" {
        stop := start
        start := start > 0 ? 1 : -1
    }
    if stop = 0 {
        throw Error("stop can't be 0")
    }
    if step = "null" {
        step := start > stop ? -1 : 1
    }
    list := []
    if stop >= start and step > 0 {
        lastnum := start
        while true {
            if lastnum <= stop {
                list.Push lastnum
                lastnum += step
            }
            else {
                break
            }
        }
    }
    else if stop <= start and step < 0 {
        lastnum := start
        while true {
            if lastnum >= stop {
                list.Push lastnum
                lastnum += step
            }
            else {
                break
            }
        }
    }
    else {
        Throw Error("Incorrect step")
    }
    return list
}