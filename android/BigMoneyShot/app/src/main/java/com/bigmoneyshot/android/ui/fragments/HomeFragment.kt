package com.bigmoneyshot.android.ui.fragments

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.bigmoneyshot.android.R

class HomeFragment : Fragment()
{
    companion object {
        val TAG = "HomeFragment"
    }
    val TAG = "HomeFragment"
    private lateinit var rootView: View
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View?
    {
        rootView = inflater.inflate(R.layout.layout_fragment_home, container, false)
        return  rootView
    }
}