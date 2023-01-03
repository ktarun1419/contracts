// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract bidding{
    /*
    bidding contract will be deployed for every nft which is put to bidding
    steps to bid put nft for bidding
    step1-firstly mint the nft from the nftRoyalty contract
    step2- firstly approve the marketplace contract from the  nft contract
    step3- once approved list the nft on the marketplace by clicking the listitem. it will list the nft to the marketplace so you can sell directly or place nft for bidding
    step4-to place the nft for bidding click on the bid function it will create the bidding contract and the nft will be transferred to that bidding contract and now all the dealings will be done by that conntract
    step5-get the bidding contract from the biddinginfo and copy that
    step6-to place the bidd put the biddingcontract address as the parameter and other parameter as asked then call the place bidd function with the required amount and then your bidd will be placed
    step7- now the bidding will open till the time is over once the tme is over click on the endbidding then the address which will win will receive the nft and the rest of the accounts will receive there respective amount without any deduction and the biddingcontract owner will receive the amount after deducting the platform fee and the royalty by the creator
    */
    address public platform;
    uint platformfeePercent=2;
    uint public tokenId;
    address public nftaddress;
    uint256 public minprice;
    uint256 public endTime;
    address creator;
    uint256 public currentmaxvalue;
    address public currentmaxvalueAddress;
    bool public bidstatus;
    mapping(address=>uint256) public PriceLedger;
    address[] public bidders;
    constructor(address _creator,address _nftAddress,uint _tokenId,uint256 _minPrice,uint256 _endTime){
       tokenId=_tokenId;
       nftaddress=_nftAddress;
       minprice=_minPrice;
       creator=_creator;
       endTime=_endTime;
       currentmaxvalue=_minPrice;
       currentmaxvalueAddress=_creator;
       platform=0x583031D1113aD414F02576BD6afaBfb302140225;
       bidstatus=true;
    }
    //this is the place bidd function of the bidding contract
    function placeBid(address _user) public payable returns(bool){
        require(bidstatus==true,"bidding is already ended");
       require(msg.value>=minprice,"amount is less than min price");
       require(block.timestamp<endTime,"bidding is ended");
        if (PriceLedger[_user]<=0) {
            bidders.push(_user);
            PriceLedger[_user]=msg.value;
            if (PriceLedger[_user]>currentmaxvalue) {
                currentmaxvalue=PriceLedger[_user];
                currentmaxvalueAddress=_user;
            }
        }
        else{
            PriceLedger[msg.sender]=(PriceLedger[msg.sender])+msg.value;
            if (PriceLedger[msg.sender]>currentmaxvalue) {
                currentmaxvalue=PriceLedger[msg.sender];
                currentmaxvalueAddress=msg.sender;
            }
        }
        return true;
    }
    function priceledger(address _user) public view returns(uint256){
        return PriceLedger[_user];
    }

    function viewbidders() public view returns(address[] memory){
        return bidders;
    }
    //end bidding function
    function endbidding() public returns(bool){
        address d1;
        uint256 d2;
        (d1,d2) =(IERC2981(nftaddress).royaltyInfo(tokenId,currentmaxvalue));
        (bool getsuccess, ) = payable(d1).call{value: d2}("");
         require(getsuccess,"royalty is trasferred is not transferred");
        require(bidstatus==true,"bidding is already ended");
        bidstatus=false;
         (bool success, ) = payable(platform).call{value: (currentmaxvalue*2)/100}("");
         require(success,"platformfee is not transferred");
         (bool success1, ) = payable(creator).call{value: ((currentmaxvalue-(currentmaxvalue*2)/100))-d2}("");
         require(success1,"creatorfee is not transferred");
        IERC721(nftaddress).approve(currentmaxvalueAddress,tokenId);
        IERC721(nftaddress).transferFrom(address(this),currentmaxvalueAddress,tokenId);
        PriceLedger[currentmaxvalueAddress]=0;
        for (uint256 i=0; i<bidders.length; i++) 
        {
            (bool success2, ) = payable(bidders[i]).call{value: PriceLedger[bidders[i]]}("");
           require(success2=true,"");
             PriceLedger[bidders[i]]=0;
        }

        return true;
    }

function claimNft() public{
    if(block.timestamp>endTime){
        endbidding();
    }
    else{
        return;
    }
}
    
}
contract NftMarketplace is ReentrancyGuard {
    struct Listing {
        uint256 price;
        address seller;
    }

   event ItemListed(
        address indexed seller,
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 price
    );
    event ItemCanceled(
        address indexed seller,
        address indexed nftAddress,
        uint256 indexed tokenId
    );

 event ItemBought(
        address indexed buyer,
        address indexed nftAddress,
        uint256 indexed tokenId,
        uint256 price
    );
struct biddingInfo{
    address creator;
    address bidContract;
}

biddingInfo[] public biddinginfoarray;
address[] public biddingDataArray;
   // State Variables
   mapping(address=>address[]) public BiddingLedger;
   mapping(address => mapping(uint256 => Listing)) private s_listings;
   mapping(address => uint256) private s_proceeds;
//errors
error PriceNotMet(address nftAddress, uint256 tokenId, uint256 price);
error ItemNotForSale(address nftAddress, uint256 tokenId);
error NotListed(address nftAddress, uint256 tokenId);
error AlreadyListed(address nftAddress, uint256 tokenId);
error NoProceeds();
error NotOwner();
error NotApprovedForMarketplace();
error PriceMustBeAboveZero();
   // Function modifiers
   modifier notListed(
        address nftAddress,
        uint256 tokenId,
        address owner
   ) {
        Listing memory listing = s_listings[nftAddress][tokenId];
        if (listing.price > 0) {
            revert AlreadyListed(nftAddress, tokenId);
        }
        _;
    }

    modifier isOwner(
        address nftAddress,
        uint256 tokenId,
        address spender
    ) {
        IERC721 nft = IERC721(nftAddress);
        address owner = nft.ownerOf(tokenId);
        if (spender != owner) {
            revert NotOwner();
        }
        _;
    }
    modifier isListed(address nftAddress, uint256 tokenId) {
        Listing memory listing = s_listings[nftAddress][tokenId];
        if (listing.price <= 0) {
            revert NotListed(nftAddress, tokenId);
        }
        _;
    }
    function listItem(
        address nftAddress,
        uint256 tokenId,
        uint256 price
    )
        external
        notListed(nftAddress, tokenId, msg.sender)
        isOwner(nftAddress, tokenId, msg.sender)
    {
        if (price <= 0) {
            revert PriceMustBeAboveZero();
        }
        IERC721 nft = IERC721(nftAddress);
        if (nft.getApproved(tokenId) != address(this)) {
            revert NotApprovedForMarketplace();
        }
        s_listings[nftAddress][tokenId] = Listing(price, msg.sender);
        emit ItemListed(msg.sender, nftAddress, tokenId, price);
    }
    function cancelListing(address nftAddress, uint256 tokenId)
        external
        isOwner(nftAddress, tokenId, msg.sender)
        isListed(nftAddress, tokenId)
    {
        delete (s_listings[nftAddress][tokenId]);
        emit ItemCanceled(msg.sender, nftAddress, tokenId);
    }
    function buyItem(address nftAddress, uint256 tokenId)
        external
        payable
        isListed(nftAddress, tokenId)
        nonReentrant
    {
        Listing memory listedItem = s_listings[nftAddress][tokenId];
        if (msg.value < listedItem.price) {
            revert PriceNotMet(nftAddress, tokenId, listedItem.price);
        }
        s_proceeds[listedItem.seller] += msg.value;
        delete (s_listings[nftAddress][tokenId]);
        IERC721(nftAddress).safeTransferFrom(listedItem.seller, msg.sender, tokenId);
        emit ItemBought(msg.sender, nftAddress, tokenId, listedItem.price);
    }
    function withdrawProceeds() external {
        uint256 proceeds = s_proceeds[msg.sender];
        if (proceeds <= 0) {
            revert NoProceeds();
        }
        s_proceeds[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: proceeds}("");
        require(success, "Transfer failed");
    }
    function bid(address creator,address _nftAddress,uint _tokenId,uint256 _minPrice,uint256 _endTime) isListed(_nftAddress,_tokenId) public returns(address){
        bidding con=new bidding(creator,_nftAddress,_tokenId,_minPrice,_endTime);
        BiddingLedger[creator].push(address(con));
        biddinginfoarray.push(biddingInfo(creator,address(con)));
        IERC721(_nftAddress).transferFrom(creator,address(con),_tokenId);
        return address(con);
    }
    function placeBid(address payable biddincontractAddress,address user) payable  public{
        bidding biddingcontract=bidding(biddincontractAddress);
        biddingcontract.placeBid{value:msg.value}(user);  
    }
    function endbidd(address biddingcontractaddress) public returns(bool){
        bidding biddingcontract=bidding(biddingcontractaddress);
        biddingcontract.endbidding();
        return true;
    }
    function viewbidders(address biddingcontract) public view returns(address[] memory){
        bidding con=bidding(biddingcontract);
        return con.viewbidders();
    }
    function priceleger(address biddingcontract,address _user) public view returns(uint256){
         bidding con=bidding(biddingcontract);
         return con.priceledger(_user);
    }
    function claimNft(address biddingcontract) public{
        bidding con=bidding(biddingcontract);
        con.claimNft();
    }
}