// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract B20Token is ERC20, Ownable {
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply_,
        address initialOwner_
    )
        ERC20(name_, symbol_)
        Ownable(initialOwner_)
    {
        _mint(initialOwner_, initialSupply_ * 10 ** decimals());
    }
        function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount * 10 ** decimals());
    }

        function burn(uint256 amount) external {
        _burn(msg.sender, amount * 10 ** decimals());
    }

        function burnFrom(address account, uint256 amount) external onlyOwner {
        _burn(account, amount * 10 ** decimals());
    }

        function getOwner() external view returns (address) {
        return owner();
    }

        function getTokenInfo()
           external
           view
           returns (
              string memory,
              string memory,
              uint8,
              uint256
    )
    {
        return (
              name(),
              symbol(),
              decimals(),
              totalSupply()
        );
    }
        function exists(address account) external view returns (bool) {
        return balanceOf(account) > 0;
    }
}