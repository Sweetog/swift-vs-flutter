package com.bigmoneyshot.android.ui.stripe.controllers;

import android.content.Context;
import android.widget.Button;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.jakewharton.rxbinding.view.RxView;
import com.stripe.android.PaymentConfiguration;
import com.stripe.android.Stripe;
import com.stripe.android.model.Card;
import com.stripe.android.model.Token;
import com.stripe.android.view.CardInputWidget;
import rx.Observable;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Action0;
import rx.functions.Action1;
import rx.schedulers.Schedulers;
import rx.subscriptions.CompositeSubscription;

import java.util.concurrent.Callable;

/**
 * Class containing all the logic needed to create a token and listen for the results using
 * RxJava.
 */
public class RxTokenController {

    @NonNull
    private final CompositeSubscription mCompositeSubscription;
    @NonNull
    private final Context mContext;
    @NonNull
    private final ErrorDialogHandler mErrorDialogHandler;
    @NonNull
    private final ListViewController mOutputListController;
    @NonNull
    private final ProgressDialogController mProgressDialogController;

    @Nullable
    private CardInputWidget mCardInputWidget;

    public RxTokenController(
            @NonNull Button button,
            @NonNull CardInputWidget cardInputWidget,
            @NonNull Context context,
            @NonNull ErrorDialogHandler errorDialogHandler,
            @NonNull ListViewController outputListController,
            @NonNull ProgressDialogController progressDialogController) {
        mCompositeSubscription = new CompositeSubscription();

        mCardInputWidget = cardInputWidget;
        mContext = context;
        mErrorDialogHandler = errorDialogHandler;
        mOutputListController = outputListController;
        mProgressDialogController = progressDialogController;

        mCompositeSubscription.add(
                RxView.clicks(button).subscribe(new Action1<Void>() {
                    @Override
                    public void call(Void aVoid) {
                        saveCard();
                    }
                })
        );
    }

    /**
     * Release subscriptions to prevent memory leaks.
     */
    public void detach() {
        mCompositeSubscription.unsubscribe();
        mCardInputWidget = null;
    }

    private void saveCard() {
        final Card cardToSave = mCardInputWidget.getCard();
        if (cardToSave == null) {
            mErrorDialogHandler.showError("Invalid Card Data");
            return;
        }
        final Stripe stripe = new Stripe(mContext);

        // Note: using this style of Observable creation results in us having a method that
        // will not be called until we subscribe to it.
        final Observable<Token> tokenObservable =
                Observable.fromCallable(
                        new Callable<Token>() {
                            @Override
                            public Token call() throws Exception {
                                return stripe.createTokenSynchronous(cardToSave,
                                        PaymentConfiguration.getInstance().getPublishableKey());
                            }
                        });

        mCompositeSubscription.add(tokenObservable
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .doOnSubscribe(
                        new Action0() {
                            @Override
                            public void call() {
                                mProgressDialogController.startProgress();
                            }
                        })
                .doOnUnsubscribe(
                        new Action0() {
                            @Override
                            public void call() {
                                mProgressDialogController.finishProgress();
                            }
                        })
                .subscribe(
                        new Action1<Token>() {
                            @Override
                            public void call(Token token) {
                                mOutputListController.addToList(token);
                            }
                        },
                        new Action1<Throwable>() {
                            @Override
                            public void call(Throwable throwable) {
                                mErrorDialogHandler.showError(throwable.getLocalizedMessage());
                            }
                        }));
    }
}
