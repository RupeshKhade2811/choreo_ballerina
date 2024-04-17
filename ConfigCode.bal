import ballerina/http;
import big_billion_cars.configuration;



@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:4200","http://10.175.1.71:4200","https://d7eaf07c-fb05-4851-88da-2e5dfd0cd730-dev.e1-us-cdp-2.choreoapis.dev"],
        allowCredentials: false,
        allowHeaders: ["Content-Type","userId"],
        exposeHeaders: ["*"],
        maxAge: 84900
    }
}

service /configcodes on httpl {

    isolated resource function post addConfig(configuration:ConfigCode config)returns int|error? {
        return configuration:addConfigCode(config);
    }

     isolated resource function post dropDowns()returns configuration:DropDown|error {
        configuration:ConfigCode[]|error? extrClrList = configuration:getExtrClrList();
         configuration:ConfigCode[]|error? intrClrList = configuration:getIntrClrList();
         configuration:DropDown  drop = {vehicleIntrColor : check intrClrList ?: [],vehicleExtrColor: check extrClrList ?: []};
         return drop;
     }

}