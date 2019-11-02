/* eslint-disable */
import web3 from './web3';

const address = '0xB3bE2e33E07DBfe808f8718fe9e22De4C78e98e5';
const abi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "crowdfundingTitle",
				"type": "string"
			},
			{
				"name": "crowdfundingDescription",
				"type": "string"
			}
		],
		"name": "startCrowdfunding",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "crowdfundingAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "crowdfundingStarter",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "crowdfundingTitle",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "crowdfundingDesc",
				"type": "string"
			}
		],
		"name": "CrowdfundingStarted",
		"type": "event"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "returnAllCrowdfundings",
		"outputs": [
			{
				"name": "",
				"type": "address[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];

const instance = new web3.eth.Contract(abi, address);

export default instance;
