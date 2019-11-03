/* eslint-disable */
import web3 from './web3';

const address = '0x4B314C5815B55F05C731de0861E54782290bC1D0';
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
