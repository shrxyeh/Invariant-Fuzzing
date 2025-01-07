//SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {HandlerStatefulFuzzCatches} from "../../../src/invariant-break/HandlerStatefulFuzzCatches.sol";
import {MockUSDC} from "../../mocks/MockUSDC.sol";
import {YieldERC20} from "../../mocks/YieldERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AttemptedBreakTest is Test {
    HandlerStatefulFuzzCatches handlerStatefulFuzzCatches;
    YieldERC20 yieldERC20;
    MockUSDC mockUSDC;
    IERC20[] supportedTokens;
    uint256 startingAmount;

    address user = makeAddr("user");

    function setUp() public {
        vm.startPrank(user);
        yieldERC20 = new YieldERC20();
        mockUSDC = new MockUSDC();
        startingAmount = yieldERC20.INITIAL_SUPPLY();
        mockUSDC.mint(user, startingAmount);
        vm.stopPrank();

        supportedTokens.push(mockUSDC);
        supportedTokens.push(yieldERC20);
        handlerStatefulFuzzCatches = new HandlerStatefulFuzzCatches(supportedTokens);
        targetContract(address(handlerStatefulFuzzCatches));
    }
}
