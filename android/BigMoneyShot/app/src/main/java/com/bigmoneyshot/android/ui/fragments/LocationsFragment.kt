package com.bigmoneyshot.android.ui.fragments


import android.content.Intent
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

import com.bigmoneyshot.android.R
import com.bigmoneyshot.android.listeners.GolfCourseClickListener
import com.bigmoneyshot.android.models.GolfCourse
import com.bigmoneyshot.android.ui.CourseListAdapter
import com.bigmoneyshot.android.ui.GolfCourseActivity
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.FirebaseFirestore

/**
 * A simple [Fragment] subclass.
 *
 */
class LocationsFragment : Fragment(), GolfCourseClickListener {
    companion object {
        val TAG = "LocationsFragment"
    }

    lateinit var databaseRef: FirebaseFirestore
    lateinit var firebaseAuth: FirebaseAuth
    var firebaseUser: FirebaseUser? = null

    override fun onGolfCourseClick(course: GolfCourse) {
        val intent:Intent = Intent(context, GolfCourseActivity::class.java)
        intent.putExtra("id", course.id)
        startActivity(intent)
    }

    lateinit var adapter: CourseListAdapter
    lateinit var rootView: View

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        rootView = inflater.inflate(R.layout.fragment_locations, container, false)
        databaseRef = FirebaseFirestore.getInstance()
        firebaseAuth = FirebaseAuth.getInstance()
        firebaseUser = firebaseAuth.currentUser

        val recyclerView = rootView.findViewById<RecyclerView>(R.id.recent_course_recyclerview)
        val layoutManager = LinearLayoutManager(context)
        recyclerView.layoutManager = layoutManager
        recyclerView.addItemDecoration(
            DividerItemDecoration(context, layoutManager.orientation)
        )
        adapter = CourseListAdapter(context, this)
        recyclerView.adapter = adapter
        return rootView

    }

    override fun onResume() {
        super.onResume()
        firebaseUser?.let { user->
            populateCourses();
        }

    }

    private fun populateCourses(){
        databaseRef.collection("courses")
            .get()
            .addOnSuccessListener { result ->
                for (document in result){
                    val course = document.toObject(GolfCourse::class.java)
                    course?.let { adapter.addCourse(course) }
                }
            }
    }


}
