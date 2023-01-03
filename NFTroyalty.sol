// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HamiNFT is ERC721URIStorage, ERC2981 {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  address public ownerContract;
  
  constructor() ERC721("HAMINFT","HN") {
    _setDefaultRoyalty(msg.sender, 100);
    ownerContract=msg.sender;
  }
  modifier onlyOwner() {  
              require(msg.sender == ownerContract,"you are not owner");  
                    _;    }
  function supportsInterface(bytes4 interfaceId)
    public view virtual override(ERC721, ERC2981)
    returns (bool) {
      return super.supportsInterface(interfaceId);
  }

  function _burn(uint256 tokenId) internal virtual override {
    super._burn(tokenId);
    _resetTokenRoyalty(tokenId);
  }

  function burnNFT(uint256 tokenId)
    public onlyOwner {
      _burn(tokenId);
  }

  function mintNFT(string memory _tokenURI,address recipient)
    private 
    returns (uint256) {
      _tokenIds.increment();
      uint256 newItemId = _tokenIds.current();
      _safeMint(recipient, newItemId);
      _setTokenURI(newItemId, _tokenURI);
      return newItemId;
  }
//this mintnftwithroyalty function will create nft with the royalty , the royaltyReceiver will receive the roylty whenever the nft will be sold
//fee numerator is the value you want to receive as the royalty 
/*
let say you want the 5% as the royalty
so fee numerator will be the 500
because the feeDenominator is 10000
*/
  function mintNFTWithRoyalty(string memory _tokenURI,address recipient, address royaltyReceiver, uint96 feeNumerator)
    public  payable 
    returns (uint256) {
      uint256 tokenId = mintNFT(_tokenURI,recipient);
      _setTokenRoyalty(tokenId, royaltyReceiver, feeNumerator);
      return tokenId;
  }
  function withdraw() onlyOwner public  returns(bool){
    (bool getsuccess, ) = payable(ownerContract).call{value: address(this).balance}("");
         require(getsuccess,"royalty is trasferred is not transferred");
         return true;
  }
}