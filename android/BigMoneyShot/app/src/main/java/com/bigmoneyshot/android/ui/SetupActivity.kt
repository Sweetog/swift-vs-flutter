package com.bigmoneyshot.android.ui

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.bigmoneyshot.android.R
import com.bigmoneyshot.android.ui.activities.MainActivity
import kotlinx.android.synthetic.main.activity_setup.*

class SetupActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_setup)

        text_view_setup_later.setOnClickListener {
            startActivity(Intent(this, MainActivity::class.java))
        }
    }
}
