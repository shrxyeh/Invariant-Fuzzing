//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {HandlerStatefulFuzzCatches} from "../../../src/invariant-break/HandlerStatefulFuzzCatches.sol";
import {MockUSDC} from "../../mocks/MockUSDC.sol";
import {YieldERC20} from "../../mocks/YieldERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Handler is Test {
    HandlerStatefulFuzzCatches handlerStatefulFuzzCatches;
    YieldERC20 yieldERC20;
    MockUSDC mockUSDC;
    IERC20[] supportedTokens;
    uint256 startingAmount = yieldERC20.INITIAL_SUPPLY();
    address user = makeAddr("user");

    constructor(
        HandlerStatefulFuzzCatches _handlerStatefulFuzzCatches,
        YieldERC20 _yieldERC20,
        MockUSDC _mockUSDC,
        address _user
    ) {
        handlerStatefulFuzzCatches = _handlerStatefulFuzzCatches;
        yieldERC20 = _yieldERC20;
        mockUSDC = _mockUSDC;
        user = _user;
    }

    function depositYieldERC20(uint256 _amount) public {
        uint256 amount = bound(_amount, 0, yieldERC20.balanceOf(user));
        vm.startPrank(user);
        yieldERC20.approve(address(handlerStatefulFuzzCatches), amount);
        handlerStatefulFuzzCatches.depositToken(yieldERC20, amount);
        vm.stopPrank();
    }

    function depositMockUSDC(uint256 _amount) public {
        uint256 amount = bound(_amount, 0, mockUSDC.balanceOf(user));
        vm.startPrank(user);
        mockUSDC.approve(address(handlerStatefulFuzzCatches), amount);
        handlerStatefulFuzzCatches.depositToken(mockUSDC, amount);
        vm.stopPrank();
    }

    function withdrawYieldERC20() public {
        vm.startPrank(user);
        handlerStatefulFuzzCatches.withdrawToken(yieldERC20);
        vm.stopPrank();
    }

    function withdrawMockUSDC() public {
        vm.startPrank(user);
        handlerStatefulFuzzCatches.withdrawToken(mockUSDC);
        vm.stopPrank();
    }
}

