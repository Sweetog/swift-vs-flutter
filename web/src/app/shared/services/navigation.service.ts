import { Injectable } from "@angular/core";
import { BehaviorSubject } from "rxjs";
import { AuthService } from "./auth.service";
import { isThisQuarter } from "date-fns";
import { Role } from "../const/role.const";

interface IMenuItem {
  type: string; // Possible values: link/dropDown/icon/separator/extLink
  name?: string; // Used as display text for item and title for separator type
  state?: string; // Router state
  icon?: string; // Material icon name
  tooltip?: string; // Tooltip text
  disabled?: boolean; // If true, item will not be appeared in sidenav.
  sub?: IChildItem[]; // Dropdown items
  badges?: IBadge[];
}
interface IChildItem {
  type?: string;
  name: string; // Display text
  state?: string; // Router state
  icon?: string;
  sub?: IChildItem[];
}

interface IBadge {
  color: string; // primary/accent/warn/hex color codes(#fff000)
  value: string; // Display text
}

@Injectable()
export class NavigationService {
  constructor(private authService: AuthService) {
    this.authService.getClaims().then((claims) => {
      console.log('NavigationService getClaims', claims);
      this.publishNavigationChange(claims.role)
    });
  }

  playerMenu: IMenuItem[] = [
    {
      name: "Dashboard",
      type: "link",
      tooltip: "Dashboard",
      icon: "dashboard",
      state: "dashboard"
    },
  ];

  courseUser: IMenuItem[] = [
    {
      name: "Dashboard",
      type: "link",
      tooltip: "Dashboard",
      icon: "dashboard",
      state: "dashboard"
    },
    {
      name: "Check In Players",
      type: "link",
      tooltip: "Check In Players",
      icon: "flag",
      state: "checkin"
    },
    {
      name: "Tournaments",
      type: "link",
      tooltip: "Schedule Tournament",
      icon: "local_play",
      state: "tournaments"
    }
  ];

  adminMenu: IMenuItem[] = [
    {
      name: "Dashboard",
      type: "link",
      tooltip: "Dashboard",
      icon: "dashboard",
      state: "dashboard"
    },
    {
      name: "Check In Players",
      type: "link",
      tooltip: "Check In Players",
      icon: "flag",
      state: "checkin"
    },
    {
      name: "Tournaments",
      type: "link",
      tooltip: "Schedule Tournament",
      icon: "local_play",
      state: "tournaments"
    },
    {
      name: "Manage Users",
      type: "link",
      tooltip: "Manage Users",
      icon: "group",
      state: "users"
    },
  ];

  // Icon menu TITLE at the very top of navigation.
  // This title will appear if any icon type item is present in menu.
  iconTypeMenuTitle: string = "Frequently Accessed";
  // sets iconMenu as default;
  menuItems = new BehaviorSubject<IMenuItem[]>(this.playerMenu);
  // navigation component has subscribed to this Observable
  menuItems$ = this.menuItems.asObservable();

  // Customizer component uses this method to change menu.
  // You can remove this method and customizer component.
  // Or you can customize this method to supply different menu for
  // different user type.

  publishNavigationChange(menuType: string) {
    switch (menuType) {
      case Role.admin:
      case Role.courseAdmin:
        this.menuItems.next(this.adminMenu);
        break;
      case Role.courseUser:
        this.menuItems.next(this.courseUser);
        break;
      default:
        this.menuItems.next(this.playerMenu);
    }
  }
}
