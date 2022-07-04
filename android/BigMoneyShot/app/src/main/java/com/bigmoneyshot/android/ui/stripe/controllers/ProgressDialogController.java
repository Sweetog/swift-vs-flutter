package com.bigmoneyshot.android.ui.stripe.controllers;

import androidx.annotation.NonNull;
import androidx.annotation.StringRes;
import androidx.fragment.app.FragmentManager;
import com.bigmoneyshot.android.R;
import com.bigmoneyshot.android.ui.stripe.dialog.ProgressDialogFragment;


/**
 * Class used to show and hide the progress spinner.
 */
public class ProgressDialogController {

    @NonNull
    private final FragmentManager mFragmentManager;
    private ProgressDialogFragment mProgressFragment;

    public ProgressDialogController(@NonNull FragmentManager fragmentManager) {
        mFragmentManager = fragmentManager;
        mProgressFragment = ProgressDialogFragment.newInstance(R.string.progressMessage);
    }

    public void setMessageResource(@StringRes int resId) {
        if (mProgressFragment.isVisible()) {
            mProgressFragment.dismiss();
            mProgressFragment = null;
        }
        mProgressFragment = ProgressDialogFragment.newInstance(resId);
    }

    public void startProgress() {
        mProgressFragment.show(mFragmentManager, "progress");
    }

    public void finishProgress() {
        mProgressFragment.dismiss();
    }
}
