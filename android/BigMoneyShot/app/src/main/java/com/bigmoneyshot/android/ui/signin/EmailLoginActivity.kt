package com.bigmoneyshot.android.ui.signin

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.ProgressBar
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.afollestad.materialdialogs.MaterialDialog
import com.bigmoneyshot.android.R
import com.bigmoneyshot.android.ui.activities.MainActivity
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.layout_signin.*

class EmailLoginActivity : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth
    private lateinit var progressView: ProgressBar
    private lateinit var databaseRef: FirebaseFirestore
    private lateinit var rootView: View

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.layout_signin)
        rootView = linearLayout
        auth = FirebaseAuth.getInstance()
        databaseRef = FirebaseFirestore.getInstance()
        progressView = progress_bar
        loginbutton.setOnClickListener { view ->
            hideSoftKeyboard()
            val stremail = inputemail.text.toString().trim()
            val strpassword = inputpassword.text.toString().trim()

            if (stremail.isNullOrBlank()) {
                inputemail.setError(getString(R.string.required_field))
                return@setOnClickListener
            }

            if (strpassword.isNullOrBlank()) {
                inputpassword.setError(getString(R.string.required_field))
                return@setOnClickListener
            }
            showProgress(true)
            auth.signInWithEmailAndPassword(stremail, strpassword)
                .addOnCompleteListener(this) { task ->
                    if (task.isSuccessful) {
                        val user = auth.currentUser
                        showProgress(false)
                        user.let { startActivity(Intent(LoginActivity@ this, MainActivity::class.java)) }
                    } else {
                        Log.w(javaClass.simpleName, "Login failed ")
                        Toast.makeText(baseContext, "Login failed - " + task.exception?.localizedMessage, Toast.LENGTH_LONG).show()
                        showProgress(false)
                    }
                }
        }

        forgetpassword.setOnClickListener {
            sendPasswordResetEmail()

        }
    }

    private fun hideSoftKeyboard() {
        val view = this.currentFocus
        view?.let { v ->
            val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager
            imm?.let { it.hideSoftInputFromWindow(v.windowToken, 0) }
        }
    }

    private fun sendPasswordResetEmail() {
        val currentUser = auth.currentUser
        var email = inputemail.text.toString().trim()
        if (currentUser != null) {
            email = currentUser.email.toString()
        }
        if (email.equals("")) {
            email = inputemail.text.toString().trim()
        }

        if (email.equals("")) {
            inputemail.setError(getString(R.string.required_field))
            return
        }

        if (!email.equals("")) {
            auth.sendPasswordResetEmail(email)
                .addOnCompleteListener { task ->
                    if (task.isSuccessful) {
                        MaterialDialog(this)
                            .show {
                                title(text = "Reset email set")
                                message(text = "Check you email for the password reset email")
                                positiveButton(text = "Ok") { dialog ->
                                    dialog.dismiss()
                                }
                            }
                    } else {
                        MaterialDialog(this)
                            .show {
                                title(text = "Reset email not sent")
                                message(text = task.exception?.localizedMessage)
                                //message(text = "Unable to send password email, check your email and try again")
                                positiveButton(text = "Ok") { dialog ->
                                    dialog.dismiss()
                                }
                            }
                    }
                }
                .addOnFailureListener { exception ->
                    MaterialDialog(this)
                        .show {
                            title(text = "Reset email failed")
                            message(text = exception.localizedMessage)
                            positiveButton(text = "Ok") { dialog ->
                                dialog.dismiss()
                            }
                        }
                }
        }

    }

    private fun showProgress(show: Boolean) {
        val shortAnimTime = resources.getInteger(android.R.integer.config_shortAnimTime)

        progressView.visibility = if (show) View.VISIBLE else View.GONE
        progressView.animate().setDuration(shortAnimTime.toLong()).alpha(
            (if (show) 1 else 0).toFloat()
        ).setListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator) {
                progressView.visibility = if (show) View.VISIBLE else View.GONE
            }
        })
    }


}
