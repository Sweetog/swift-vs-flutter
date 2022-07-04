/**
 * An object used to get page information from the server
 */
export class Page {
    //The number of elements in the page
    size: number = 0;
    //The total number of elements
    count: number = 0;
    //The current page number
    offset: number = 0;
    //Firebase pageToken cache
    pageTokens: string[] = [];
}