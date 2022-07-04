import { Routes } from '@angular/router';
import { AdminLayoutComponent } from './shared/components/layouts/admin-layout/admin-layout.component';
import { AuthLayoutComponent } from './shared/components/layouts/auth-layout/auth-layout.component';
import { AuthGuard } from './shared/services/auth/auth.guard';
import { StartComponent } from './start.component';
import { LandingGuard } from './shared/services/auth/landing.guard';
import { ConfirmComponent } from './views/confirm/confirm.component';
import { CompleteComponent } from './views/confirm/complete/complete.component';

export const rootRouterConfig: Routes = [
  // {
  //   path: '',
  //   redirectTo: 'home',
  //   pathMatch: 'full',
  // },
  {
    path: 'home',
    loadChildren: () => import('./views/home/home.module').then(m => m.HomeModule),
    data: { title: 'Welcome to Big Money Shot' },
  },
  {
    path: 'start', //hack because path:'' not redirecting, works for detecting and redirecting a logged in user anyways, AppCoponent brute force redirects to start route
    component: StartComponent,
    canActivate: [LandingGuard]
  },
  {
    path: 'confirm/:id',
    component: ConfirmComponent
  },
  {
    path: 'confirm/complete/:id',
    component: CompleteComponent
  },
  {
    path: '',
    component: AdminLayoutComponent,
    canActivate: [AuthGuard],
    children: [
      {
        path: 'sandbox',
        loadChildren: () => import('./sandbox/sandbox.module').then(m => m.SandboxModule),
        data: { title: 'Welcome to Sandbox' },
      },]
  },
  {
    path: '',
    component: AuthLayoutComponent,
    children: [
      {
        path: 'sessions',
        loadChildren: () => import('./views/sessions/sessions.module').then(m => m.SessionsModule),
        data: { title: 'Session' }
      }
    ]
  },
  {
    path: '',
    component: AdminLayoutComponent,
    canActivate: [AuthGuard],
    children: [
      {
        path: 'dashboard',
        loadChildren: () => import('./views/dashboard/dashboard.module').then(m => m.DashboardModule),
        data: { title: 'Dashboard', breadcrumb: 'DASHBOARD' }
      }
    ]
  },
  {
    path: '',
    component: AdminLayoutComponent,
    canActivate: [AuthGuard],
    children: [
      {
        path: 'tournaments',
        loadChildren: () => import('./views/tournaments/tournaments.module').then(m => m.TournamentsModule),
        data: { title: 'Tournaments', breadcrumb: 'Tournaments' }
      }
    ]
  },
  {
    path: '',
    component: AdminLayoutComponent,
    canActivate: [AuthGuard],
    children: [
      {
        path: 'users',
        loadChildren: () => import('./views/users/users.module').then(m => m.UsersModule),
        data: { title: 'Manage Users', breadcrumb: 'Manage Users' }
      }
    ]
  },
  {
    path: '',
    component: AdminLayoutComponent,
    canActivate: [AuthGuard],
    children: [
      {
        path: 'checkin',
        loadChildren: () => import('./views/checkin/checkin.module').then(m => m.CheckinModule),
        data: { title: 'Check In', breadcrumb: 'Check In' }
      }
    ]
  },
  { path: '**', redirectTo: 'sessions/404' }
];

