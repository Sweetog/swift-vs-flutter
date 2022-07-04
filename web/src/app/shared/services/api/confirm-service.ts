
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../../../environments/environment';
import { AuthService } from '../auth.service';

@Injectable({
    providedIn: 'root'
})
export class ConfirmService {
    url = environment.apiURL;

    constructor(private http: HttpClient, private auth: AuthService) { }


    async confirm(checkinId: string, firstName: string, lastName: string, email: string): Promise<string> {
        const headers = await this.createHeaders();

        try {
            await this.http.post<any>(this.url + '/confirm', { checkinId: checkinId, firstName: firstName, lastName: lastName, email: email }, { headers: headers }).toPromise<void>();
            return 'success';
        }
        catch (error) {
            console.error(error.message);
            return error.message;
        }
    }

    private async createHeaders() {
        var token = await this.auth.getBearerToken();

        return new HttpHeaders({
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + token
        });
    }
}
