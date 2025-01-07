//SPDX-License-Identifier:MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {HandlerStatefulFuzzCatches} from "../../../src/invariant-break/HandlerStatefulFuzzCatches.sol";
import {MockUSDC} from "../../mocks/MockUSDC.sol";
import {YieldERC20} from "../../mocks/YieldERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Handler} from "./Handler.t.sol";

contract AttemptedBreakTest is Test {
    HandlerStatefulFuzzCatches handlerStatefulFuzzCatches;
    YieldERC20 yieldERC20;
    MockUSDC mockUSDC;
    Handler handler;
    IERC20[] supportedTokens;
    uint256 startingAmount;

    address user = makeAddr("user");

    function setUp() public {
        vm.startPrank(user);
        yieldERC20 = new YieldERC20();
        mockUSDC = new MockUSDC();
        startingAmount = yieldERC20.INITIAL_SUPPLY();
        mockUSDC.transfer(user, startingAmount);
        yieldERC20.transfer(user, startingAmount);
        vm.stopPrank();

        supportedTokens.push(mockUSDC);
        supportedTokens.push(yieldERC20);
        handlerStatefulFuzzCatches = new HandlerStatefulFuzzCatches(
            supportedTokens
        );
        handler = new Handler(
            handlerStatefulFuzzCatches,
            yieldERC20,
            mockUSDC,
            user
        );

        bytes4[] memory selectors = new bytes4[](4);
        selectors[0] = handler.depositYieldERC20.selector;
        selectors[1] = handler.depositMockUSDC.selector;
        selectors[2] = handler.withdrawYieldERC20.selector;
        selectors[3] = handler.withdrawMockUSDC.selector;

        targetSelector(
            FuzzSelector({addr: address(handler), selectors: selectors})
        );
        targetContract(address(handler));
    }

    function statefulFuzz_testInvariantBreaksHandler() public {
        vm.startPrank(user);
        handlerStatefulFuzzCatches.withdrawToken(yieldERC20);
        handlerStatefulFuzzCatches.withdrawToken(mockUSDC);
        vm.stopPrank();

        assert(mockUSDC.balanceOf(address(handlerStatefulFuzzCatches)) == 0);
        assert(yieldERC20.balanceOf(address(handlerStatefulFuzzCatches)) == 0);

        assert(mockUSDC.balanceOf(user) == startingAmount);
        assert(yieldERC20.balanceOf(user) == startingAmount);
    }
}
