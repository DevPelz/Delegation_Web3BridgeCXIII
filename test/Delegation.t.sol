// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/Delegation.sol";
import "src/DelegationFactory.sol";

contract TestDelegation is BaseTest {
    Delegation private level;

    constructor() {
        // SETUP LEVEL FACTORY
        levelFactory = new DelegationFactory();
    }

    function setUp() public override {
        // Call the BaseTest setUp() function that will also create testsing accounts
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        /**
         * CODE YOUR SETUP HERE
         */
        levelAddress = payable(this.createLevelInstance(true));
        level = Delegation(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.owner(), address(levelFactory));
    }

    function exploitLevel() internal override {
        /**
         * CODE YOUR EXPLOIT HERE
         */
        vm.startPrank(player, player);

        vm.stopPrank();
        /**
         * STOP YOUR EXPLOIT
         */
    }
}
