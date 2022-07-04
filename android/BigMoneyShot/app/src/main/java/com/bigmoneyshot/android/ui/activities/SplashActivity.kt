package com.bigmoneyshot.android.ui.activities

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.bigmoneyshot.android.R
import com.bigmoneyshot.android.ui.signin.MemberLoginActivity
import com.bigmoneyshot.android.ui.signin.NonMemberLoginActivity
import com.bigmoneyshot.android.util.Constants
import com.google.firebase.auth.FirebaseAuth
import kotlinx.android.synthetic.main.layout_splash.*

class SplashActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.layout_splash)

        //If logged in user, then proceed to MainActivity
        val user = FirebaseAuth.getInstance().currentUser
        user?.let {
           startActivity(Intent(SplashActivity@this, MainActivity::class.java))
        }
        button_member.setOnClickListener { view ->
            val intent = Intent(SplashActivity@this, MemberLoginActivity::class.java)
            intent.putExtra(Constants.MEMBER, true)
            startActivity(intent)
            overridePendingTransition(R.anim.slide_in_from_right, R.anim.slide_out_to_left)
        }
        button_non_member.setOnClickListener { view ->
            val intent = Intent(SplashActivity@this, NonMemberLoginActivity::class.java)
            startActivity(intent)
            intent.putExtra(Constants.MEMBER, false)
            overridePendingTransition(R.anim.slide_in_from_right, R.anim.slide_out_to_left)
        }
    }
}
