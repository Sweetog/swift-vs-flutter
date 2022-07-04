package com.bigmoneyshot.android.ui.activities


import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentTransaction
import com.bigmoneyshot.android.R
import com.bigmoneyshot.android.ui.fragments.AccountFragment
import com.bigmoneyshot.android.ui.fragments.HomeFragment
import com.bigmoneyshot.android.ui.fragments.LocationsFragment
import com.bigmoneyshot.android.ui.signin.MemberLoginActivity
import com.bigmoneyshot.android.ui.viewstates.BottomLayoutViewStates
import com.google.firebase.auth.FirebaseAuth
import kotlinx.android.synthetic.main.bottom_navigation_layout.*

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        //If user is null, go to Auth UI Screen
        val user = FirebaseAuth.getInstance().currentUser
        menu_textview_home.setOnClickListener(View.OnClickListener {
            footerTransition(BottomLayoutViewStates.HOME)
        })
        menu_textview_location.setOnClickListener(View.OnClickListener {
            footerTransition(BottomLayoutViewStates.LOCATION)
        })
        menu_textview_account.setOnClickListener(View.OnClickListener {
            footerTransition(BottomLayoutViewStates.ACCOUNT)
        })
        user?:startActivity(Intent(this, MemberLoginActivity::class.java))
        showFragment(HomeFragment(),HomeFragment.TAG )
    }

    private fun footerTransition(viewState: BottomLayoutViewStates) {
        resetAllIconsToOff()
        when (viewState) {
            BottomLayoutViewStates.HOME -> {
                menu_textview_home.setCompoundDrawablesWithIntrinsicBounds(0, R.drawable.ic_home_on, 0, 0)
                menu_textview_home.setTextColor(ContextCompat.getColor(this, R.color.golden))
                showFragment(HomeFragment(),HomeFragment.TAG )
            }
            BottomLayoutViewStates.LOCATION -> {
                menu_textview_location.setCompoundDrawablesWithIntrinsicBounds(0, R.drawable.ic_location_on, 0, 0)
                menu_textview_location.setTextColor(ContextCompat.getColor(this, R.color.golden))
                showFragment(LocationsFragment(),LocationsFragment.TAG )
            }
            BottomLayoutViewStates.ACCOUNT -> {
                menu_textview_account.setCompoundDrawablesWithIntrinsicBounds(0, R.drawable.ic_account_on, 0, 0)
                menu_textview_account.setTextColor(ContextCompat.getColor(this, R.color.golden))
                showFragment(AccountFragment(),AccountFragment.TAG )
            }
        }

    }

    private fun resetAllIconsToOff() {
        menu_textview_home.setCompoundDrawablesWithIntrinsicBounds(0, R.drawable.ic_home_of, 0, 0)
        menu_textview_home.setTextColor(ContextCompat.getColor(this, R.color.dark_gray))

        menu_textview_location.setCompoundDrawablesWithIntrinsicBounds(0, R.drawable.ic_location_off, 0, 0)
        menu_textview_location.setTextColor(ContextCompat.getColor(this, R.color.dark_gray))

        menu_textview_account.setCompoundDrawablesWithIntrinsicBounds(0, R.drawable.ic_account_of, 0, 0)
        menu_textview_account.setTextColor(ContextCompat.getColor(this, R.color.dark_gray))

    }
    private fun showFragment(fragment: Fragment, tag: String) {
        supportFragmentManager
            .beginTransaction()
            .setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
            .replace(R.id.container, fragment)
            .addToBackStack(tag)
            .commitAllowingStateLoss()
    }

}
