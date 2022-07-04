import { Component, OnInit } from '@angular/core';

/**
 * Nothing but a dummy component for the path:'' hack
 */
@Component({
  selector: 'app-test',
  template: '<div>hello world</div>'
})
export class StartComponent implements OnInit {

  constructor() { }

  ngOnInit() {
    console.log('ngOnInit TestComponent');
  }

}
