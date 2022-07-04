package com.bigmoneyshot.android

import android.os.Bundle
import android.text.SpannableStringBuilder
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.view.View
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class Test :AppCompatActivity()
{
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.layout_signin)
        /*val privacyTextView: TextView = disclaimer
        customTextView(privacyTextView)*/
    }
    private fun customTextView(view: TextView) {
        val spanTxt = SpannableStringBuilder("By clicking Continue, you are indicating that you have read and agree to the ")
        spanTxt.append("Privacy policy")
        spanTxt.setSpan(object : ClickableSpan() {
            override fun onClick(widget: View) {
                //shoWebPage("http://www.bigmoneyshot.com/privacy")
            }
        }, spanTxt.length - "Privacy policy".length, spanTxt.length, 0)
        spanTxt.append(" and ")
        spanTxt.append("Terms of Service")
        spanTxt.setSpan(object : ClickableSpan() {
            override fun onClick(widget: View) {
               // shoWebPage("http://www.bigmoneyshot.com/terms")
            }
        }, spanTxt.length - "Terms of Service".length, spanTxt.length, 0)
        view.movementMethod = LinkMovementMethod.getInstance()
        view.setText(spanTxt, TextView.BufferType.SPANNABLE)
    }
}