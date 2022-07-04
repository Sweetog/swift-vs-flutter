package com.bigmoneyshot.android.ui.stripe.controllers;

import androidx.annotation.NonNull;
import androidx.fragment.app.DialogFragment;
import androidx.fragment.app.FragmentManager;
import com.bigmoneyshot.android.R;
import com.bigmoneyshot.android.ui.stripe.dialog.ErrorDialogFragment;


/**
 * A convenience class to handle displaying error dialogs.
 */
public class ErrorDialogHandler {

    @NonNull
    private final FragmentManager mFragmentManager;

    public ErrorDialogHandler(@NonNull FragmentManager fragmentManager) {
        mFragmentManager = fragmentManager;
    }

    public void showError(@NonNull String errorMessage) {
        DialogFragment fragment = ErrorDialogFragment.newInstance(
                R.string.validationErrors, errorMessage);
        fragment.show(mFragmentManager, "error");
    }
}
