<script>
    import { onMount } from 'svelte';
    import axios from "axios";
    import { env } from '$env/dynamic/public';
    import { ethers } from "ethers";

    export let API_PREFIX = env.PUBLIC_API_PREFIX;
    //export let NETWORK = env.PUBLIC_NETWORK || "Ethereum Mainnet";
    export let EXPLORER_PREFIX = env.PUBLIC_EXPLORER_PREFIX || "https://etherscan.io";
    export let RPC = env.PUBLIC_RPC;
    console.log('got RPC', RPC);

    let provider = new ethers.JsonRpcProvider(RPC);
    const ABI=[
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "epochEnd",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "dagCid",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "AggregateDagCidFinalized",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "epochEnd",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "dagCid",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "AggregateDagCidSubmitted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "epochEnd",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "aggregateCid",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "AggregateFinalized",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "snapshotterAddr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "aggregateCid",
				"type": "string"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "AggregateSubmitted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "epochEnd",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "dagCid",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "DagCidFinalized",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "snapshotterAddr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "aggregateCid",
				"type": "string"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "DelayedAggregateSubmitted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "snapshotterAddr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "indexTailDAGBlockHeight",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "bytes32",
				"name": "indexIdentifierHash",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "DelayedIndexSubmitted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "snapshotterAddr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "snapshotCid",
				"type": "string"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "DelayedSnapshotSubmitted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "begin",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "end",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "EpochReleased",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "epochEnd",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "indexTailDAGBlockHeight",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "tailBlockEpochSourceChainHeight",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "bytes32",
				"name": "indexIdentifierHash",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "IndexFinalized",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "snapshotterAddr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "indexTailDAGBlockHeight",
				"type": "uint256"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "bytes32",
				"name": "indexIdentifierHash",
				"type": "bytes32"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "IndexSubmitted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "previousOwner",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "OwnershipTransferred",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "epochEnd",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "dagCid",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "SnapshotDagCidFinalized",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "epochEnd",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "dagCid",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "SnapshotDagCidSubmitted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "epochEnd",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "snapshotCid",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "SnapshotFinalized",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "snapshotterAddr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "snapshotCid",
				"type": "string"
			},
			{
				"indexed": true,
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"name": "SnapshotSubmitted",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "snapshotterAddress",
				"type": "address"
			}
		],
		"name": "SnapshotterAllowed",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "snapshotterAddr",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			}
		],
		"name": "SnapshotterRegistered",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "stateBuilderAddress",
				"type": "address"
			}
		],
		"name": "StateBuilderAllowed",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "operatorAddr",
				"type": "address"
			}
		],
		"name": "addOperator",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "snapshotterAddr",
				"type": "address"
			}
		],
		"name": "allowSnapshotter",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "dagCid",
				"type": "string"
			},
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "deadline",
						"type": "uint256"
					}
				],
				"internalType": "struct AuditRecordStoreDynamicSnapshottersWithIndexing.Request",
				"name": "request",
				"type": "tuple"
			},
			{
				"internalType": "bytes",
				"name": "signature",
				"type": "bytes"
			}
		],
		"name": "commitFinalizedDAGcid",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			}
		],
		"name": "forceCompleteConsensusAggregate",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"internalType": "bytes32",
				"name": "indexIdentifierHash",
				"type": "bytes32"
			}
		],
		"name": "forceCompleteConsensusIndex",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			}
		],
		"name": "forceCompleteConsensusSnapshot",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "begin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "end",
				"type": "uint256"
			}
		],
		"name": "releaseEpoch",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "operatorAddr",
				"type": "address"
			}
		],
		"name": "removeOperator",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "renounceOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "snapshotCid",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "deadline",
						"type": "uint256"
					}
				],
				"internalType": "struct AuditRecordStoreDynamicSnapshottersWithIndexing.Request",
				"name": "request",
				"type": "tuple"
			},
			{
				"internalType": "bytes",
				"name": "signature",
				"type": "bytes"
			}
		],
		"name": "submitAggregate",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "indexTailDAGBlockHeight",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "tailBlockEpochSourceChainHeight",
				"type": "uint256"
			},
			{
				"internalType": "bytes32",
				"name": "indexIdentifierHash",
				"type": "bytes32"
			},
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "deadline",
						"type": "uint256"
					}
				],
				"internalType": "struct AuditRecordStoreDynamicSnapshottersWithIndexing.Request",
				"name": "request",
				"type": "tuple"
			},
			{
				"internalType": "bytes",
				"name": "signature",
				"type": "bytes"
			}
		],
		"name": "submitIndex",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "snapshotCid",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "deadline",
						"type": "uint256"
					}
				],
				"internalType": "struct AuditRecordStoreDynamicSnapshottersWithIndexing.Request",
				"name": "request",
				"type": "tuple"
			},
			{
				"internalType": "bytes",
				"name": "signature",
				"type": "bytes"
			}
		],
		"name": "submitSnapshot",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "newOwner",
				"type": "address"
			}
		],
		"name": "transferOwnership",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "newAggregateSubmissionWindow",
				"type": "uint256"
			}
		],
		"name": "updateAggregateSubmissionWindow",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "newIndexSubmissionWindow",
				"type": "uint256"
			}
		],
		"name": "updateIndexSubmissionWindow",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_minSubmissionsForConsensus",
				"type": "uint256"
			}
		],
		"name": "updateMinSnapshottersForConsensus",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "newsnapshotSubmissionWindow",
				"type": "uint256"
			}
		],
		"name": "updateSnapshotSubmissionWindow",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "aggregateReceived",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"name": "aggregateReceivedCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "aggregateStartTime",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "blocknumber",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "aggregateStatus",
		"outputs": [
			{
				"internalType": "bool",
				"name": "finalized",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "aggregateSubmissionWindow",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			}
		],
		"name": "checkDynamicConsensusAggregate",
		"outputs": [
			{
				"internalType": "bool",
				"name": "success",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			},
			{
				"internalType": "bytes32",
				"name": "indexIdentifierHash",
				"type": "bytes32"
			}
		],
		"name": "checkDynamicConsensusIndex",
		"outputs": [
			{
				"internalType": "bool",
				"name": "success",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			}
		],
		"name": "checkDynamicConsensusSnapshot",
		"outputs": [
			{
				"internalType": "bool",
				"name": "success",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "currentEpoch",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "begin",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "end",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "epochId",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "epochInfo",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "blocknumber",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "epochEnd",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "finalizedDagCids",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"name": "finalizedDagHeights",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "finalizedIndexes",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "tailDAGBlockHeight",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "tailDAGBlockEpochSourceChainHeight",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getAllSnapshotters",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getOperators",
		"outputs": [
			{
				"internalType": "address[]",
				"name": "",
				"type": "address[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "projectId",
				"type": "string"
			}
		],
		"name": "getProjectFirstEpochEnd",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "projectFirstEpochEnd",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getProjects",
		"outputs": [
			{
				"internalType": "string[]",
				"name": "",
				"type": "string[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getTotalSnapshotterCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "indexReceived",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			}
		],
		"name": "indexReceivedCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "indexStartTime",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "blocknumber",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "indexStatus",
		"outputs": [
			{
				"internalType": "bool",
				"name": "finalized",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "indexSubmissionWindow",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "maxAggregatesCid",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "maxAggregatesCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "maxIndexCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "bytes32",
				"name": "",
				"type": "bytes32"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "maxIndexData",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "tailDAGBlockHeight",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "tailDAGBlockEpochSourceChainHeight",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "maxSnapshotsCid",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "maxSnapshotsCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "minSubmissionsForConsensus",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"name": "projectFirstEpochId",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "messageHash",
				"type": "bytes32"
			},
			{
				"internalType": "bytes",
				"name": "signature",
				"type": "bytes"
			}
		],
		"name": "recoverAddress",
		"outputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "pure",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "snapshotsReceived",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"name": "snapshotsReceivedCount",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "snapshotStatus",
		"outputs": [
			{
				"internalType": "bool",
				"name": "finalized",
				"type": "bool"
			},
			{
				"internalType": "uint256",
				"name": "timestamp",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "snapshotSubmissionWindow",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "snapshotters",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "deadline",
						"type": "uint256"
					}
				],
				"internalType": "struct AuditRecordStoreDynamicSnapshottersWithIndexing.Request",
				"name": "request",
				"type": "tuple"
			},
			{
				"internalType": "bytes",
				"name": "signature",
				"type": "bytes"
			},
			{
				"internalType": "address",
				"name": "signer",
				"type": "address"
			}
		],
		"name": "verify",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
];

    const contract = new ethers.Contract(env.PUBLIC_STATE_CONTRACT, ABI, provider);

    let projects = []
    let currentEpoch = "";
	let currentEpochId = "";
    let allSnapshotters= [];

    onMount(async () => {
      currentEpoch = Object.assign({}, await contract.currentEpoch());
      currentEpochId = Number(currentEpoch[2]);
	  currentEpoch = Number(currentEpoch[1]);
      //console.warn('current epoch', currentEpoch);
      allSnapshotters = Object.values(Object.assign({}, await contract.getAllSnapshotters()));
      //console.warn('current allSnapshotters', allSnapshotters);
      let getProjects = Object.values(Object.assign({}, await contract.getProjects()));
      //console.warn('current getProjects', getProjects);
      for (let i=0; i<getProjects.length; i++){
        const projectSnapshotters = Object.values(Object.assign({}, await contract.getAllSnapshotters()));
        let proj = {
              id: getProjects[i],
              snapshotters: projectSnapshotters
          }
          projects = [...projects, proj];
          if (i==99){
            break;
          }
      }
      /*
      const resp = await axios.get(API_PREFIX+'/metrics/projects');
      console.log('resp', resp.data);
      //console.warn('block', await provider.getBlockNumber());
      for (let i=0; i<resp.data.length; i++){
          const snapshotters = await axios.get(API_PREFIX+'/metrics/'+resp.data[i]+'/snapshotters');
          console.log(snapshotters.data);
          //allSnapshotters = [...new Set([...allSnapshotters, ...snapshotters.data.snapshotters])];
          let proj = {
              id: resp.data[i],
              snapshotters: snapshotters.data.snapshotters
          }
          projects = [...projects, proj];
          if (i==99){
            break;
          }
      }
      //*/
    });
</script>
<div>
    <h3 class="text-lg font-medium leading-6 text-gray-900">Onchain consensus Stats</h3>
    <dl class="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-3">
      <div class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow sm:p-6">
        <dt class="truncate text-sm font-medium text-gray-500">Total Projects</dt>
        <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">{projects.length}</dd>
      </div>
  
      <div class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow sm:p-6">
        <dt class="truncate text-sm font-medium text-gray-500">Current Epoch</dt>
        <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900"><a href="{EXPLORER_PREFIX}/block/{currentEpoch}" target="_blank" rel="noreferrer noopener">{currentEpoch}</a></dd>
      </div>
  
      <div class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow sm:p-6">
        <dt class="truncate text-sm font-medium text-gray-500">Total Snapshotters</dt>
        <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">{allSnapshotters.length}</dd>
      </div>
    </dl>
</div>
<div class="overflow-hidden bg-white shadow sm:rounded-md">
    <ul role="list" class="divide-y divide-gray-200">
      {#each projects as project}
      <li>
        <a href="/projects/{project.id}" class="block hover:bg-gray-50">
          <div class="flex items-center px-4 py-4 sm:px-6">
            <div class="min-w-0 flex-1 sm:flex sm:items-center sm:justify-between">
              <div class="truncate">
                <div class="flex text-sm">
                  <p class="truncate font-medium text-indigo-600">{project.id.substr(21, 30)}</p>
                  <p class="ml-1 flex-shrink-0 font-normal text-gray-500">in {project.id.split("_").pop().split("-")[0]}</p>
                </div>
                {#if 0}
                <div class="mt-2 flex">
                  <div class="flex items-center text-sm text-gray-500">
                    <!-- Heroicon name: mini/calendar -->
                    <svg class="mr-1.5 h-5 w-5 flex-shrink-0 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                      <path fill-rule="evenodd" d="M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75z" clip-rule="evenodd" />
                    </svg>
                    <p>
                      Synced up to
                      <time datetime="2020-01-07">January 7, 2020</time>
                    </p>
                  </div>
                </div>
                {/if}
              </div>
              <div class="mt-4 flex-shrink-0 sm:mt-0 sm:ml-5">
                <div class="flex -space-x-1 overflow-hidden">
                  {#each project.snapshotters as snapshotter}
                  <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white" alt="{snapshotter}" title="{snapshotter}" src="https://avatars.dicebear.com/api/identicon/{snapshotter}.png">
                  {/each}
                <!--
                  <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white" src="https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Lindsay Walton">
  
                  <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white" src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Courtney Henry">
  
                  <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Tom Cook">
                -->
                </div>
              </div>
            </div>
            <div class="ml-5 flex-shrink-0">
              <!-- Heroicon name: mini/chevron-right -->
              <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
              </svg>
            </div>
          </div>
        </a>
      </li>
      {/each}
    </ul>
  </div>