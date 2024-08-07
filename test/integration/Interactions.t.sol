// unit test
// integrations test
// forked tests
// staging tests <- run tests on a mainnet or testnet

// fuzzing
// stateful fuzz
// stateless fuzz
// formal verification

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployRaffle} from "script/DeployRaffle.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {Raffle} from "../../src/Raffle.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "script/Interactions.s.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract Interactions is Test {
    Raffle public raffle;
    HelperConfig public helperConfig;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinator;
    bytes32 gasLane /* s_keyHash */;
    uint256 subscriptionId;
    uint32 callbackGasLimit;
    address mostRecentlyDeployed;

    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.deployContract();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        entranceFee = config.entranceFee;
        interval = config.interval;
        vrfCoordinator = config.vrfCoordinator;
        gasLane /* s_keyHash */ = config.gasLane;
        subscriptionId = config.subscriptionId;
        callbackGasLimit = config.callbackGasLimit;
        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);

        console.log("Block Chain ID: ", block.chainid);

       /*  mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Raffle",
            block.chainid
        ); */
        
    }

    function testcreateSubscriptionUsingConfig() public {
        uint256 subId = 0;
        CreateSubscription createSubscription = new CreateSubscription();
        (subId,) = createSubscription.createSubscriptionUsingConfig();
        // Assert
        console.log("SubID is: ", subId);
        assert(subId != 0);

    }
}
