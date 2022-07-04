import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { environment } from '../../../../environments/environment';
import { Tournament } from '../../models/tournament.model';
import { AuthService } from '../auth.service';
import { User } from 'app/shared/models/user.model';
import { PagedData } from 'app/shared/models/paged-data.model';
import { Page } from 'app/shared/models/page.model';

@Injectable({
    providedIn: 'root'
})
export class UsersService {
    url = environment.apiURL;

    constructor(private http: HttpClient, private auth: AuthService) { }

    async get(uid: string): Promise<any> {
        const headers = await this.createHeaders();
        let u = this.url + '/v2/user?uid=' + uid;

        try {
            let result = await this.http.get<any>(u, { headers: headers }).toPromise<any>();
            return result;
        }
        catch (error) {
            console.error(error.message);
            return error.message;
        }
    }

    async getUsers(page: Page): Promise<PagedData<any>> {
        const headers = await this.createHeaders();
        let u = this.url + '/v2/users?pageSize=' + page.size;

        let nextPageToken = page.pageTokens[page.offset];

        if (nextPageToken) {
            u = u + '&nextPageToken=' + nextPageToken;
        }

        let promise = new Promise<PagedData<any>>(async (resolve, reject) => {
            try {
                let result = await this.http.get<any>(u, { headers: headers }).toPromise<any>();
                var pd = new PagedData<any>();
                pd.data = result.users;
                pd.page = page;
                pd.page.count = result.count;
                pd.page.pageTokens[pd.page.offset + 1] = result.nextPageToken;
                resolve(pd);
            }
            catch (error) {
                console.error(error.message);
                reject();
            }
        });
        // if (nextPageToken) {
        //     u = u + '&nextPageToken=' + nextPageToken;
        // }

        return promise;
    }


    async getUsersv1(pageSize: number, nextPageToken?: any): Promise<any[]> {
        const headers = await this.createHeaders();
        let u = this.url + '/v2/users?pageSize=' + pageSize;

        if (nextPageToken) {
            u = u + '&nextPageToken=' + nextPageToken;
        }

        try {
            let result = await this.http.get<any>(u, { headers: headers }).toPromise<any>();
            console.log('pageToken', result.nextPageToken);
            return result.users;
        }
        catch (error) {
            console.error(error.message);
            return error.message;
        }
    }

    async add(data: any): Promise<string> {
        const headers = await this.createHeaders();

        try {
            await this.http.post<any>(this.url + '/v2/user', data, { headers: headers }).toPromise<any>();
            return 'success';
        }
        catch (error) {
            console.error(error.message);
            return error.message;
        }
    }

    async update(data: any): Promise<string> {
        const headers = await this.createHeaders();

        try {
            await this.http.put<any>(this.url + '/v2/user', data, { headers: headers }).toPromise<any>();
            return 'success';
        }
        catch (error) {
            console.error(error.message);
            return error.message;
        }
    }

    async delete(id: string): Promise<string> {
        const headers = await this.createHeaders();
        const options = {
            headers: headers,
            body: {
                id: id,
            },
        };

        try {
            await this.http.delete<any>(this.url + '/v2/user', options).toPromise<void>();
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
