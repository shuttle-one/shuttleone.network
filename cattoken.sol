

pragma solidity 0.5.17;

//revision 4
// can mint from contract and dai only

contract ERC20 {

   	   function totalSupply() public view returns (uint256);
       function balanceOf(address tokenOwner) public view returns (uint256 balance);
       function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);

       function transfer(address to, uint256 tokens) public returns (bool success);
       
       function approve(address spender, uint256 tokens) public returns (bool success);
       function transferFrom(address from, address to, uint256 tokens) public returns (bool success);

       function decimals() public view returns(uint256);
       function intTransfer(address _from, address _to, uint256 _amount) public returns(bool);

}

library SafeMath {

  function mul(uint256 a, uint256 b,uint256 decimal) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    require(c / a == b,"MUL ERROR");
    c = c / (10 ** decimal);
    return c;
  }

  function div(uint256 a, uint256 b,uint256 decimal) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    c = c * (10 ** decimal);
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a,"Sub Error");
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a,"add ERROR");
    return c;
  }
}


contract Permissions {

// A list of owners which will be saved as a list here, 
// and the values are the owner’s names. 

  mapping (address=>bool) public permits;
  
// all events will be saved as log files
  

  event AddPermit(address _addr);
  event RemovePermit(address _addr);
  /**
   * @dev Ownable constructor , initializes sender’s account and 
   * set as owner according to default value according to contract
   *
   */
   constructor() public {
    permits[msg.sender] = true;
  }

// Function to check if the person is listed in a group of Owners and determine
// if the person has the any permissions in this smart contract such as Exec permission.
  
  modifier onlyPermits(){
    require(permits[msg.sender] == true);
    _;
  }

// this function is to check of the given address is allowed to call/execute the particular function
// return true if the given address has right to execute the function.
// for transparency purpose, anyone can use this to trace/monitor the behaviors of this ShuttleOne smart contract.

  function isPermit(address _addr) public view returns(bool){
    return permits[_addr];
  }

}

contract CLevelControl is Permissions {

  address public ceoAddress;
  address public cfoAddress;
  address public cooAddress;
  address public ctoAddress;
  address payable public withdrawalAddress;
  bool public pause;
 

  constructor() public{
      ceoAddress = 0xafc5eDF046034fDb0C23d32d52564E23E49C8389;
      cooAddress = msg.sender;
      cfoAddress = msg.sender;
      ctoAddress = msg.sender;
  }


  

  modifier onlyCEO() {
    require(msg.sender == ceoAddress);
    _;
  }

  modifier onlyCFO() {
    require(msg.sender == cfoAddress);
    _;
  }

  modifier onlyCOO() {
    require(msg.sender == cooAddress);
    _;
  }
  
  modifier onlyCTO(){
      require(msg.sender == ctoAddress);
      _;
  }

  modifier onlyCLevel() {
    require(
      msg.sender == cooAddress ||
      msg.sender == ceoAddress ||
      msg.sender == cfoAddress ||
      msg.sender == ctoAddress
    );
    _;
  }
  
    modifier onlyCLevelOrPermits() {
    require(
      msg.sender == cooAddress ||
      msg.sender == ceoAddress ||
      msg.sender == cfoAddress ||
      msg.sender == ctoAddress ||
      permits[msg.sender] == true
    );
    _;
  }

  modifier onlyCEOOrCFO() {
    require(
      msg.sender == cfoAddress ||
      msg.sender == ceoAddress
    );
    _;
  }

  modifier onlyCEOOrCOO() {
    require(
      msg.sender == cooAddress ||
      msg.sender == ceoAddress
    );
    _;
  }
  
  modifier onlyCEOOrCTO() {
      require(
        msg.sender == ceoAddress ||
        msg.sender == ctoAddress
         );
    _;
  }
  
  function setS1Global(address _addr) external onlyCLevel returns(bool){
        S1Global  s1 = S1Global(_addr);
        for(uint256 i=0;i<s1.getAllMaxAddr();i++){
            addPermit(s1.getAddress(i));
        }
  }

  function addPermit(address _addr) public onlyCLevel{
    require(permits[_addr] == false);
    permits[_addr] = true;
    emit AddPermit(_addr);
  }

// Function to remove the Owner from the Owners list. The person who wanted to remove any owner from Owners
// List must be an existing member of the Owners List. The owner cannot evict himself from the Owners
// List by his own, this is to ensure that there is at least one Owner of this ShuttleOne Smart Contract.
// This ShuttleOne Smart Contract will become useless if there is no owner at all.

  function removePermit(address _addr) public onlyCLevel{
    permits[_addr] = false;
    emit RemovePermit(_addr);
  }

  

  function setCEO(address _newCEO) external onlyCEO {
    require(_newCEO != address(0));
    ceoAddress = _newCEO;
  }

  function setCFO(address _newCFO) external onlyCEO {
    require(_newCFO != address(0));
    cfoAddress = _newCFO;
  }

  function setCOO(address _newCOO) external onlyCEO {
    require(_newCOO != address(0));
    cooAddress = _newCOO;
  }
  
  function setCTO(address _newCTO) external onlyCEO {
      require(_newCTO != address(0));
      ctoAddress = _newCTO;
  }
  
    /**
   * @notice Sets a new withdrawalAddress
   * @param _newWithdrawalAddress - the address where we'll send the funds
  */
  function setWithdrawalAddress(address payable _newWithdrawalAddress) external onlyCEO {
    require(_newWithdrawalAddress != address(0));
    withdrawalAddress = _newWithdrawalAddress;
  }

  /**
   * @notice Withdraw the balance to the withdrawalAddress
   * @dev We set a withdrawal address seperate from the CFO because this allows us to withdraw to a cold wallet.
   */
  function withdrawBalance() external onlyCEOOrCFO {
    require(withdrawalAddress != address(0));
    withdrawalAddress.transfer(address(this).balance);
  }
  
  function withdrawToken(uint256 amount,address conAddr)external onlyCEOOrCFO {
        require(pause == false);
        require(withdrawalAddress != address(0));
        ERC20  erc20Token = ERC20(conAddr);
        erc20Token.transfer(withdrawalAddress,amount);
  }

//Emegency Pause Contract;
  function stopContract() external onlyCEOOrCTO{
      pause = true;
  }



}

contract S1Global{
    function getAllMaxAddr() public returns(uint256);
    function getAddress(uint256 idx) public returns(address);
}

contract RatToken{
     
     function isValidToken(uint256 _tokeID) public view  returns (bool);
     function ownerOf(uint256 tokenId) public view returns (address);
     function getRatDetail(uint256 _tokenID) public view returns(uint256 _tokenType,uint256 _docID,address _contract);
  
     
}

contract CheckMint{
  // 3 improtant function for mint from RAT 
     function canMintCat(uint256 _tokenID) public view returns (bool);
     function setAlreadyMint(uint256 _tokeID) public;
     function getMintAmount(uint256 _tokeID) public view returns(uint256);

}


contract CAT_V4 is CLevelControl {
    
    using SafeMath for uint256;

    RatToken public ratToken;
    
    string public name     = "Credit Application";
    string public symbol   = "CAT";
    uint8  public decimals = 18;
    string public company  = "ShuttleOne Pte Ltd";
    uint8  public version  = 4;
    
    //mapping (address=>bool) public allowMintContract;
    mapping (address=>bool) public allowDeposit;
    mapping (address=>uint256) public depositExRate; // address 0 mean ETH
    mapping (address=>bool) public notAllowControl;


    event  Approval(address indexed _tokenOwner, address indexed _spender, uint256 _amount);
    event  Transfer(address indexed _from, address indexed _to, uint256 _amount);
   
    event  MintFromToken(address indexed _to,uint256 amount);
    event  MintFromContract(address indexed _from,address indexed _to,uint256 _amount,uint256 _contractID);
   
    event  DepositToken(address indexed _tokenAddr,uint256 _exrate,string _symbol);
    event  RemoveToken(address indexed _tokenAddr);
    event  NewExchangeRate(string indexed _type,uint256 exRate);
    
    mapping (address => uint256) public  balance;
   // mapping (address => mapping (address => uint256)) balanceDeposit;
    mapping (address => mapping (address => uint256)) public  allowed;

    mapping (address => bool) blacklist;
    uint256  _totalSupply;

    address coldWallet;

    // Exrate 1 = 1000000000000000000  18 digit only
    function addDepositToken(address _conAddr,string memory _symbol,uint256 exRate) public onlyCLevel {
        
        allowDeposit[_conAddr] = true;
        depositExRate[_conAddr] = exRate;
        emit DepositToken(_conAddr,exRate,_symbol);
    }

    function removeDepositToken(address _conAddr) public onlyCLevel {
        allowDeposit[_conAddr] = false;
        emit RemoveToken(_conAddr);
    }
    
    function setColdWallet(address _coldWallet) public onlyCLevel{
        coldWallet = _coldWallet;
    }
    
    function setDepositRate(address _addr,uint256 _newRate) public onlyCEOOrCFO{
        depositExRate[_addr] = _newRate;
        emit NewExchangeRate("Deposit",_newRate);
    }

     constructor() public {
         // Test
        //  daiToken = ERC20(0x6a064dc45fB597de938b94E6A97F5c256c7f2716); //Dai Test Token
        //  coldWallet = 0x4867e2447918743721750E333813888914c0641D;       
         // Real 
//         daiToken = ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F); //Dai Stablecoin (DAI)
//        ratToken = 
        allowDeposit[0x6B175474E89094C44Da98b954EedeAC495271d0F] = true;
        depositExRate[0x6B175474E89094C44Da98b954EedeAC495271d0F] = 1000000000000000000; // 18 digit
        emit DepositToken(0x6B175474E89094C44Da98b954EedeAC495271d0F,1000000000000000000,"DAI");
       //  coldWallet = 0x1d8045aFBBB66f2f5800578812dE200CC44f7Ed0;
         
     }

     function setRatToken(address _addr) public onlyCLevel{
        ratToken = RatToken(_addr);
     }
     
     function mintToken(address _token,uint256 _amount) public {
         require(allowDeposit[_token] == true,"DEPOSIT ERROR This token not allow");
         require(_amount > 0,"Amount should > 0");
         ERC20 token = ERC20(_token);

         uint256 dec = token.decimals();
         if(dec < 18) _amount *= 10 ** (18-dec);

         uint256 catAmount = _amount.mul(depositExRate[_token],18);
         
         // if(coldWallet != address(0))
         //     token.transferFrom(msg.sender,coldWallet,_amount);
         // else
         if(token.transferFrom(msg.sender,address(this),_amount) == true){
           _totalSupply += catAmount;
           balance[msg.sender] = balance[msg.sender].add(catAmount);
           emit Transfer(address(this),msg.sender,catAmount);
           emit MintFromToken(msg.sender,_amount);
       }
       //  balanceDeposit[msg.sender][_token] =  balanceDeposit[msg.sender][_token].add(catAmount);
         
         
     }

     function mintFromWarpToken(address _token,uint256 _amount,address to) public onlyPermits returns(bool) {
         require(allowDeposit[_token] == true,"DEPOSIT ERROR This token not allow");
         require(_amount > 0,"Amount should > 0");
         ERC20 token = ERC20(_token);

         uint256 dec = token.decimals();
         if(dec < 18) _amount *= 10 ** (18-dec);

         uint256 catAmount = _amount.mul(depositExRate[_token],18);
         
         // if(coldWallet != address(0))
         //     token.transferFrom(msg.sender,coldWallet,_amount);
         // else
         if(token.intTransfer(to,address(this),_amount) == true){
           _totalSupply += catAmount;
           balance[to] = balance[to].add(catAmount);
           emit Transfer(address(this),to,catAmount);
           emit MintFromToken(to,_amount);
           return true;
       }
       //  balanceDeposit[msg.sender][_token] =  balanceDeposit[msg.sender][_token].add(catAmount);
         return false;
         
     }


     //     function canMintCat(uint256 _tokenID) public view returns (bool);
     // function setAlreadyMint(uint256 _tokenID) public;
     // function getMintAmount(uint256 _tokenID) public view returns(uint256);


     function mintFromRATToken(uint256 _tokenID) public returns(string memory result){
          require(ratToken.isValidToken(_tokenID) == true,"Token Invalid");
          address _to = ratToken.ownerOf(_tokenID);
          address _contract;
          uint256 amount;
          (,,_contract) = ratToken.getRatDetail(_tokenID);
          CheckMint  checkToken = CheckMint(_contract);

          if(checkToken.canMintCat(_tokenID) == false)
          {
            return "ERROR This Token Can't mint";
          }

          amount = checkToken.getMintAmount(_tokenID);
          checkToken.setAlreadyMint(_tokenID);
          balance[_to] = balance[_to].add(amount);
          _totalSupply += amount;
          emit Transfer(address(this),_to,amount);

     }

     // function mintFromContract(address _to,uint256 _amount,uint256 _contractID) public onlyPermits {//onlyCLevelOrPermits {
     //  //  require(allowMintContract[msg.sender] == true,"This Contract not allow to mint");
     //    balance[_to] += _amount;
     //    _totalSupply += _amount;
        
     //    emit MintFromContract(msg.sender,_to,_amount,_contractID);
     //    emit Transfer(address(0), _to, _amount);
     // }
    

     // function mintInterestFromPools(address _to,uint256 _amount) public returns(bool){
     //    require(depositPools[msg.sender] == true,"this address not allow");

     //    balance[_to] += amount;
     //    _totalSupply += amount;

     //    emit MintFromContract(msg.sender,_to,_amount,msg.sender);
     //    emit Transfer(address(0), _to, _amount);
     // }
     
    function balanceOf(address _addr) public view returns (uint256){
        return balance[_addr]; 
     }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

     function approve(address _spender, uint256 _amount) public returns (bool){
            require(blacklist[msg.sender] == false,"Approve:have blacklist");
            allowed[msg.sender][_spender] = _amount;
            emit Approval(msg.sender, _spender, _amount);
            return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256){
          return allowed[_owner][_spender];
    }

    function transfer(address _to, uint256 _amount) public returns (bool) {
        require(balance[msg.sender] >= _amount,"CAT/ERROR-out-of-balance-transfer");
        require(_to != address(0),"CAT/ERROR-transfer-addr-0");
        require(blacklist[msg.sender] == false,"Transfer blacklist");

        balance[msg.sender] -= _amount;
        balance[_to] += _amount;
        emit Transfer(msg.sender,_to,_amount);
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool)
    {
        require(balance[_from] >= _amount,"WDAI/ERROR-transFrom-out-of");
        require(allowed[_from][msg.sender] >= _amount,"WDAI/ERROR-spender-outouf"); 
        require(blacklist[_from] == false,"transferFrom blacklist");

        balance[_from] -= _amount;
        balance[_to] += _amount;
        allowed[_from][msg.sender] -= _amount;
        emit Transfer(_from, _to, _amount);

        return true;
    }

    function setNotAllow(bool _set) public returns(bool){
       notAllowControl[msg.sender] = _set;
    }
    
    function intTransfer(address _from, address _to, uint256 _amount) external onlyCLevelOrPermits returns(bool){
           require(notAllowControl[_from] == false,"This Address not Allow");
           require(balance[_from] >= _amount,"WDAI/ERROR-intran-outof");
           
           
           balance[_from] -= _amount; 
           balance[_to] += _amount;
    
           emit Transfer(_from,_to,_amount);
           return true;
    }

    function burnToken(address _from,uint256 _amount) external onlyCLevelOrPermits {
        require(balance[_from] >= _amount,"burn out of fund");
        balance[_from] -= _amount;
        _totalSupply -= _amount;
        
        emit Transfer(_from, address(0), _amount);
    }
    
    
}


