// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    uint256 constant FUNDAMOUNT = 0.01 ether;
    uint256 constant BALANCE= 10 ether;
    address USER = makeAddr("user");
    uint256 constant GAS_PRICE=1;

    function setUp() public {
        fundMe = new DeployFundMe().run();
        vm.deal(USER, BALANCE);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender, "Owner should be the message sender");
    }

    function testPriceFeedVersion() public view {
        uint256 version = uint256(fundMe.getVersion());
        console.log("Price Feed Version:", version);
        assertGt(version, 0, "Price feed version should be greater than 0");
    }
    function testFundFails() public{
        vm.expectRevert("You need to spend more ETH!");
        fundMe.fund{value: 0.001 ether}();
    }
    function testFundUpdates() public  funded{
        uint256 fundedAmount = fundMe.getAddressToAmountFunded(USER);
        assertEq(fundedAmount, FUNDAMOUNT, "Funded amount should match the sent value");
    }
    function testAddFunder() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER, "Funder should be the user who sent the funds");
    }
    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: FUNDAMOUNT}();
        _;
    }
    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }
    function testWithdrawWithOnlySingleFunder() public funded {
        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        uint256 initialFundMeBalance = address(fundMe).balance;
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 gastEnd= gasleft();
        uint256 gasUsed = gasStart - gastEnd;
        uint256 EndingOwnerBalance = fundMe.getOwner().balance;
        uint256 EndingFundMeBalance = address(fundMe).balance;
        console.log("Gas used for withdrawal:", gasUsed);

        assertEq(EndingFundMeBalance, 0, "FundMe contract balance should be zero after withdrawal");
        assertEq(EndingOwnerBalance, initialOwnerBalance + initialFundMeBalance, "Owner balance should equal initial owner balance plus FundMe balance");
    }
    function testWithdrawWithMultipleFunders() public funded {
        uint256 NumberOfFunders = 10;
        uint160 StartingFunderIndex=1;
        for (uint160 i = StartingFunderIndex; i < NumberOfFunders; i++) {

            hoax(address(i), FUNDAMOUNT);
            fundMe.fund{value: FUNDAMOUNT}();
        } 
        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        uint256 initialFundMeBalance = address(fundMe).balance;
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 EndingOwnerBalance = fundMe.getOwner().balance;
        uint256 EndingFundMeBalance = address(fundMe).balance;
        assertEq(EndingFundMeBalance, 0, "FundMe contract balance should be zero after withdrawal");
        assertEq(EndingOwnerBalance, initialOwnerBalance + initialFundMeBalance, "Owner balance should equal initial owner balance plus FundMe balance");
        
    }
    function testWithdrawWithMultipleFundersCheaper() public funded {
        uint256 NumberOfFunders = 10;
        uint160 StartingFunderIndex=1;
        for (uint160 i = StartingFunderIndex; i < NumberOfFunders; i++) {

            hoax(address(i), FUNDAMOUNT);
            fundMe.fund{value: FUNDAMOUNT}();
        } 
        uint256 initialOwnerBalance = fundMe.getOwner().balance;
        uint256 initialFundMeBalance = address(fundMe).balance;
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        uint256 EndingOwnerBalance = fundMe.getOwner().balance;
        uint256 EndingFundMeBalance = address(fundMe).balance;
        assertEq(EndingFundMeBalance, 0, "FundMe contract balance should be zero after withdrawal");
        assertEq(EndingOwnerBalance, initialOwnerBalance + initialFundMeBalance, "Owner balance should equal initial owner balance plus FundMe balance");
        
    }
}
