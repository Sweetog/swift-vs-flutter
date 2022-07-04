package com.bigmoneyshot.android.util

import java.util.*
import java.util.regex.Matcher
import java.util.regex.Pattern

class Validation {
    fun isEmailValid(email: String): Boolean {
        return android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()
    }

    fun isValidPassord(password: String): Boolean{
        val pattern: Pattern
        val matcher: Matcher
        val PASSWORD_PATTERN = "^(?=.*[0-9])(?=.*[a-z])(?=\\S+$).{6,}$"
        pattern = Pattern.compile(PASSWORD_PATTERN)
        matcher = pattern.matcher(password)
        return matcher.matches()
    }

    fun getUsersAge(selectedCalendar: Calendar): Int {
        val today = Calendar.getInstance()
        var age = today.get(Calendar.YEAR) - selectedCalendar.get(Calendar.YEAR)
        if (today.get(Calendar.MONTH) < selectedCalendar.get(Calendar.MONTH)) {
            age--
        } else if (today.get(Calendar.MONTH) === selectedCalendar.get(Calendar.MONTH) &&
            today.get(Calendar.DAY_OF_MONTH) < selectedCalendar.get(Calendar.DAY_OF_MONTH)) {
            age--
        }
        return age
    }
}