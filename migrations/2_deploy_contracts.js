const CredentialVerification = artifacts.require("CredentialVerification");
const JobAgreements = artifacts.require("JobAgreements");
const PaymentSystem = artifacts.require("PaymentSystem");

module.exports = async function (deployer) {
  await deployer.deploy(CredentialVerification);
  await deployer.deploy(JobAgreements);
  await deployer.deploy(PaymentSystem, JobAgreements.address);
};
