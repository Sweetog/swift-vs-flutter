package com.bigmoneyshot.android.models

data class GolfCourse(
    val id: String = "",
    val name: String = "",
    val hole: String = "",
    val par: Int = 0,
    val yard: Int = 0,
    val address: String = "",
    val imageurl: String = "") {
}