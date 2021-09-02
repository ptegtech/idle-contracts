// contracts/StoneToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./base/SecurityBase.sol";

contract StoneToken is ERC20Burnable, SecurityBase {

    constructor(uint256 initialSupply) ERC20("MagicStone", "MST") {
        _mint(msg.sender, initialSupply);
    }

    function safeMint(address account, uint256 amount) public whenNotPaused onlyMinter {
        _mint(account, amount);
    }
}
