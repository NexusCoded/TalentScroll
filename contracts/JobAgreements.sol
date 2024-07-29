// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract JobAgreements {
    struct JobAgreement {
        address employer;
        address professional;
        string jobDetails;
        uint256 payment;
        bool completed;
    }

    JobAgreement[] public jobAgreements;

    event JobAgreementCreated(uint256 indexed jobId, address indexed employer, address indexed professional, string jobDetails, uint256 payment);
    event JobAgreementCompleted(uint256 indexed jobId);

    function createJobAgreement(address _professional, string memory _jobDetails, uint256 _payment) public {
        jobAgreements.push(JobAgreement({
            employer: msg.sender,
            professional: _professional,
            jobDetails: _jobDetails,
            payment: _payment,
            completed: false
        }));
        emit JobAgreementCreated(jobAgreements.length - 1, msg.sender, _professional, _jobDetails, _payment);
    }

    function completeJobAgreement(uint256 _jobId) public {
        require(jobAgreements[_jobId].professional == msg.sender, "Only the assigned professional can complete the job");
        jobAgreements[_jobId].completed = true;
        emit JobAgreementCompleted(_jobId);
    }

    function getJobAgreement(uint256 _jobId) public view returns (JobAgreement memory) {
        return jobAgreements[_jobId];
    }
}
