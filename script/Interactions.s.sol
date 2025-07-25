// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;
import {Script,console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 constant FUND_AMOUNT = 0.01 ether;  

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        fundFundMe(mostRecentDeployment);
    }
    function fundFundMe (address mostRecentDeployment) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployment)).fund{value: FUND_AMOUNT}();
        vm.stopBroadcast();
        console.log("Funded FundMe contract at address:", mostRecentDeployment);
        console.log("Funded amount:", FUND_AMOUNT);
    }
    
}
contract WithdrawFundMe is Script {
    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        withdrawFundMe(mostRecentDeployment);
    }
        function withdrawFundMe (address mostRecentDeployment) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployment)).withdraw();
        vm.stopBroadcast();
        console.log("Withdrew from FundMe contract at address:", mostRecentDeployment);
    }
    

}