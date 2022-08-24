// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
 pragma solidity ^0.8.0;
 contract BANKERC20 is IERC20{
     
     string public constant name = "BANK COIN";
    string public constant symbol = "BANK";
    uint8 public constant decimals = 18;
     mapping(address=>uint256) private balances;
     mapping(address=>mapping(address=>uint256)) private allow;
     uint256 _totalSupply;
     constructor(uint256 _total){
         _totalSupply=_total;
         balances[msg.sender]=_total;
     }
     function totalSupply() public view override returns(uint256){
         return _totalSupply;
     }
     function balanceOf(address _tokenOwner) public view override returns(uint256){
         return balances[_tokenOwner];
     }
     function transfer(address _reciever , uint256 _amount) public override returns(bool){
         require(_amount<=balances[msg.sender]);
         balances[msg.sender]-=_amount;
         balances[_reciever]+=_amount;
         emit Transfer(msg.sender,_reciever,_amount);
         return true;
     }
     function approve(address delegate, uint _numTokens) public override returns(bool){
         allow[msg.sender][delegate]=_numTokens;
         emit Approval(msg.sender,delegate,_numTokens);
         return true;
     }
     function allowance(address owner,address _account) public override view returns(uint){
        return allow[owner][_account];
     }
     function transferFrom(address _owner, address buyer, uint numToken) public override returns(bool){
         require(numToken<=allow[_owner][buyer]);
         require(numToken<=balances[_owner]);
         balances[_owner]-=numToken;
         allow[_owner][msg.sender] -=numToken;
         balances[buyer]+=numToken;
         emit Transfer(_owner,buyer,numToken);
         return true;
     }
     function burn(address user,uint amount) internal {
         require(amount<=balances[user]);
         balances[user]-=amount;
         _totalSupply-=amount;
     }
     function increaseAllowance(address spender,uint addvalue) public returns(bool){
         allow[msg.sender][spender]+=addvalue;
         emit Approval(msg.sender,spender,allow[msg.sender][spender]);
         return true;
     }
      function decreaseAllowance(address spender,uint subvalue) public returns(bool){
          require(subvalue<=allow[msg.sender][spender]);
         allow[msg.sender][spender]-=subvalue;
         emit Approval(msg.sender,spender,allow[msg.sender][spender]);
         return true;
     }
 }
