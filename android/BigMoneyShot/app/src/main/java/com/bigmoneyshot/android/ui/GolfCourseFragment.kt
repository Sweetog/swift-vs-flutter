package com.bigmoneyshot.android.ui

import androidx.fragment.app.Fragment
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import com.bigmoneyshot.android.R
import com.bigmoneyshot.android.models.GolfCourse
import com.bigmoneyshot.android.util.GlideApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.FirebaseFirestore


class GolfCourseFragment : Fragment() {
    lateinit var rootView: View

    lateinit var databaseRef: FirebaseFirestore
    lateinit var firebaseAuth: FirebaseAuth
    var firebaseUser: FirebaseUser? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        rootView = inflater.inflate(R.layout.fragment_golf, container, false)
        databaseRef = FirebaseFirestore.getInstance()
        firebaseAuth = FirebaseAuth.getInstance()
        firebaseUser = firebaseAuth.currentUser

        if (firebaseUser != null){
            arguments?.let {
                val id = it.getString("id")

                val courseRef = databaseRef.collection("courses").document(id)
                courseRef.get().addOnSuccessListener { documentSnapshot ->
                    if (documentSnapshot != null){
                        val course = documentSnapshot.toObject(GolfCourse::class.java)
                        course?.let {
                            updateUI(course)
                        }
                    }
                }
            }
        }

        return rootView
    }

    private fun updateUI(course: GolfCourse) {
        rootView.findViewById<TextView>(R.id.text_view_hole).setText(course.name)
        rootView.findViewById<TextView>(R.id.text_view_hole).setText(course.hole)
        rootView.findViewById<TextView>(R.id.text_view_par).setText(course.par.toString())
        val yardValue: String = course.yard.toString()
        rootView.findViewById<TextView>(R.id.text_view_yards).setText("$yardValue 130 yards")

        val thumbNail = rootView.findViewById<ImageView>(R.id.image_golf_course)
        GlideApp.with(context!!)
            .load(course.imageurl)
            .placeholder(R.drawable.sample_gold_course)
            .dontAnimate()
            .centerCrop()
            .into(thumbNail)

    }
}
