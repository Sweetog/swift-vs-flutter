package com.bigmoneyshot.android.ui

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentTransaction
import com.bigmoneyshot.android.R

import kotlinx.android.synthetic.main.activity_golf.*

class GolfCourseActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_golf)
        setSupportActionBar(toolbar)

        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.setTitle("Play")

        intent?.let { intent ->
            val fragment = GolfCourseFragment()
            fragment.arguments = intent.extras
            showFragment(fragment)

        }


    }

    private fun showFragment(fragment: Fragment) {
        supportFragmentManager
            .beginTransaction()
            .setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
            .replace(R.id.container, fragment)
            .addToBackStack(null)
            .commitAllowingStateLoss()
    }

}
