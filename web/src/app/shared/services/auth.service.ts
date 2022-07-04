import { Injectable } from '@angular/core';
import { AngularFireAuth } from "@angular/fire/auth";
import { Observable } from 'rxjs';
import { tap, map, take } from 'rxjs/operators';
import { Router } from '@angular/router';
import { User, auth } from 'firebase/app';
import { Role } from '../const/role.const';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  user: Observable<User>

  constructor(
    private firBase: AngularFireAuth,
    private router: Router // Inject Firebase auth service
  ) {
    this.user = this.firBase.authState;
  }

  isLoggedIn(redirectUrl: string, isLoggedInRedirect?: string): Observable<boolean> {
    return this.user.pipe(
      take(1),
      map(authState => !!authState),
      tap(authenticated => {
        if (!authenticated) {
          this.router.navigate([redirectUrl]);
          return;
        }
        if (isLoggedInRedirect) {
          this.router.navigate([isLoggedInRedirect]);
        }
      })
    );
  }

  getDisplayName(): string {
    return this.firBase.auth.currentUser.displayName;
  }

  getBearerToken(): Promise<string> {
    if (!this.firBase.auth.currentUser) {
      console.log('getBearerToken() -> user not logged in');
      return;
    }
    return this.firBase.auth.currentUser.getIdToken();
  }

  async getClaims(): Promise<any> {
    var result = await this.firBase.auth.currentUser.getIdTokenResult();
    return result.claims;
  }

  async isInRole(role: string): Promise<boolean> {
    var claims = await this.getClaims();
    return (claims.role === role);
  }

  // Sign up with email/password
  async signUp(email: string, password: string) {
    try {
      const result = await this.firBase.auth.createUserWithEmailAndPassword(email, password);
      console.log("successfully registered!");
      console.log(result.user);
    }
    catch (error) {
      console.error(error.message);
    }
  }

  // Sign in with email/password
  async signIn(email: string, password: string, rememberMe: boolean): Promise<string> {
    let session = 'session'; //only persist in the current session or tab, and will be cleared when the tab or window in which the user authenticated is closed

    if (rememberMe) {
      session = 'local'; //state will be persisted even when the browser window is closed or the activity
    }

    console.log('persistence type', session);
    try {
      const _ = await this.firBase.auth.setPersistence(session);
      const result = await this.firBase.auth.signInWithEmailAndPassword(email, password);
      console.log('signin success', result);
      return 'success';
    }
    catch (error) {
      console.error(error.message);
      return error.message;
    }
  }

  async signOut() {
    try {
      const _ = await this.firBase.auth.signOut();
      this.user = this.firBase.authState;
      console.log('signOut complete, currentUser', this.firBase.auth.currentUser);
    }
    catch (error) {
      console.error(error.message);
    }
  }

  async forgotPassword(email: string): Promise<string> {
    try {
      await this.firBase.auth.sendPasswordResetEmail(email);
      return 'Reset Email Sent';
    }
    catch (error) {
      console.error(error.message);
      return error.message;
    }
  }
}