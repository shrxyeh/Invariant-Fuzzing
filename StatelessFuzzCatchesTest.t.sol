// SPD-X-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";

import {StatelessFuzzCatches} from "../../src/invariant-break/StatelessFuzzCatches.sol";

contract StatelessFuzzCatchesTest is Test {
    StatelessFuzzCatches sfc;

    function setUp() public {
        sfc = new StatelessFuzzCatches();
    }

    function testFuzzCatchesBugStateless(uint128 randomNumber) public view {
        assert(sfc.doMath(randomNumber) != 0);
    }
}
