package com.bigmoneyshot.android.ui.fragments


import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup

import com.bigmoneyshot.android.R

/**
 * A simple [Fragment] subclass.
 *
 */
class AccountFragment : Fragment() {
    companion object {
        val TAG = "LocationsFragment"
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_account, container, false)
    }


}
