// scripts/deployContracts.js
const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');
const path = require('path');
const fs = require('fs');

// Load compiled contracts
const credentialVerificationPath = path.resolve(__dirname, '../build/contracts/CredentialVerification.json');
const jobAgreementsPath = path.resolve(__dirname, '../build/contracts/JobAgreements.json');
const paymentSystemPath = path.resolve(__dirname, '../build/contracts/PaymentSystem.json');

const CredentialVerification = JSON.parse(fs.readFileSync(credentialVerificationPath, 'utf8'));
const JobAgreements = JSON.parse(fs.readFileSync(jobAgreementsPath, 'utf8'));
const PaymentSystem = JSON.parse(fs.readFileSync(paymentSystemPath, 'utf8'));

const mnemonic = 'auction sport bomb ball clump bring turkey text spider tape because hole';
const provider = new HDWalletProvider(mnemonic, 'https://rpc.scroll.io/');
const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();
    console.log('Attempting to deploy from account', accounts[0]);

    // Deploy CredentialVerification
    const credentialVerification = await new web3.eth.Contract(CredentialVerification.abi)
        .deploy({ data: CredentialVerification.bytecode })
        .send({ from: accounts[0], gas: '5000000' });
    console.log('CredentialVerification deployed to', credentialVerification.options.address);

    // Deploy JobAgreements
    const jobAgreements = await new web3.eth.Contract(JobAgreements.abi)
        .deploy({ data: JobAgreements.bytecode })
        .send({ from: accounts[0], gas: '5000000' });
    console.log('JobAgreements deployed to', jobAgreements.options.address);

    // Deploy PaymentSystem with JobAgreements address
    const paymentSystem = await new web3.eth.Contract(PaymentSystem.abi)
        .deploy({ data: PaymentSystem.bytecode, arguments: [jobAgreements.options.address] })
        .send({ from: accounts[0], gas: '5000000' });
    console.log('PaymentSystem deployed to', paymentSystem.options.address);

    provider.engine.stop();
};

deploy();
