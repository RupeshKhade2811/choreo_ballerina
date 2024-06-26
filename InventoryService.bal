import big_billion_cars.inventory;
import big_billion_cars.searchFactory;

import big_billion_cars.model;
import ballerina/http;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:4200","http://10.175.1.71:4200","https://d7eaf07c-fb05-4851-88da-2e5dfd0cd730-dev.e1-us-cdp-2.choreoapis.dev/bigbillioncars/ballerinaservices/inventory-a4c/v1.0"],
        allowCredentials: false,
        allowHeaders: ["Content-Type","userId","id","API-Key","Authorization"],
        exposeHeaders: ["*"],
        maxAge: 84900
    }
}

service /inventory on httpl {
   

        isolated resource function post getInventoryCards(@http:Header string userId,int pageNumber,int pageSize) returns inventory:invntryCards|error {
         model:Appraisal[]|error invList = inventory:getInvList(userId,pageNumber,pageSize);
         int|error? totlRcd = model:getTotalRecords("inventory",false,userId);
         int pages = model:getPages(check totlRcd ?: 0);
         inventory:invntryCards  invntryCards = {cards : check invList, code : 200, message : "inventory cards success", status :true,totalRecords:check totlRcd ?: 0,totalPages:pages};
         return invntryCards;
        }

        isolated resource function post getSearchFactory(@http:Header string id,int pageNumber,int pageSize) returns inventory:srchFtryCards|error {
         model:AppraisalDto[]|error searchFacList = searchFactory:getSearchFacList(id, pageNumber,pageSize);
        int|error? totlRcd = model:getRecordsSrchFtry("inventory",false,id);
        int pages = model:getPages(check totlRcd ?: 0);
        inventory:srchFtryCards  srcgFtryCards = {cards : check searchFacList, code : 200,message:"serach Factory success", status:true,totalRecords:check totlRcd ?: 0,totalPages:pages};
        return srcgFtryCards;
    }


}
