import ballerinax/aws.s3 as s3;
import ballerina/io;
import ballerina/http;
import big_billion_cars.model;
import ballerina/uuid;
import ballerina/log;
import ballerina/file;
import big_billion_cars.dbconnection;






public isolated function uploadImage(http:Request request) returns model:Response|error{

    s3:ConnectionConfig amazonS3Config = {
    accessKeyId: dbconnection:accessKeyId,
    secretAccessKey: dbconnection:secretAccessKey,
    region: dbconnection:region
    };
    s3:Client amazonS3Client  = check new(amazonS3Config);
    string bucketName = "bigbillioncars/images";

    string uuid4 = uuid:createType4AsString();
    stream<byte[], io:Error?> streamer = check request.getByteStream();

    check io:fileWriteBlocksFromStream("/tmp/"+"upload.jpg", streamer);

    string imageFolder="/tmp/";
    string imagePath = imageFolder+ "upload.jpg";
    byte[] bytes = check io:fileReadBytes(imagePath);

    s3:CannedACL? cannedACL = s3:ACL_PRIVATE;
    error? uploadError = amazonS3Client->createObject(bucketName, uuid4+".jpg", bytes, cannedACL);

    check streamer.close();
    check file:remove("/tmp/upload.jpg");

    if (uploadError is error) {
        io:println("Error uploading image: " + uploadError.message());
        return uploadError;
    } else {
        io:println("Image uploaded successfully.");
        model:Response resp = {message:uuid4+".jpg", code:200, status:true};
        return resp;
    }   

}


public isolated function downloadImage(string imageName) returns byte[]|byte[]?|error {
    s3:ConnectionConfig amazonS3Config = {
   accessKeyId: dbconnection:accessKeyId,
    secretAccessKey: dbconnection:secretAccessKey,
    region: dbconnection:region
    };
    s3:Client amazonS3Client  =check new(amazonS3Config);
    string bucketName = "bigbillioncars/images";
    int? byteArraySize = 1024;

     stream<byte[], io:Error?>|error getObjectResponse = amazonS3Client->getObject(bucketName, imageName, (), byteArraySize);
     
     if (getObjectResponse is stream<byte[], io:Error?>) {
        error? err = getObjectResponse.forEach(isolated function(byte[] res) {
            error? writeRes = io:fileWriteBytes("/tmp/download.jpg", res, io:APPEND);
        });
    } else {
        log:printError("Error: " + getObjectResponse.toString());
    }

    string imageFolder="/tmp/";
    string imagePath = imageFolder+ "download.jpg";
    byte[] bytes = check io:fileReadBytes(imagePath);

    check file:remove("/tmp/download.jpg");

    return bytes;


}


// public isolated function downloadImage(string imageName) returns byte[]|byte[]?|error {
//     s3:ConnectionConfig amazonS3Config = {
//    accessKeyId: dbconnection:accessKeyId,
//     secretAccessKey: dbconnection:secretAccessKey,
//     region: dbconnection:region
//     };
//     s3:Client amazonS3Client  =check new(amazonS3Config);
//     string bucketName = "bigbillioncars/images";
//     int? byteArraySize = 1024;

//      stream<byte[], io:Error?>|error getObjectResponse = amazonS3Client->getObject(bucketName, imageName, (), byteArraySize);
     
//      if (getObjectResponse is stream<byte[], io:Error?>) {
//         error? err = getObjectResponse.forEach(isolated function(byte[] res) {
//             do {
// 	            string tmpFile = check file:createTemp(prefix = "myTempFile");
//                 error? writeRes = io:fileWriteBytes(tmpFile+".jpg", res, io:APPEND);
//             } on fail var e {
//             	io:println("Error writing to temporary file:", e.toString());
//             }

    
//         });
//     } else {
//         log:printError("Error: " + getObjectResponse.toString());
//     }

//     string tmpFile = check file:createTemp();
//     string imagePath = tmpFile;
//     byte[] bytes = check io:fileReadBytes(imagePath);

//     check file:remove(tmpFile+"imageName.jpg");

//     return bytes;
// }


// public isolated function downloadImage(string imageName) returns byte[]|error {
//     s3:ConnectionConfig amazonS3Config = {
//    accessKeyId: dbconnection:accessKeyId,
//     secretAccessKey: dbconnection:secretAccessKey,
//     region: dbconnection:region
//     };
//     s3:Client amazonS3Client  =check new(amazonS3Config);
//     string bucketName = "bigbillioncars/images";
//     int? byteArraySize = 1024;

//      stream<byte[], io:Error?>|error getObjectResponse = amazonS3Client->getObject(bucketName, imageName, (), byteArraySize);

//         if (getObjectResponse is stream<byte[], io:Error?>) {
//             error? err = getObjectResponse.forEach(isolated function(byte[] res) {
//             // error? writeRes = io:fileWriteBytes("/files/download.jpg", res, io:APPEND);
                                            
//                    do {	           	            
//                         string tmpFile = check file:createTemp();                                                                     
//                         error? writeRes = io:fileWriteBytes(tmpFile+"/download.jpg", res, io:APPEND);                                                       
                                                
//                     } on fail var e {
//                          io:println("Error writing to temporary file:", e.toString());
//                                                     }                                                  
//                      });
//                 } else {
//                    log:printError("Error: " + getObjectResponse.toString());
//                  }        

//                 // check file:remove("/files/download.jpg");
//                 string tmpFile = check file:createTemp();
//                 string imagePath = tmpFile;
//                 byte[] bytes = check io:fileReadBytes(imagePath);  
//                 return bytes;         

// }








