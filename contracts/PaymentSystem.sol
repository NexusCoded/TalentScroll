// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./JobAgreements.sol";

contract PaymentSystem {
    JobAgreements public jobAgreements;

    constructor(address _jobAgreements) {
        jobAgreements = JobAgreements(_jobAgreements);
    }

    event PaymentReleased(uint256 indexed jobId, address indexed employer, address indexed professional, uint256 amount);

    function releasePayment(uint256 _jobId) public payable {
        JobAgreements.JobAgreement memory agreement = jobAgreements.getJobAgreement(_jobId);
        require(agreement.completed, "Job agreement is not completed");
        require(msg.sender == agreement.employer, "Only the employer can release payment");
        require(msg.value == agreement.payment, "Incorrect payment amount");

        payable(agreement.professional).transfer(msg.value);
        emit PaymentReleased(_jobId, msg.sender, agreement.professional, msg.value);
    }
}
