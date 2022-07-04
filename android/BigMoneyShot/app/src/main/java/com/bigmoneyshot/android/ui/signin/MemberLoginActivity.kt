package com.bigmoneyshot.android.ui.signin

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.annotation.StringRes
import androidx.appcompat.app.AppCompatActivity
import com.afollestad.materialdialogs.MaterialDialog
import com.bigmoneyshot.android.R
import com.bigmoneyshot.android.ui.activities.MainActivity
import com.firebase.ui.auth.AuthUI
import com.firebase.ui.auth.IdpResponse
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.auth.FirebaseAuth
import kotlinx.android.synthetic.main.layout_auth_sign_in.*

class MemberLoginActivity : AppCompatActivity() {

    private val RC_SIGN_IN = 25
    private val RC_EMAIL_SIGN_IN = 125;
    lateinit var rootView: View
    lateinit var dialog: MaterialDialog

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.layout_auth_sign_in)

        fb_signing_button.setOnClickListener {
            val provider = arrayListOf(
                AuthUI.IdpConfig.FacebookBuilder().build())
            startActivityForResult(
                AuthUI.getInstance()
                    .createSignInIntentBuilder()
                    .setAvailableProviders(provider)
                    .build(),
                RC_SIGN_IN)
        }
        google_signin_button.setOnClickListener {
            val provider = arrayListOf(
                AuthUI.IdpConfig.GoogleBuilder().build())
            startActivityForResult(
                AuthUI.getInstance()
                    .createSignInIntentBuilder()
                    .setAvailableProviders(provider)
                    .build(),
                RC_SIGN_IN)

        }
        emaillogin.setOnClickListener {
            val intent = Intent(this, EmailLoginActivity::class.java)
            startActivity(intent)
        }
        //If user is already logged in, go back to MainActivity
        val user = FirebaseAuth.getInstance().currentUser
        user?.let { startActivity(Intent(this, MainActivity::class.java)) }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RC_SIGN_IN) {
            val response = IdpResponse.fromResultIntent(data)
            if (resultCode == Activity.RESULT_OK) {
                // Successfully signed in
                val user = FirebaseAuth.getInstance().currentUser
                user?.let {
                    startActivity(Intent(this, RegisterActivity::class.java))
                }
            } else
            {
               response?.let {
                   //showSnackbar(it.error.toString())
                   toast(it.error.toString())
               }?:toast("Login Required") //showSnackbar("Login required")
            }
        }
    }

    fun toast(message: CharSequence) =
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
    private fun showSnackbar(@StringRes errorMessageRes: String) {
        Snackbar.make(rootView, errorMessageRes, Snackbar.LENGTH_LONG).show()
    }



}
