package com.bigmoneyshot.android.ui

import android.content.Context
import android.graphics.PorterDuff
import androidx.recyclerview.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import com.bigmoneyshot.android.R
import com.bigmoneyshot.android.listeners.GolfCourseClickListener
import com.bigmoneyshot.android.models.GolfCourse
import com.bigmoneyshot.android.util.GlideApp
import com.okason.prontonotepad.utils.inflate
import kotlinx.android.synthetic.main.course_list_row_layout.view.*

class CourseListAdapter(val context: Context?, val listener: GolfCourseClickListener): RecyclerView.Adapter<CourseListAdapter.ViewHolder>() {
    private val courseList: MutableList<GolfCourse> = mutableListOf()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val inflatedView = parent.inflate(R.layout.course_list_row_layout, false)
        return ViewHolder(inflatedView,listener, courseList)
    }

    override fun getItemCount(): Int {
        return courseList.size
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val course = courseList.get(position)
        course?.let { golfCourse ->
            holder.golfCourseName.setText(golfCourse.name)
            holder.holeName.setText(golfCourse.hole)
            holder.par.setText(golfCourse.par.toString())
            val yardValue: String = golfCourse.yard.toString()
            holder.yards.setText("$yardValue 130 yards")

            GlideApp.with(context!!)
                .load(course.imageurl)
                .placeholder(R.drawable.male_avater)
                .dontAnimate()
                .centerCrop()
                .into(holder.golfCourseImage)
        }
        context?.let {
            holder.golfCourseImage.setColorFilter(ContextCompat.getColor(it, R.color.md_black_1000), PorterDuff.Mode.LIGHTEN);
        }

    }

    fun setGolfCourses(courses: List<GolfCourse>){
        courseList.clear()
        courseList.addAll(courses)
        notifyDataSetChanged()
    }

    fun addCourse(course: GolfCourse){
        courseList.add(course)
        notifyDataSetChanged()
    }

    class ViewHolder(itemView: View, clickListener: GolfCourseClickListener,
                    courses: List<GolfCourse> ): RecyclerView.ViewHolder(itemView){
        val golfCourseImage = itemView.image_view_golf_course
        val golfCourseName = itemView.text_view_golf_course_name
        val holeName = itemView.text_view_hole
        val par = itemView.text_view_par
        val yards = itemView.text_view_yards
        val container = itemView.left_container

        init {
            golfCourseImage.setOnClickListener {
                val course = courses.get(adapterPosition)
                clickListener.onGolfCourseClick(course)
            }

            container.setOnClickListener {
                val course = courses.get(adapterPosition)
                clickListener.onGolfCourseClick(course)
            }
        }
    }

}