// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
contract FundMeTestIntegration is Test {
    FundMe public fundMe;
    uint256 constant FUNDAMOUNT = 0.01 ether;
    uint256 constant BALANCE= 10 ether;
    address USER = makeAddr("user");
    uint256 constant GAS_PRICE=1;
        function setUp() public {
        fundMe = new DeployFundMe().run();
        vm.deal(USER, BALANCE);
    }
    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        address funder = fundMe.getFunder(0);
        assertEq(funder, msg.sender, "Funder should be the user who sent the funds");
        uint256 fundedAmount = fundMe.getAddressToAmountFunded(msg.sender);
        assertEq(fundedAmount, FUNDAMOUNT, "Funded amount should match the sent value");
    }
    function testUserCanWithdraw() public {
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0, "FundMe contract balance should be zero after withdrawal");

    }


}