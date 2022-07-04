package com.bigmoneyshot.android.util

import com.bigmoneyshot.android.models.GolfCourse
import java.util.*

class SampleDataGenerator {
    companion object {
        fun getSampleGolfCourse(): List<GolfCourse> {
            val courseList = mutableListOf<GolfCourse>()

            courseList.add(
                GolfCourse(
                    UUID.randomUUID().toString(),
                    "3 Par At Four Points",
                    "6th Hole",
                    2,
                    129,
                    "8110 Aero Dr, San Diego, California 92123-1715",
                    "https://golfadvisor.brightspotcdn.com/dims4/default/0249ef3/2147483647/strip/true/crop/550x355+0+7/resize/930x600!/quality/90/?url=https%3A%2F%2Fgolfadvisor.brightspotcdn.com%2F17%2Fc7%2Ffc8a185ca19f6d9e9199f18a4350%2F32451.jpg"))

            courseList.add(
                    GolfCourse(
                        UUID.randomUUID().toString(),
                        "Admiral Baker Golf Course, North",
                        "9th Hole",
                        5,
                        102,
                        "Friars Rd &amp; Adm Baker Rd, San Diego, California 92120",
                        "http://images.pond5.com/san-diego-admiral-baker-golf-footage-084285801_prevstill.jpeg"))

            courseList.add(
                GolfCourse(
                    UUID.randomUUID().toString(),
                    "Balboa Park Golf Course",
                    "9th Hole",
                    5,
                    97,
                    "2600 Golf Course Dr, San Diego,",
                    "https://www.balboapark.org/sites/default/files/2016-12/Golf%20course%20header.jpg"))



            return courseList
        }
    }
}