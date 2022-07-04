package com.bigmoneyshot.android.ui.signin

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.app.AlertDialog
import android.app.DatePickerDialog
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.text.Spannable
import android.text.SpannableStringBuilder
import android.text.TextUtils
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.text.style.ForegroundColorSpan
import android.util.Log
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.bigmoneyshot.android.R
import com.bigmoneyshot.android.models.AppUser
import com.bigmoneyshot.android.ui.activities.MainActivity
import com.bigmoneyshot.android.util.Validation
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.layout_signup.*
import java.text.SimpleDateFormat
import java.util.*


class EmailSignupActivity : AppCompatActivity() {
    val TAG: String = "EmailPasswordActivity"
    lateinit var selectedCalendar: Calendar
    private lateinit var auth: FirebaseAuth
    var dateOfBirth: String = ""
    private lateinit var progressView: ProgressBar
    lateinit var databaseRef: FirebaseFirestore

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.layout_signup)
        auth = FirebaseAuth.getInstance()
        databaseRef = FirebaseFirestore.getInstance()
        progressView = progress_bar

        val user = auth.currentUser
        user?.let {
            startActivity(Intent(this, MainActivity::class.java))
        }

        btncontinue.setOnClickListener {
            hideSoftKeyboard()
            val formCompleted: Boolean = allFieldsCompleted()
            if (formCompleted) {
                val validInputs: Boolean = validateInputs()

                if (validInputs) {
                    val email: String = inputemail.text.toString().trim()
                    val password: String = inputpassword.text.toString().trim()
                    createAccount(email, password)
                }
            }
        }
        inputbirthday.setOnClickListener {
            showDatePickerDialog()
        }

        val privacyTextView: TextView = disclaimer
        customTextView(privacyTextView)

    }

    private fun hideSoftKeyboard() {
        if (currentFocus != null) {
            val inputMethodManager = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            inputMethodManager.hideSoftInputFromWindow(currentFocus!!.windowToken, 0)
        }
    }

    fun showSoftKeyboard(view: View) {
        val inputMethodManager = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
        view.requestFocus()
        inputMethodManager.showSoftInput(view, 0)
    }


    private fun createAccount(email: String, password: String) {
        showProgress(true)
        auth.createUserWithEmailAndPassword(email, password)
            .addOnCompleteListener(this) { task ->
                if (task.isSuccessful) {
                    //Create Account successful
                    Log.d(TAG, "$email account created")
                    val user = auth.currentUser
                    val firstName = inputfirstname.text.toString()
                    val lastName = inputlastname.text.toString()
                    user?.let { completeRegistration(user.uid, firstName, lastName, dateOfBirth) }
                } else {
                    showProgress(false)
                    toast(task.exception?.localizedMessage.toString())
                }

            }
    }

    private fun completeRegistration(
        uid: String,
        firstName: String,
        lastName: String,
        dateOfBirth: String
    ) {
        val appUser = AppUser(firstName, lastName, dateOfBirth, "")
        databaseRef.collection(getString(R.string.db_name_users)).document(uid)
            .set(appUser)
            .addOnSuccessListener {
                Log.d(TAG, "Registration for $firstName complete")
                showProgress(false)
                startActivity(Intent(this, MainActivity::class.java))
            }
            .addOnFailureListener { error ->
                Log.w(TAG, "Error registering user", error)
                showProgress(false)
                val errorMessage: String = error.localizedMessage
                Toast.makeText(this, "Error: $errorMessage", Toast.LENGTH_SHORT).show()
            }
    }

    private fun allFieldsCompleted(): Boolean {
        var result = true
        if (inputfirstname.text.toString().isBlank()) {
            inputfirstname.setError(getString(R.string.required_field))
            result = false
        }
        if (inputlastname.text.toString().isBlank()) {
            inputlastname.setError(getString(R.string.required_field))
            result = false
        }

        if (inputemail.text.toString().isBlank()) {
            inputemail.setError(getString(R.string.required_field))
            result = false
        }

        if (inputpassword.text.toString().isBlank()) {
            inputpassword.setError(getString(R.string.required_field))
            result = false

        }
        if (inputconfirmpassword.text.toString().isBlank()) {
            inputconfirmpassword.setError(getString(R.string.required_field))
            result = false
        }
        return result
    }

    private fun validateInputs(): Boolean {
        var result = true
        if (!android.util.Patterns.EMAIL_ADDRESS.matcher(inputemail.text.toString().trim()).matches()) {
            inputemail.setError(getString(R.string.error_invalid_email_address))
            result = false
        }

        val password: String = inputpassword.text.toString().trim()
        val confirmPassword: String = inputconfirmpassword.text.toString().trim()

        if (!Validation().isValidPassord(password)) {
            inputpassword.setError("Atleast 6 chars, 1 letter, 1 number")
            result = false
        }

        if (!password.equals(confirmPassword)) {
            inputconfirmpassword.setError("Does not match password")
            result = false
        }

        return result

    }

    private fun showDatePickerDialog() {
        val calendar = Calendar.getInstance()
        calendar.add(Calendar.YEAR, -18)
        val year = calendar.get(Calendar.YEAR)
        val month = calendar.get(Calendar.MONTH)
        val day = calendar.get(Calendar.DAY_OF_MONTH)

        val datePicker = DatePickerDialog(
            this,
            AlertDialog.THEME_HOLO_DARK,
            DatePickerDialog.OnDateSetListener { view, selectedYear, selectedMonth, selectedDay ->

                selectedCalendar = Calendar.getInstance()
                selectedCalendar.set(selectedYear, selectedMonth, selectedDay)
                val formatter = SimpleDateFormat("MM/dd/yyyy")
                dateOfBirth = formatter.format(selectedCalendar.time)
                inputbirthday.setText(dateOfBirth)
                inputbirthday.setError(null)

            },
            year,
            month,
            day
        )
        // datePicker.datePicker.maxDate = calendar.timeInMillis
        datePicker.show()
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

    private fun customTextView(view: TextView) {
        val spanTxt =
            SpannableStringBuilder("By clicking \"Continue\", you are indicating that you have read and agree to the ")

        val policyText = SpannableStringBuilder(" Big Money Shot Privacy policy")
        policyText.setSpan(object : ClickableSpan() {
            override fun onClick(widget: View) {
                shoWebPage("http://www.bigmoneyshot.com/privacy")
            }
        }, 0, policyText.length, 0)
        val policyColor = ForegroundColorSpan(ContextCompat.getColor(this, R.color.golden))
        policyText.setSpan(policyColor, 0, policyText.length, 0)
        policyText.append(" and ")

        val termsText = SpannableStringBuilder("Terms of Use.")
        termsText.setSpan(object : ClickableSpan() {
            override fun onClick(widget: View) {
                shoWebPage("http://www.bigmoneyshot.com/terms")
            }
        }, 0, termsText.length, 0)
        val termColor = ForegroundColorSpan(ContextCompat.getColor(this, R.color.golden))
        termsText.setSpan(termColor, 0, termsText.length, Spannable.SPAN_INCLUSIVE_INCLUSIVE)


        view.movementMethod = LinkMovementMethod.getInstance()
        view.setText(TextUtils.concat(spanTxt, policyText, termsText), TextView.BufferType.SPANNABLE)
    }

    private fun shoWebPage(url: String) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(url)
        startActivity(intent)
    }

    fun toast(message: CharSequence) =
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
}
