/* eslint-disable */
import web3 from './web3';

//const address = '0x0c5afD3E93a287036b77672E525C4A58AbeF131f';
const abi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "CCtitle",
				"type": "string"
			},
			{
				"name": "CCdescription",
				"type": "string"
			},
			{
				"name": "CCdurationInDays",
				"type": "uint256"
			},
			{
				"name": "CCamountToRaise",
				"type": "uint256"
			}
		],
		"name": "startProject",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "crowdfundingStarter",
				"type": "address"
			},
			{
				"name": "crowdfundingTitle",
				"type": "string"
			},
			{
				"name": "crowdfundingDesc",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "contractAddress",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "projectStarter",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "projectTitle",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "projectDesc",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "deadline",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "goalAmount",
				"type": "uint256"
			}
		],
		"name": "ProjectStarted",
		"type": "event"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "CFcreator",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "CFdescription",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "CFparentContractAddress",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "CFtitle",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getDetails",
		"outputs": [
			{
				"name": "crowdfundingStarter",
				"type": "address"
			},
			{
				"name": "crowdfundingTitle",
				"type": "string"
			},
			{
				"name": "crowdfundingDesc",
				"type": "string"
			},
			{
				"name": "crowdfundingParentContractAddress",
				"type": "address"
			},
			{
				"name": "crowdfundingMyContractAddress",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "returnAllProjects",
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


export default (address) => {
    const instance = new web3.eth.Contract(abi, address);
    return instance;
  };

//const instance = new web3.eth.Contract(abi, address);
//export default instance;

