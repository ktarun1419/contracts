// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
contract Lottery{
    address public owner;
    uint256 public platformFee;
    uint256 public registrationFee;
    address[] public lotteryFactoyAddress;

    constructor(uint256 _platformfeePercent,uint256 _registrationfee){
        owner=msg.sender;
        platformFee=_platformfeePercent;
        registrationFee=_registrationfee;
    }
    struct accountCheck{
        bool registered;
        bool blacklisted;
    }
    modifier onlyOwner() {  
              require(msg.sender == owner,"you are not owner");  
                    _;    }
    mapping(address=>address[]) public contractAddressLedger;
    mapping(address=>accountCheck) public checkRegistration;
    function register() public payable  returns(bool){
        require (checkRegistration[msg.sender].blacklisted==false,"cann t register because you are blacklisted");
        require(msg.value>=registrationFee,"amount is less than required");
        checkRegistration[msg.sender]=accountCheck(true,false);
        return true;
    }
    function blacklist(address _blacklist)  public onlyOwner returns(bool){
        checkRegistration[_blacklist]=accountCheck(false,true);
        return true;
    }
    function withdrawFunds() onlyOwner public{
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success,"platformfee is not transferred");
    }
    function createLottery(uint256 _ownerFee,uint256 _maxUserCount,uint256 _feePerUser,uint256 _firstPrizePercent,uint256 _secondPrizePercent,uint256 _thirdPrizePercent,uint256 _endTime) public{
        require(checkRegistration[msg.sender].registered,"not registered");
        require(_ownerFee<=10,"ownerfee cannot be greater than 10 percent");
        require(checkRegistration[msg.sender].blacklisted==false,"user is blacklisted");
        lotteryFactory newcontract=new lotteryFactory(msg.sender,platformFee, _ownerFee, owner, _maxUserCount,_feePerUser, _firstPrizePercent, _secondPrizePercent, _thirdPrizePercent,_endTime);
        lotteryFactoyAddress.push(address(newcontract));
        contractAddressLedger[msg.sender].push(address(newcontract));

    }
    function changePlateformFee(uint256 _paltformfee) public onlyOwner returns(bool){
        platformFee=_paltformfee;
        return true;
    }
    function changeRegistrationFee(uint256 _registrationFee) public onlyOwner returns(bool){
        registrationFee=_registrationFee;
        return true;
    }
    function investLottery(address _lotteryfactory) public payable  {
        lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
        newcontract.investLottery{value:msg.value}(msg.sender);
    }
    function cancelLottery(address _lotteryfactory) public{
        lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
        newcontract.cancellottery(msg.sender);
    }
    function endLottery(address _lotteryfactory) public{
        lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
        newcontract.endLottery();
    }
    function endTimeofLottery(address _lotteryfactory) public view returns(uint256){
         lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
         return newcontract.endTime();
    }
    function ownerFeePercent(address _lotteryfactory) public view returns(uint256){
         lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
         return newcontract.ownerFee();
    }
    function maxUserCount(address _lotteryfactory) public view returns(uint256){
         lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
         return newcontract.maxUserCount();
    }
    function feePerUserOfLottery(address _lotteryfactory) public view returns(uint256){
         lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
         return newcontract.feePerUser();
    }
    function lotteryOwner(address _lotteryfactory) public view returns(address){
         lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
         return newcontract.lotteryOwner();
    }
    function totalParticipants(address _lotteryfactory) public view returns(uint256){
        lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
        return newcontract.totalparticipants();
    }
    function firstWinner(address _lotteryfactory)public view returns(address){
        lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
        return newcontract.firstWinner();
    }
    function secondWinner(address _lotteryfactory)public view returns(address){
        lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
        return newcontract.secondWinner();
    }
    function thirdWinner(address _lotteryfactory)public view returns(address){
        lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
        return newcontract.thirdWinner();
    }
    function Investors(address _lotteryfactory)public view returns(address[] memory){
        lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
        return newcontract.investors();
    }
    function totalAmountInvestedInLottery(address _lotteryfactory) public view returns(uint256){
       lotteryFactory newcontract=lotteryFactory(_lotteryfactory);
       return newcontract.totalAmountInvested();
    }
}
contract lotteryFactory{
    // all the variables are stored here
    uint256 public platformfee;
    uint256 public ownerFee;
    uint256 public maxUserCount;
    uint256 public feePerUser;
    uint256 public firstPrizePercent;
    uint256 public secondPrizePercent;
    uint256 public thirdPrizePercent;
    uint256 public endTime;
    address public platformAddress;
    address public lotteryOwner;
    address public firstWinner;
    address public secondWinner;
    address public thirdWinner;
    constructor(address _lotteryOwner,uint256 _platformFee,uint256 _ownerFee,address _platformAddress,uint256 _maxUserCount,uint256 _feePerUser,uint256 _firstPrizePercent,uint256 _secondPrizePercent,uint256 _thirdPrizePercent,uint256 _endTime){
        maxUserCount=_maxUserCount;
        feePerUser=_feePerUser;
        lotteryOwner=_lotteryOwner;
        platformfee=_platformFee;
        ownerFee=_ownerFee;
        firstPrizePercent=_firstPrizePercent;
        secondPrizePercent=_secondPrizePercent;
        thirdPrizePercent=_thirdPrizePercent;
        endTime=_endTime;
        platformAddress=_platformAddress;
        require(platformfee+ownerFee+firstPrizePercent+secondPrizePercent+thirdPrizePercent==100,"prize distribution is invalid");
    }
    uint256 public totalparticipants;
    //ledgers
    mapping(address=>bool) public hasInvested;
    mapping(address=>address[]) public lotteryInvestors;
    function investors() public view returns(address[] memory){
        return lotteryInvestors[lotteryOwner];
    }
    function totalAmountInvested() public view returns(uint256){
        uint256 totalpercent=firstPrizePercent+secondPrizePercent+thirdPrizePercent;
        return (totalparticipants*feePerUser*totalpercent)/100;
    }
    function investLottery(address _participantaddress) public  payable {
        require(totalparticipants<=maxUserCount,"already max users");
        require(!(hasInvested[_participantaddress]),"already invested");
        require(block.timestamp<endTime,"investing is already over");
        require(msg.value>=feePerUser,"amount is less than");
        (bool success, ) = payable(platformAddress).call{value:(msg.value*platformfee)/100}("");
        require(success,"platformfee is not transferred");
        (bool success1, ) = payable(lotteryOwner).call{value:(msg.value*ownerFee)/100}("");
        require(success1,"ownerfee is not transferred");
        lotteryInvestors[lotteryOwner].push(_participantaddress);
        hasInvested[_participantaddress]=true;
        totalparticipants+=1;
    }
    function random(uint num)  view internal  returns(uint){
 return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, 
 msg.sender))) % num;
 }
    function cancellottery(address _participantAddress) public {
        require(block.timestamp<endTime,"investing is already over");
        require(hasInvested[_participantAddress],"not participated in the lottery");
        (bool success, ) = payable(_participantAddress).call{value:((feePerUser)*(firstPrizePercent+secondPrizePercent+thirdPrizePercent))/100}("");
        require(success,"platformfee is not transferred");
       for(uint i=0;i<lotteryInvestors[lotteryOwner].length;i++){
           if (lotteryInvestors[lotteryOwner][i]==_participantAddress) {
              delete lotteryInvestors[lotteryOwner][i];
           }
       }
       hasInvested[_participantAddress]=false;
       totalparticipants-=1;
    }
    function endLottery() public {
        require(block.timestamp>=endTime,"time period is not over");
        uint first=random(totalparticipants);
        uint256 totalinvestedAmount=feePerUser*totalparticipants;
        (bool success, ) = payable(lotteryInvestors[lotteryOwner][first]).call{value:((totalinvestedAmount)*(firstPrizePercent))/100}("");
        require(success,"firstprizetransferred is not transferred");
        firstWinner=lotteryInvestors[lotteryOwner][first];
        delete lotteryInvestors[lotteryOwner][first];
        totalparticipants-=1;
        uint second=random(totalparticipants);
         (bool success1, ) = payable(lotteryInvestors[lotteryOwner][second]).call{value: ((totalinvestedAmount)*(secondPrizePercent))/100}("");
        require(success1,"secondprizetransferred is not transferred");
        secondWinner=lotteryInvestors[lotteryOwner][second];
        delete lotteryInvestors[lotteryOwner][second];
        totalparticipants-=1;
         uint third=random(totalparticipants);
           (bool success2, ) = payable(lotteryInvestors[lotteryOwner][third]).call{value: ((totalinvestedAmount)*(thirdPrizePercent))/100}("");
        require(success2,"thirdprizetransferred is not transferred");
        thirdWinner=lotteryInvestors[lotteryOwner][third];
        delete lotteryInvestors[lotteryOwner][third];
        totalparticipants+=2;
    }

}