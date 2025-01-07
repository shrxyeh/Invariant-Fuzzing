// SPD-X-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {StatefulFuzzCatches} from "../../src/invariant-break/StatefulFuzzCatches.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract StatefulFuzzCatchesTest is StdInvariant, Test {
    StatefulFuzzCatches statefullFuzzCatches;

    function setUp() public {
        statefullFuzzCatches = new StatefulFuzzCatches();
        targetContract(address(statefullFuzzCatches));
    }

    function testDoMoreMathAgain(uint128 randomNumber) public {
        assert(statefullFuzzCatches.doMoreMathAgain(randomNumber) != 0);
    }

    function statefulFuzz_CatchesInvariant() public view {
        assert(statefullFuzzCatches.storedValue() != 0);
    }
}
