package com.bigmoneyshot.android.ui.signin

import android.app.DatePickerDialog
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.text.SpannableStringBuilder
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.util.Log
import android.view.View
import android.widget.TextView
import android.widget.TextView.BufferType
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.bigmoneyshot.android.R
import com.bigmoneyshot.android.models.AppUser
import com.bigmoneyshot.android.ui.activities.MainActivity
import com.bigmoneyshot.android.util.Validation
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.layout_register.*
import java.text.SimpleDateFormat
import java.util.*


class RegisterActivity : AppCompatActivity() {
    private val TAG: String = "RegisterActivity"
    var selectedCalendar: Calendar = Calendar.getInstance()
    lateinit var databaseRef: FirebaseFirestore
    lateinit var firebaseAuth: FirebaseAuth
    var firebaseUser: FirebaseUser? = null
    var dateOfBirth: String = ""


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.layout_register)
        databaseRef = FirebaseFirestore.getInstance()
        firebaseAuth = FirebaseAuth.getInstance()
        firebaseUser = firebaseAuth.currentUser
        firebaseUser?.let { user->
            updateUi(user)
        }
        val privacyTextView: TextView = disclaimer
        customTextView(privacyTextView)

        inputbirthday.setOnClickListener {
            showDatePickerDialog()
        }
        btncontinue.setOnClickListener {
            onSubmitButtonClicked()
        }

    }
    override fun onResume() {
        super.onResume()
    }

    private fun updateUi(user: FirebaseUser) {
        val email: String = user.email.toString()
        inputemail.setText(email)
        val fullName = user.displayName.toString()
        var firstName: String = ""
        var lastName: String = ""

        if (fullName.contains(" ")){
            firstName = fullName.substring(0, fullName.indexOf(" "))
            lastName = fullName.substring(fullName.indexOf(" "), fullName.length)
        } else {
            firstName = fullName
        }
        inputfirstname.setText(firstName)
        if (lastName.isNotBlank()){
            inputlastname.setText(lastName)
        }
        inputemail.setText(email)
        //Disable Email Edittext to prevent user from editing it
        inputemail.isFocusableInTouchMode = false

        val userRef = databaseRef.collection(getString(R.string.db_name_users))
            .document(user.uid)
        userRef.get().addOnSuccessListener { documentSnapshot ->
            if (documentSnapshot != null){
                val user = documentSnapshot.toObject(AppUser::class.java)
                inputbirthday.setText(user?.birthdate)
                dateOfBirth = user?.birthdate.toString()
                val formatter = SimpleDateFormat("MM/dd/yyyy")
                selectedCalendar.time = formatter.parse(dateOfBirth)
            }
        }

    }

    private fun onSubmitButtonClicked() {
        if (inputfirstname.text.toString().isBlank()){
            inputfirstname.setError("Enter Firstname")
            return
        }

        if (inputlastname.text.toString().isBlank()){
            inputlastname.setError("Enter Lastname")
            return
        }

        if (inputemail.text.toString().isBlank()){
            inputemail.setError("Enter Email")
            return
        }

        if (!android.util.Patterns.EMAIL_ADDRESS.matcher(inputemail.text.toString().trim()).matches()) {
            inputemail.setError("Enter Accurate Email")
        }

        if (inputbirthday.text.toString().isBlank()){
            inputbirthday.setError("Enter Your Date of Birth")
            return;
        }


        if (18 > Validation().getUsersAge(selectedCalendar)){
            inputbirthday.setError("You are under 18")
            return;
        }

        val firstName: String = inputfirstname.text.toString().trim()
        val lastName: String = inputlastname.text.toString().trim()


        val appUser = AppUser(firstName, lastName, dateOfBirth, "")
        firebaseUser?.let { user->
            val userId = user.uid
            databaseRef.collection(getString(R.string.db_name_users)).document(userId)
                .set(appUser)
                .addOnSuccessListener {
                    Log.d(TAG, "User successfully written!")
                    Toast.makeText(this, "Registration complete", Toast.LENGTH_SHORT).show()
                    startActivity(Intent(this, MainActivity::class.java))
                }
                .addOnFailureListener { error ->
                    Log.w(TAG, "Error writing document", error)
                    val errorMessage: String = error.localizedMessage
                    Toast.makeText(this, "Error: $errorMessage", Toast.LENGTH_SHORT).show()
                }
        }?:let { Toast.makeText(this, "No user account found", Toast.LENGTH_SHORT).show() }

    }

    private fun showDatePickerDialog() {
        val calendar = Calendar.getInstance()
        calendar.add(Calendar.YEAR, -18)
        val year = calendar.get(Calendar.YEAR)
        val month = calendar.get(Calendar.MONTH)
        val day = calendar.get(Calendar.DAY_OF_MONTH)

        val datePicker = DatePickerDialog(
             this,
            android.app.AlertDialog.THEME_HOLO_DARK,
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

    private fun customTextView(view: TextView) {
        val spanTxt = SpannableStringBuilder("By clicking Continue, you are indicating that you have read and agree to the ")
        spanTxt.append("Privacy policy")
        spanTxt.setSpan(object : ClickableSpan() {
            override fun onClick(widget: View) {
                shoWebPage("http://www.bigmoneyshot.com/privacy")
            }
        }, spanTxt.length - "Privacy policy".length, spanTxt.length, 0)
        spanTxt.append(" and ")
        spanTxt.append("Terms of Service")
        spanTxt.setSpan(object : ClickableSpan() {
            override fun onClick(widget: View) {
               shoWebPage("http://www.bigmoneyshot.com/terms")
            }
        }, spanTxt.length - "Terms of Service".length, spanTxt.length, 0)
        view.movementMethod = LinkMovementMethod.getInstance()
        view.setText(spanTxt, BufferType.SPANNABLE)
    }

    private fun shoWebPage(url: String) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.data = Uri.parse(url)
        startActivity(intent)
    }

}
