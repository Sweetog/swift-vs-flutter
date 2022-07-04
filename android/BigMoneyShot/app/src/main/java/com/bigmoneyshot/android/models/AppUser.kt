package com.bigmoneyshot.android.models

data class AppUser(
    val first_name: String = "",
    val last_name: String = "",
    val birthdate: String = "",
    val stripeCustomerId: String = ""
)
