import {
  Component,
  OnInit,
  AfterViewInit,
  ChangeDetectionStrategy,
  ChangeDetectorRef
} from "@angular/core";
import { egretAnimations } from "app/shared/animations/egret-animations";
import { Router } from "@angular/router";
import { AuthService } from "app/shared/services/auth.service";
import { AppLoaderService } from "app/shared/services/app-loader/app-loader.service";
import { CourseService } from "app/shared/services/api/course-service";
import { AdminService } from "app/shared/services/api/admin-service";
import { ReportService } from "app/shared/services/api/report-service";


const SALES_CHART_DAYS = 120;

@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
  styleUrls: ['./index.component.scss'],
  animations: egretAnimations
})
export class IndexComponent implements OnInit, AfterViewInit {

  course: any;
  salesChart: any;
  salesChartDays = SALES_CHART_DAYS;

  constructor(
    private router: Router,
    private authService: AuthService,
    private loader: AppLoaderService,
    private httpCourse: CourseService,
    private httpReport: ReportService,
    private cdr: ChangeDetectorRef
  ) { }

  ngAfterViewInit() { }

  ngOnInit() {
    this.getData();
  }

  goToCheckin() {
    this.router.navigate(['checkin'])
  }

  goToTournaments() {
    this.router.navigate(['tournaments'])
  }

  private async getData() {
    this.loader.open();
    await this.getCourseData();
    await this.getSalesData();
    this.cdr.detectChanges();
    this.loader.close();
  }

  private async getCourseData() {
    const claims = await this.authService.getClaims();
    this.course = await this.httpCourse.get(claims.courseId);
  }

  private async getSalesData() {
    var date = new Date();
    date.setDate(date.getDate() - this.salesChartDays);
    var claims = await this.authService.getClaims();
    var result = await this.httpReport.getPurchaseSummary(claims.courseId, date);
    result = result.sort((a, b) => {
      return +(new Date(a.date)) - +(new Date(b.date));
    });
    console.log('getPurchaseSummary', result);
    this.initSalesChart(result);
    this.cdr.detectChanges();
  }


  private initSalesChart(purchaseData: any[]) {
    if (!purchaseData || !purchaseData.length) {
      return;
    }

    var labels = [];
    var sales = [];


    var first = purchaseData[0];
    var firstDate = new Date(first.date);
    var interval = (firstDate.getMonth() + 1) + '-' + firstDate.getDate();;
    var salesInterval = first.amount;
    purchaseData.forEach((v, i) => {
      var d = new Date(v.date);
      var l = (d.getMonth() + 1) + '-' + d.getDate();

      if (interval != l) { //if new month_day

        labels.push(interval);
        sales.push(salesInterval / 100);

        interval = l;
        salesInterval = v.amount;
        return;
      }

      salesInterval = salesInterval + v.amount;
    });


    labels.push(interval);
    sales.push(salesInterval / 100);

    this.salesChart = {
      tooltip: {
        show: true,
        trigger: "axis",
        backgroundColor: "#fff",
        extraCssText: "box-shadow: 0 0 3px rgba(0, 0, 0, 0.3); color: #444",
        axisPointer: {
          type: "line",
          animation: true
        },
        formatter: "${c}"
      },
      grid: {
        top: "10%",
        left: "60",
        right: "20",
        bottom: "60"
      },
      xAxis: {
        type: "category",
        data: labels,
        axisLine: {
          show: false
        },
        axisLabel: {
          show: true,
          margin: 30,
          color: "#888"
        },
        axisTick: {
          show: false
        }
      },
      yAxis: {
        type: "value",
        axisLine: {
          show: false
        },
        axisLabel: {
          show: true,
          margin: 20,
          color: "#888",
          formatter: "${value}"
        },
        axisTick: {
          show: false,
        },
        splitLine: {
          show: true,
          lineStyle: {
            type: "dashed"
          }
        },
      },
      series: [
        {
          data: sales,
          type: "line",
          name: "Sales",
          smooth: true,
          color: "#42A5F5",
          lineStyle: {
            opacity: 1,
            width: 3
          },
          itemStyle: {
            opacity: 0
          },
          emphasis: {
            itemStyle: {
              color: "#42A5F5",
              borderColor: "rgba(3, 169, 244, .4)",
              opacity: 1,
              borderWidth: 8
            },
            label: {
              show: false,
              backgroundColor: "#fff"
            }
          }
        },
      ]
    };
  }

}