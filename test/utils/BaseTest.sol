// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";

import "src/EtherSetup.sol";
import "./Utilities.sol";

abstract contract BaseTest is Test {
    Utilities internal utilities;
    EtherSetup private ethersetup;
    Level internal levelFactory;
    address payable internal levelAddress;

    address payable[] internal users;
    uint256 private userCount;
    uint256 private userInitialFunds = 100 ether;
    string[] private userLabels;

    address payable internal owner;
    address payable internal player;

    constructor() {
        userCount = 2;
        userInitialFunds = 5 ether;

        userLabels = new string[](2);
        userLabels.push("Owner");
        userLabels.push("Player");
    }

    function setUp() public virtual {
        require(address(levelFactory) != address(0), "level not setup");

        utilities = new Utilities();
        ethersetup = new EtherSetup();
        ethersetup.registerLevel(levelFactory);

        if (userCount > 0) {
            // check which one we need to call
            users = utilities.createUsers(userCount, userInitialFunds, userLabels);
            owner = users[0];
            player = users[1];
        }
    }

    function createLevelInstance(bool fromPlayer) external payable returns (address) {
        if (fromPlayer) {
            vm.prank(player);
        }
        return ethersetup.createLevelInstance{value: msg.value}(levelFactory);
    }

    function runLevel() public {
        // run the exploit
        setupLevel();

        // run the exploit
        exploitLevel();

        // verify the exploit
        checkSuccess();
    }

    function setupLevel() internal virtual {
        /* IMPLEMENT YOUR EXPLOIT */
    }

    function exploitLevel() internal virtual {
        /* IMPLEMENT YOUR EXPLOIT */
    }

    function checkSuccess() internal {
        /* CHECK SUCCESS */
        vm.startPrank(player);
        bool success = ethersetup.submitLevelInstance(payable(levelAddress));
        assertTrue(success, "Solution is not solving the level");

        vm.stopPrank();
    }
}
