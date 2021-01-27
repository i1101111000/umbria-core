pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract UmbriaBar is ERC20("UmbriaBar", "xUMBRIA") {
    using SafeMath for uint256;
    IERC20 public umbria;

    constructor(IERC20 _umbria) public {
        umbria = _umbria;
    }

    // Enter the bar. Pay some UMBRIAs. Earn some shares.
    function enter(uint256 _amount) public {
        uint256 totalUmbria = umbria.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalUmbria == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalUmbria);
            _mint(msg.sender, what);
        }
        umbria.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your UMBRIAs.
    function leave(uint256 _share) public {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(umbria.balanceOf(address(this))).div(
            totalShares
        );
        _burn(msg.sender, _share);
        umbria.transfer(msg.sender, what);
    }
}
