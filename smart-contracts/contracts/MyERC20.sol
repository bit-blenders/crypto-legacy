//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract MyERC20 is ERC20("My ERC20 Token", "MET"), ERC165 {
    constructor() {
        _mint(msg.sender, 100000000000000000000);
    }

    function mint(address to, uint amount) public {
        _mint(to, amount);
    }
}