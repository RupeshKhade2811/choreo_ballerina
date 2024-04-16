import ballerina/lang.runtime;
import ballerina/task;
import ballerina/email;
import big_billion_cars.user;
import big_billion_cars.dbconnection;
import big_billion_cars.model;



email:SmtpConfiguration smtpConfig = {
    port: 465
};

string host = dbconnection:host;
string mail = dbconnection:mailId;
string mailPswd = dbconnection:mailSmtpPswd;


class MailJob{
    public function greetingService() returns error?{

    model:Appraisal[]|error invJobList = model:getInvJobList();

    from model:Appraisal user in check invJobList
        do {
            user:Users users = check user:getUsers(<string>user.user_id);
            string gmail=users.email;

                email:SmtpClient smtpClient = check new (host, mail, mailPswd, smtpConfig);
                email:Message email = {
                to: gmail,
                subject: "Suggestion from Big Billion Cars",
                body: "Thanks for using BBC, your car isn't sold since 30 days, Please consider reducing your price to facilitate a quicker sale of your car...",
                'from: "yudhistervijay@gmail.com"
                };
                check smtpClient->sendMessage(email);
        };
    }
}



class Job {

    *task:Job;

    public function execute() {
        MailJob mailJob = new;
        error? greetingService = mailJob.greetingService();
    }
}

public function main() returns error? {

    // Schedules the task to execute the job every second.
    task:JobId id = check task:scheduleJobRecurByFrequency(new Job(), 86400);

    // Waits for nine seconds.
    runtime:sleep(9);

    // Unschedules the job.
    check task:unscheduleJob(id);
}

