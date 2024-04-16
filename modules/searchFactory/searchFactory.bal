import ballerina/sql;
import big_billion_cars.dbconnection;
import big_billion_cars.model;
import ballerina/time;

public isolated function vehicleBuy(int appr_id,string buyerUser_id) returns string|error {
    time:Utc currTime = time:utcNow();
    boolean soldStatus=true;
    sql:ExecutionResult _ = check dbconnection:dbClient->execute(
        `UPDATE big_billion_cars."Appraisal"
	SET "soldOut"=${soldStatus}, "buyerUser_id"=${buyerUser_id},"createdOn"=${currTime} WHERE id=${appr_id} AND is_active=true`);

    return "car purchase successfully";
}

public isolated function getSearchFacList(string user_id,int pageNumber,int pageSize) returns model:AppraisalDto[]|error {
    int offset = pageNumber * pageSize;
    string invSts = "inventory";
    model:AppraisalDto[] apprs = [];
    stream<model:AppraisalDto, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."Appraisal" a where "invntrySts"= ${invSts} and "soldOut" = false
        and "user_id" <> ${user_id} and is_active = true ORDER BY a."createdOn" DESC LIMIT ${pageSize} OFFSET ${offset}`
    );
    check from model:AppraisalDto appr in resultStream
        do {    
            int apprId = appr.id;               
            int count = check dbconnection:dbClient->queryRow(
        `SELECT count(*) FROM big_billion_cars."FavVeh" fv where appr_id= ${apprId} and "user_id" = ${user_id} `
        );

        if(count == 0 ){
            appr.isVehicleFav = false;
        }else{
        boolean favVeh = check dbconnection:dbClient->queryRow(
        `SELECT fv."isVehicleFav" FROM big_billion_cars."FavVeh" fv where appr_id= ${apprId} and "user_id" = ${user_id} `
        );
        appr.isVehicleFav = favVeh;
        }
        apprs.push(appr);           
        };
    check resultStream.close();
    return apprs;
}

public isolated function getMyPurList(string user_id,int pageNumber,int pageSize) returns model:Appraisal[]|error {
    int offset = pageNumber * pageSize;
    model:Appraisal[] apprs = [];
    string invSts = "inventory";
    stream<model:Appraisal, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."Appraisal" WHERE "buyerUser_id" = ${user_id} AND "invntrySts"=${invSts}
        AND "soldOut" =true AND is_active=true ORDER BY "createdOn" DESC LIMIT ${pageSize} OFFSET ${offset}`
    );
    check from model:Appraisal appr in resultStream
        do {
            apprs.push(appr);
        };
    check resultStream.close();
    return apprs;
}

public isolated function getMySalesList(string user_id,int pageNumber,int pageSize) returns model:Appraisal[]|error {
    int offset = pageNumber * pageSize;
    model:Appraisal[] apprs = [];
    string invSts = "inventory";
    stream<model:Appraisal, error?> resultStream = dbconnection:dbClient->query(
        `SELECT * FROM big_billion_cars."Appraisal" WHERE "user_id" = ${user_id} AND "invntrySts"=${invSts}
        AND "soldOut" =true AND is_active=true ORDER BY "createdOn" DESC LIMIT ${pageSize} OFFSET ${offset}`
    );
    check from model:Appraisal appr in resultStream
        do {
            apprs.push(appr);
        };
    check resultStream.close();
    return apprs;
}
