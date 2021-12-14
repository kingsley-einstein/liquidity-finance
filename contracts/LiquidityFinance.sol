pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Context.sol';

contract LiquidityFinance is Context, Ownable, ERC20 {
  constructor(uint256 _amount) Ownable() ERC20('Liquidity Finance', 'LFI') {
    _mint(_msgSender(), _amount);
  }

  function decimals() public view virtual override returns (uint8) {
    return 9;
  }

  /** @dev Function to retrieve ERC20 assets stuck in contract
   *  @param _token Contract address of the ERC20 token
   *  @param _to Address to send token to
   *  @param _amount Amount of this token to send
   */
  function retrieveERC20(
    address _token,
    address _to,
    uint256 _amount
  ) external onlyOwner {
    require(
      _token != address(0),
      'Error: Token address cannot be zero address'
    );
    require(
      _to != address(0),
      'Error: Recipient address cannot be zero address'
    );
    require(_amount > 0, 'Error: amount must be greater than 0');
    require(
      IERC20(_token).transfer(_to, _amount),
      'Error: Unable to transfer tokens'
    );
  }

  /** @dev Function to retrieve Ether stuck in contract
   *  @param _to Address to send Ether to
   *  @param _amount Amount of Ether to send
   */
  function retrieveEther(address _to, uint256 _amount) external onlyOwner {
    require(address(this).balance >= _amount, 'Error: Not enough Ether');
    address payable _payable = payable(_to);
    _payable.transfer(_amount);
  }
}
